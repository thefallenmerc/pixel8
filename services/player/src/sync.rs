use anyhow::{bail, Context, Result};
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use std::{
    collections::HashSet,
    path::{Path, PathBuf},
    sync::Mutex,
};

#[derive(Clone)]
pub struct Client {
    http: reqwest::Client,
    download_http: reqwest::Client,
    base: String,
    token: String,
    cache: PathBuf,
    quota: u64,
    playing_version: std::sync::Arc<Mutex<Option<u64>>>,
    state: std::sync::Arc<Mutex<(u64, Option<String>)>>,
    item_ids: std::sync::Arc<Mutex<Vec<String>>>,
    recovery_error: std::sync::Arc<Mutex<Option<String>>>,
    last_capabilities: std::sync::Arc<Mutex<Option<String>>>,
}
#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Pairing {
    pub pairing_id: String,
    pub code: String,
    pub poll_token: String,
    pub expires_at: String,
}
#[derive(Deserialize)]
pub struct PairingPoll {
    pub status: String,
    #[serde(rename = "deviceToken")]
    pub device_token: Option<String>,
    pub screen_id: Option<String>,
}
#[derive(Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Manifest {
    pub schema_version: u32,
    pub screen_id: String,
    pub version: u64,
    pub profile: String,
    pub orientation: u16,
    pub muted: bool,
    pub volume: u8,
    pub items: Vec<Item>,
}
#[derive(Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
struct CacheState {
    current_version: u64,
    previous_version: Option<u64>,
    #[serde(default)]
    playing_version: Option<u64>,
    #[serde(default)]
    playing_version_recorded: bool,
    #[serde(default)]
    ack_version: Option<u64>,
    #[serde(default)]
    ack_pending: bool,
    #[serde(default)]
    current_item_id: Option<String>,
    #[serde(default)]
    ack_status: Option<String>,
    #[serde(default)]
    ack_error: Option<String>,
}
#[derive(Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Item {
    pub id: String,
    pub asset_id: String,
    pub rendition_id: String,
    pub sha256: String,
    pub size_bytes: u64,
    pub duration_ms: u64,
}
#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
struct Grants {
    downloads: Vec<Grant>,
}
#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
struct Grant {
    rendition_id: String,
    url: String,
}
impl Client {
    pub fn new(c: crate::config::Config) -> Result<Self> {
        let client = Self {
            http: reqwest::Client::builder()
                .timeout(std::time::Duration::from_secs(20))
                .build()?,
            download_http: reqwest::Client::builder()
                .connect_timeout(std::time::Duration::from_secs(10))
                .read_timeout(std::time::Duration::from_secs(60))
                .build()?,
            base: c
                .api_base_url
                .unwrap_or_default()
                .trim_end_matches('/')
                .into(),
            token: c.device_token.unwrap_or_default(),
            cache: c.cache_dir.into(),
            quota: c.cache_quota_bytes,
            playing_version: std::sync::Arc::new(Mutex::new(None)),
            state: std::sync::Arc::new(Mutex::new((0, None))),
            item_ids: std::sync::Arc::new(Mutex::new(Vec::new())),
            recovery_error: std::sync::Arc::new(Mutex::new(None)),
            last_capabilities: std::sync::Arc::new(Mutex::new(None)),
        };
        client.load_cached_metadata()?;
        Ok(client)
    }
    pub fn event_hints(&self) -> tokio::sync::mpsc::Receiver<()> {
        use futures_util::StreamExt;
        use tokio_tungstenite::{
            connect_async,
            tungstenite::{
                client::IntoClientRequest,
                http::{header::AUTHORIZATION, HeaderValue},
                Message,
            },
        };
        let base = self
            .base
            .replace("https://", "wss://")
            .replace("http://", "ws://");
        let url = format!("{base}/v1/device/events");
        let token = self.token.clone();
        let (tx, rx) = tokio::sync::mpsc::channel(1);
        if self.base.is_empty() || self.token.is_empty() {
            return rx;
        }
        tokio::spawn(async move {
            loop {
                let connection = url.clone().into_client_request().ok().and_then(|mut r| {
                    r.headers_mut().insert(
                        AUTHORIZATION,
                        HeaderValue::from_str(&format!("Bearer {token}")).ok()?,
                    );
                    Some(r)
                });
                if let Some(request) = connection {
                    if let Ok((mut socket, _)) = connect_async(request).await {
                        while let Some(Ok(message)) = socket.next().await {
                            if matches!(message, Message::Text(_) | Message::Binary(_)) {
                                let _ = tx.try_send(());
                            }
                        }
                    }
                }
                tokio::time::sleep(std::time::Duration::from_secs(3)).await;
            }
        });
        rx
    }
    pub async fn reconcile(
        &self,
        cfg: &mut crate::config::Config,
        renderer: &mut crate::player::GstRenderer,
        config_path: &Path,
    ) -> Result<()> {
        anyhow::ensure!(!self.base.is_empty(), "api_base_url is not configured");
        anyhow::ensure!(!self.token.is_empty(), "device is not paired");
        std::fs::create_dir_all(&self.cache)?;
        // A lost ACK belongs to the last committed/actually playing generation.
        // Retry it before looking up a possibly newer desired version.
        if let Err(error) = self.retry_pending_ack().await {
            eprintln!(
                "{{\"level\":\"warn\",\"component\":\"ack\",\"message\":{:?}}}",
                error.to_string().chars().take(512).collect::<String>()
            );
        }
        // Report the current display before asking the server to choose a
        // manifest. A new process always reports once; unchanged capabilities
        // are skipped only after a successful PUT.
        let capabilities = serde_json::to_string(&crate::device::capabilities())?;
        if self.last_capabilities.lock().unwrap().as_deref() != Some(capabilities.as_str()) {
            let body: serde_json::Value = serde_json::from_str(&capabilities)?;
            self.http
                .put(format!("{}/v1/device/capabilities", self.base))
                .bearer_auth(&self.token)
                .json(&body)
                .send()
                .await
                .context("device capabilities update failed")?
                .error_for_status()
                .context("device capabilities update failed")?;
            *self.last_capabilities.lock().unwrap() = Some(capabilities);
        }
        let req = self
            .http
            .get(format!("{}/v1/device/manifest", self.base))
            .bearer_auth(&self.token);
        let response = req.send().await?;
        if response.status() == reqwest::StatusCode::NO_CONTENT {
            return Ok(());
        }
        let m: Manifest = response.error_for_status()?.json().await?;
        if m.schema_version != 1 {
            bail!("unsupported manifest schema {}", m.schema_version)
        }
        self.state.lock().unwrap().0 = m.version;
        if *self.playing_version.lock().unwrap() == Some(m.version) {
            *self.recovery_error.lock().unwrap() = None;
            let status = if m.items.is_empty() {
                "idle"
            } else {
                "playing"
            };
            let (index, _, _) = renderer.metrics().snapshot();
            let ids = self.item_ids.lock().unwrap().clone();
            let item_id = if m.items.is_empty() {
                None
            } else {
                ids.get(index.min(ids.len().saturating_sub(1))).cloned()
            };
            write_state(&self.cache, m.version, item_id.clone(), Some(status))?;
            *self.state.lock().unwrap() = (m.version, item_id);
            self.retry_pending_ack().await?;
            return Ok(());
        }
        if m.items.is_empty() {
            if let Err(e) = write_generation(&self.cache, &m) {
                self.restore_committed(renderer)?;
                return Err(e);
            }
            if let Err(e) = renderer.stop() {
                self.restore_committed(renderer)?;
                return Err(e);
            }
            if let Err(e) = self.collect(&m) {
                self.restore_committed(renderer)?;
                return Err(e);
            }
            if let Err(e) = write_state(&self.cache, m.version, None, Some("idle")) {
                self.restore_committed(renderer)?;
                return Err(e);
            }
            *self.state.lock().unwrap() = (m.version, None);
            *self.item_ids.lock().unwrap() = Vec::new();
            *self.playing_version.lock().unwrap() = Some(m.version);
            *self.recovery_error.lock().unwrap() = None;
            self.retry_pending_ack().await?;
            return Ok(());
        }
        self.ack_status(m.version, "downloading", None, None, None)
            .await?;
        let mut missing = Vec::new();
        let mut missing_hashes = HashSet::new();
        for i in &m.items {
            let p = self.cache.join(format!("{}.media", i.sha256));
            if !p.exists() || hash_file(&p)? != i.sha256 {
                if missing_hashes.insert(i.sha256.clone()) {
                    missing.push(i)
                }
            }
        }
        if !missing.is_empty() {
            let unique: HashSet<String> = missing.iter().map(|i| i.rendition_id.clone()).collect();
            let mut sizes = std::collections::HashMap::<String, u64>::new();
            for item in &missing {
                sizes.entry(item.sha256.clone()).or_insert(item.size_bytes);
            }
            let additional: u64 = sizes.values().sum();
            self.collect_reserving(&m, additional)?;
            let used = directory_bytes(&self.cache)?;
            anyhow::ensure!(
                used.saturating_add(additional) <= self.quota,
                "manifest exceeds configured cache quota"
            );
            let grants: Grants = self
                .http
                .post(format!("{}/v1/device/downloads", self.base))
                .bearer_auth(&self.token)
                .json(&serde_json::json!({"renditionIds":unique}))
                .send()
                .await?
                .error_for_status()?
                .json()
                .await?;
            for item in missing {
                let mut grant = grants
                    .downloads
                    .iter()
                    .find(|d| d.rendition_id == item.rendition_id)
                    .context("server omitted authorized rendition grant")?;
                if let Err(e) = download_verified(
                    &self.download_http,
                    &grant.url,
                    item,
                    &self.cache,
                    self.quota,
                )
                .await
                {
                    if !e.to_string().contains("download grant expired") {
                        return Err(e);
                    }
                    let refreshed: Grants = self
                        .http
                        .post(format!("{}/v1/device/downloads", self.base))
                        .bearer_auth(&self.token)
                        .json(&serde_json::json!({"renditionIds":[item.rendition_id]}))
                        .send()
                        .await?
                        .error_for_status()?
                        .json()
                        .await?;
                    grant = refreshed
                        .downloads
                        .iter()
                        .find(|d| d.rendition_id == item.rendition_id)
                        .context("server omitted refreshed download grant")?;
                    download_verified(
                        &self.download_http,
                        &grant.url,
                        item,
                        &self.cache,
                        self.quota,
                    )
                    .await?;
                }
            }
        }
        // Downloads may race a newer assignment. Only activate the version that is still authoritative.
        let latest = self
            .http
            .get(format!("{}/v1/device/manifest", self.base))
            .bearer_auth(&self.token)
            .send()
            .await?;
        if latest.status() == reqwest::StatusCode::NO_CONTENT {
            return Ok(());
        }
        let latest: Manifest = latest.error_for_status()?.json().await?;
        if latest.version != m.version {
            return Ok(());
        }
        write_generation(&self.cache, &m)?;
        let playlist = m
            .items
            .iter()
            .map(|i| self.cache.join(format!("{}.media", i.sha256)))
            .collect::<Vec<_>>();
        if let Err(e) = renderer.start_playlist(&playlist, m.muted, m.volume) {
            self.restore_committed(renderer)?;
            return Err(e);
        }
        let check = async {
            let r = self
                .http
                .get(format!("{}/v1/device/manifest", self.base))
                .bearer_auth(&self.token)
                .send()
                .await?;
            if r.status() == reqwest::StatusCode::NO_CONTENT {
                return Ok::<bool, anyhow::Error>(false);
            }
            Ok(r.error_for_status()?.json::<Manifest>().await?.version == m.version)
        }
        .await;
        let still_current = match check {
            Ok(v) => v,
            Err(e) => {
                self.restore_committed(renderer)?;
                return Err(e);
            }
        };
        if !still_current {
            self.restore_committed(renderer)?;
            return Ok(());
        }
        if let Err(e) = self.collect(&m) {
            self.restore_committed(renderer)?;
            return Err(e);
        }
        let (current_index, _, _) = renderer.metrics().snapshot();
        let current_item_id = m.items.get(current_index).map(|item| item.id.clone());
        if let Err(e) = write_state(
            &self.cache,
            m.version,
            current_item_id.clone(),
            Some("playing"),
        ) {
            self.restore_committed(renderer)?;
            return Err(e);
        }
        *self.playing_version.lock().unwrap() = Some(m.version);
        *self.state.lock().unwrap() = (m.version, current_item_id);
        *self.item_ids.lock().unwrap() = m.items.iter().map(|i| i.id.clone()).collect();
        *self.recovery_error.lock().unwrap() = None;
        self.retry_pending_ack().await?;
        let _ = (&mut *cfg, config_path);
        Ok(())
    }
    fn load_cached_metadata(&self) -> Result<()> {
        let path = self.cache.join("STATE.json");
        if !path.exists() {
            return Ok(());
        }
        let state: CacheState = serde_json::from_slice(&std::fs::read(path)?)?;
        if let Some(m) = load_generation(&self.cache, &state) {
            *self.state.lock().unwrap() = (
                if state.ack_pending {
                    state.ack_version.unwrap_or(state.current_version)
                } else {
                    state.current_version
                },
                state
                    .current_item_id
                    .clone()
                    .filter(|id| m.items.iter().any(|item| &item.id == id))
                    .or_else(|| m.items.first().map(|i| i.id.clone())),
            );
            *self.item_ids.lock().unwrap() = m.items.iter().map(|i| i.id.clone()).collect();
            // Loading hashes is metadata, not proof that the renderer started.
            *self.playing_version.lock().unwrap() = None;
        }
        Ok(())
    }
    async fn retry_pending_ack(&self) -> Result<()> {
        let path = self.cache.join("STATE.json");
        if !path.exists() {
            return Ok(());
        }
        let mut state: CacheState = serde_json::from_slice(&std::fs::read(&path)?)?;
        if !state.ack_pending {
            return Ok(());
        }
        self.ack_status(
            state.ack_version.unwrap_or(state.current_version),
            state.ack_status.as_deref().unwrap_or("playing"),
            if state.ack_status.as_deref() == Some("error") && state.playing_version.is_none() {
                None
            } else {
                state.current_item_id.clone()
            },
            state.ack_error.clone(),
            (state.ack_status.as_deref() == Some("error")).then_some(state.playing_version),
        )
        .await?;
        state.ack_pending = false;
        state.ack_status = None;
        state.ack_error = None;
        state.ack_version = None;
        write_state_record(&self.cache, &state)
    }
    async fn ack_status(
        &self,
        version: u64,
        status: &str,
        current_item_id: Option<String>,
        error: Option<String>,
        playing_version: Option<Option<u64>>,
    ) -> Result<()> {
        let mut body = serde_json::json!({"version": version, "status": status});
        if let Some(id) = current_item_id {
            body["currentItemId"] = serde_json::Value::String(id);
        }
        if let Some(error) = error {
            body["error"] = serde_json::Value::String(error.chars().take(512).collect());
        }
        if let Some(playing_version) = playing_version {
            body["playingVersion"] = serde_json::to_value(playing_version)?;
        }
        self.http
            .post(format!("{}/v1/device/ack", self.base))
            .bearer_auth(&self.token)
            .json(&body)
            .send()
            .await
            .context("device ack failed")?
            .error_for_status()
            .context("device ack failed")?;
        Ok(())
    }
    pub async fn report_reconcile_error(&self, error: &str) -> Result<()> {
        if error.contains("device ack failed") {
            return Ok(());
        }
        let version = self.state.lock().unwrap().0;
        if version == 0 {
            return Ok(());
        }
        let error = error.chars().take(512).collect::<String>();
        let playing_version = *self.playing_version.lock().unwrap();
        *self.recovery_error.lock().unwrap() = Some(error.clone());
        let state_path = self.cache.join("STATE.json");
        let mut state: CacheState = if state_path.exists() {
            serde_json::from_slice(&std::fs::read(&state_path)?)?
        } else {
            CacheState {
                current_version: version,
                previous_version: None,
                playing_version: None,
                playing_version_recorded: true,
                ack_version: None,
                ack_pending: false,
                current_item_id: None,
                ack_status: None,
                ack_error: None,
            }
        };
        let item_id = playing_version.and_then(|playing| {
            read_generation(&self.cache, playing)
                .ok()
                .and_then(|manifest| {
                    state
                        .current_item_id
                        .clone()
                        .filter(|id| manifest.items.iter().any(|item| &item.id == id))
                        .or_else(|| manifest.items.first().map(|item| item.id.clone()))
                })
        });
        state.current_item_id = item_id;
        state.playing_version = playing_version;
        state.playing_version_recorded = true;
        state.ack_pending = true;
        state.ack_version = Some(version);
        state.ack_status = Some("error".into());
        state.ack_error = Some(error);
        write_state_record(&self.cache, &state)?;
        self.retry_pending_ack().await
    }
    pub async fn restore(&self, renderer: &mut crate::player::GstRenderer) -> Result<()> {
        let state_path = self.cache.join("STATE.json");
        if !state_path.exists() {
            *self.playing_version.lock().unwrap() = None;
            renderer.stop()?;
            return Ok(());
        }
        let state: CacheState = serde_json::from_slice(&std::fs::read(state_path)?)?;
        let desired_version = state.current_version;
        let selected = load_generation(&self.cache, &state);
        let Some(m) = selected else {
            *self.playing_version.lock().unwrap() = None;
            renderer.stop()?;
            *self.item_ids.lock().unwrap() = Vec::new();
            let mut failed = state.clone();
            failed.playing_version = None;
            failed.playing_version_recorded = true;
            failed.current_item_id = None;
            write_state_record(&self.cache, &failed)?;
            return Ok(());
        };
        let mut actual_item = state
            .current_item_id
            .clone()
            .filter(|id| m.items.iter().any(|item| &item.id == id))
            .or_else(|| m.items.first().map(|i| i.id.clone()));
        *self.state.lock().unwrap() = (desired_version, actual_item.clone());
        *self.item_ids.lock().unwrap() = m.items.iter().map(|i| i.id.clone()).collect();
        if m.items.is_empty() {
            renderer.stop()?;
        } else {
            let paths = m
                .items
                .iter()
                .map(|i| self.cache.join(format!("{}.media", i.sha256)))
                .collect::<Vec<_>>();
            if let Err(error) = renderer.start_playlist(&paths, m.muted, m.volume) {
                // A matching hash proves storage integrity, not that this
                // device's runtime decoder can open the cached rendition.
                // Reuse the normal fallback and durable error-ACK path on boot.
                let _ = self
                    .recover_renderer_error(renderer, &error.to_string())
                    .await;
                return Ok(());
            }
            let (index, _, _) = renderer.metrics().snapshot();
            actual_item = m.items.get(index).map(|item| item.id.clone());
        }
        *self.state.lock().unwrap() = (desired_version, actual_item.clone());
        *self.playing_version.lock().unwrap() = Some(m.version);
        let mut restored = state;
        restored.playing_version = Some(m.version);
        restored.playing_version_recorded = true;
        restored.current_item_id = actual_item;
        write_state_record(&self.cache, &restored)?;
        Ok(())
    }
    fn restore_committed(&self, renderer: &mut crate::player::GstRenderer) -> Result<()> {
        let desired_version = self.state.lock().unwrap().0;
        let path = self.cache.join("STATE.json");
        if !path.exists() {
            *self.playing_version.lock().unwrap() = None;
            renderer.stop()?;
            return Ok(());
        }
        let state: CacheState = match std::fs::read(path)
            .context("read committed player state")
            .and_then(|bytes| {
                serde_json::from_slice(&bytes).context("parse committed player state")
            }) {
            Ok(state) => state,
            Err(_) => {
                *self.playing_version.lock().unwrap() = None;
                renderer.stop()?;
                return Ok(());
            }
        };
        let persisted_desired = if state.ack_pending {
            state.ack_version.unwrap_or(state.current_version)
        } else {
            state.current_version
        };
        let desired_version = desired_version.max(persisted_desired);
        let Some(m) = load_generation(&self.cache, &state) else {
            *self.playing_version.lock().unwrap() = None;
            renderer.stop()?;
            let mut failed = state;
            failed.playing_version = None;
            failed.playing_version_recorded = true;
            failed.current_item_id = None;
            write_state_record(&self.cache, &failed)?;
            return Ok(());
        };
        if m.items.is_empty() {
            renderer.stop()?;
        } else {
            let p = m
                .items
                .iter()
                .map(|i| self.cache.join(format!("{}.media", i.sha256)))
                .collect::<Vec<_>>();
            if let Err(error) = renderer.start_playlist(&p, m.muted, m.volume) {
                *self.playing_version.lock().unwrap() = None;
                renderer.stop()?;
                return Err(error);
            }
        }
        let current_item = if m.items.is_empty() {
            None
        } else {
            let (index, _, _) = renderer.metrics().snapshot();
            m.items.get(index).map(|item| item.id.clone())
        };
        *self.playing_version.lock().unwrap() = Some(m.version);
        *self.state.lock().unwrap() = (desired_version, current_item.clone());
        *self.item_ids.lock().unwrap() = m.items.iter().map(|item| item.id.clone()).collect();
        let mut restored = state;
        restored.playing_version = Some(m.version);
        restored.playing_version_recorded = true;
        restored.current_item_id = current_item;
        write_state_record(&self.cache, &restored)?;
        Ok(())
    }
    pub async fn send_telemetry(
        &self,
        collector: &mut crate::telemetry::Collector,
        renderer: &crate::player::RendererMetrics,
    ) -> Result<()> {
        anyhow::ensure!(
            !self.base.is_empty() && !self.token.is_empty(),
            "device is not paired or API URL is missing"
        );
        std::fs::create_dir_all(&self.cache)?;
        let (desired, _) = self.state.lock().unwrap().clone();
        if desired == 0 {
            return Ok(());
        }
        let playing = *self.playing_version.lock().unwrap();
        let error = self.recovery_error.lock().unwrap().clone();
        let (playlist_index, dropped_frames, decoder) = renderer.snapshot();
        let item = {
            let ids = self.item_ids.lock().unwrap();
            ids.get(playlist_index.min(ids.len().saturating_sub(1)))
                .cloned()
        };
        if error.is_none() && playing == Some(desired) {
            if let Some(ref id) = item {
                let changed = {
                    let current = self.state.lock().unwrap();
                    current.1.as_ref() != Some(id)
                };
                if changed {
                    let acked = self.http
                        .post(format!("{}/v1/device/ack", self.base))
                        .bearer_auth(&self.token)
                        .json(&serde_json::json!({"version":desired,"status":"playing","currentItemId":id}))
                        .send()
                        .await
                        .and_then(reqwest::Response::error_for_status)
                        .is_ok();
                    if acked {
                        let mut current = self.state.lock().unwrap();
                        if current.0 == desired {
                            current.1 = Some(id.clone());
                        }
                    }
                }
            }
        }
        let sample = collector.sample(
            &self.cache,
            desired,
            playing,
            item,
            error,
            dropped_frames,
            decoder,
        )?;
        let spool = self.cache.join("telemetry.jsonl");
        let mut samples = Vec::<serde_json::Value>::new();
        if let Ok(data) = std::fs::read_to_string(&spool) {
            samples.extend(data.lines().filter_map(|l| serde_json::from_str(l).ok()));
        }
        samples.push(serde_json::to_value(&sample)?);
        if samples.len() > 500 {
            samples.drain(..samples.len() - 500);
        }
        let (batch, remaining) = telemetry_batch(&samples);
        let response = self
            .http
            .post(format!("{}/v1/device/telemetry", self.base))
            .bearer_auth(&self.token)
            .json(&serde_json::json!({"samples":batch}))
            .send()
            .await;
        match response {
            Ok(r) if r.status().is_success() => {
                if remaining.is_empty() {
                    let _ = std::fs::remove_file(spool);
                } else {
                    write_spool_values(&spool, remaining)?;
                }
                Ok(())
            }
            Ok(r) => {
                crate::telemetry::append_spool(&spool, &sample)?;
                bail!("telemetry endpoint returned {}", r.status())
            }
            Err(e) => {
                crate::telemetry::append_spool(&spool, &sample)?;
                Err(e.into())
            }
        }
    }
    pub async fn recover_renderer_error(
        &self,
        renderer: &mut crate::player::GstRenderer,
        message: &str,
    ) -> Result<()> {
        let state_path = self.cache.join("STATE.json");
        let state: CacheState = serde_json::from_slice(&std::fs::read(state_path)?)?;
        let message = message.chars().take(512).collect::<String>();
        let fallback = state.previous_version.and_then(|v| {
            read_generation(&self.cache, v)
                .ok()
                .filter(|m| valid_generation(&self.cache, m))
        });
        // Publish the local failure immediately, even when the network is down.
        *self.recovery_error.lock().unwrap() = Some(message.clone());
        *self.playing_version.lock().unwrap() = None;
        let recovered_item = if let Some(m) = fallback {
            let started = if m.items.is_empty() {
                renderer.stop()
            } else {
                let paths = m
                    .items
                    .iter()
                    .map(|i| self.cache.join(format!("{}.media", i.sha256)))
                    .collect::<Vec<_>>();
                renderer.start_playlist(&paths, m.muted, m.volume)
            };
            if started.is_ok() {
                *self.item_ids.lock().unwrap() = m.items.iter().map(|i| i.id.clone()).collect();
                *self.playing_version.lock().unwrap() = Some(m.version);
                m.items.first().map(|i| i.id.clone())
            } else {
                renderer.stop()?;
                *self.item_ids.lock().unwrap() = Vec::new();
                None
            }
        } else {
            renderer.stop()?;
            *self.item_ids.lock().unwrap() = Vec::new();
            None
        };
        *self.state.lock().unwrap() = (state.current_version, recovered_item.clone());
        // Queue an error ACK durably, then try it. The playing version above
        // always describes what the renderer actually managed to start.
        let mut recorded = state;
        recorded.current_item_id = recovered_item;
        recorded.playing_version = *self.playing_version.lock().unwrap();
        recorded.playing_version_recorded = true;
        recorded.ack_pending = true;
        recorded.ack_version = Some(recorded.current_version);
        recorded.ack_status = Some("error".into());
        recorded.ack_error = Some(message.clone());
        write_state_record(&self.cache, &recorded)?;
        self.retry_pending_ack().await?;
        Ok(())
    }
    fn collect(&self, m: &Manifest) -> Result<()> {
        self.collect_reserving(m, 0)
    }
    fn collect_reserving(&self, m: &Manifest, reserve_bytes: u64) -> Result<()> {
        let mut pinned: HashSet<String> = m
            .items
            .iter()
            .map(|i| format!("{}.media", i.sha256))
            .collect();
        if let Ok(bytes) = std::fs::read(self.cache.join("STATE.json")) {
            if let Ok(state) = serde_json::from_slice::<CacheState>(&bytes) {
                for v in [Some(state.current_version), state.previous_version]
                    .into_iter()
                    .flatten()
                {
                    if let Ok(old) = read_generation(&self.cache, v) {
                        pinned.extend(old.items.iter().map(|i| format!("{}.media", i.sha256)));
                    }
                }
            }
        }
        let mut entries = std::fs::read_dir(&self.cache)?
            .flatten()
            .filter_map(|e| {
                let md = e.metadata().ok()?;
                if !md.is_file() {
                    return None;
                }
                Some((e.path(), md.len(), md.modified().ok()?))
            })
            .collect::<Vec<_>>();
        let total: u64 = entries.iter().map(|e| e.1).sum();
        entries.sort_by_key(|e| e.2);
        let mut size = total;
        let target = self.quota.saturating_sub(reserve_bytes);
        for (p, n, _) in entries {
            if size <= target {
                break;
            }
            if p.file_name()
                .and_then(|s| s.to_str())
                .is_some_and(|s| pinned.contains(s) || s == "STATE.json" || s == "telemetry.jsonl")
            {
                continue;
            }
            std::fs::remove_file(p)?;
            size = size.saturating_sub(n);
        }
        let mut versions = HashSet::from([m.version]);
        if let Ok(bytes) = std::fs::read(self.cache.join("STATE.json")) {
            if let Ok(s) = serde_json::from_slice::<CacheState>(&bytes) {
                versions.insert(s.current_version);
                if let Some(v) = s.previous_version {
                    versions.insert(v);
                }
            }
        }
        let manifests = self.cache.join("manifests");
        if let Ok(files) = std::fs::read_dir(manifests) {
            for f in files.flatten() {
                if f.path().extension().is_some_and(|x| x == "json") {
                    let keep = f
                        .path()
                        .file_stem()
                        .and_then(|s| s.to_str())
                        .and_then(|s| s.parse::<u64>().ok())
                        .is_some_and(|v| versions.contains(&v));
                    if !keep {
                        std::fs::remove_file(f.path())?;
                    }
                }
            }
        }
        Ok(())
    }
}
async fn download_verified(
    http: &reqwest::Client,
    url: &str,
    item: &Item,
    cache: &Path,
    quota: u64,
) -> Result<()> {
    use tokio::io::AsyncWriteExt;
    let temp = cache.join(format!("{}.{}.part", item.sha256, uuid::Uuid::new_v4()));
    let baseline = directory_bytes(cache)?;
    let result = async {
        let mut response = http.get(url).send().await?;
        let status = response.status();
        if status == reqwest::StatusCode::UNAUTHORIZED || status == reqwest::StatusCode::FORBIDDEN {
            bail!("download grant expired ({status})")
        }
        response.error_for_status_ref()?;
        anyhow::ensure!(
            item.size_bytes <= available_bytes(cache)?,
            "insufficient free disk space for rendition"
        );
        let mut f = tokio::fs::File::create(&temp).await?;
        let mut hash = Sha256::new();
        let mut count = 0u64;
        while let Some(chunk) = response.chunk().await? {
            count = count.saturating_add(chunk.len() as u64);
            anyhow::ensure!(count <= item.size_bytes, "download exceeded manifest size");
            anyhow::ensure!(
                baseline.saturating_add(count) <= quota,
                "download exceeds configured cache quota"
            );
            hash.update(&chunk);
            f.write_all(&chunk).await?;
        }
        f.flush().await?;
        f.sync_all().await?;
        anyhow::ensure!(
            count == item.size_bytes && hex::encode(hash.finalize()) == item.sha256,
            "download size or SHA-256 mismatch"
        );
        tokio::fs::rename(&temp, cache.join(format!("{}.media", item.sha256))).await?;
        Ok::<(), anyhow::Error>(())
    }
    .await;
    if result.is_err() {
        let _ = tokio::fs::remove_file(&temp).await;
    }
    result
}
fn hash_file(path: &Path) -> Result<String> {
    use std::io::Read;
    let mut f = std::fs::File::open(path)?;
    let mut h = Sha256::new();
    let mut buf = [0u8; 128 * 1024];
    loop {
        let n = f.read(&mut buf)?;
        if n == 0 {
            break;
        }
        h.update(&buf[..n]);
    }
    Ok(hex::encode(h.finalize()))
}
fn write_generation(cache: &Path, m: &Manifest) -> Result<()> {
    let dir = cache.join("manifests");
    std::fs::create_dir_all(&dir)?;
    let path = dir.join(format!("{}.json", m.version));
    let bytes = serde_json::to_vec(m)?;
    if path.exists() {
        anyhow::ensure!(
            std::fs::read(path)? == bytes,
            "immutable manifest version was reused with different content"
        );
        return Ok(());
    }
    let temp = dir.join(format!("{}.{}.tmp", m.version, uuid::Uuid::new_v4()));
    std::fs::write(&temp, &bytes)?;
    std::fs::File::open(&temp)?.sync_all()?;
    std::fs::rename(temp, path)?;
    std::fs::File::open(dir)?.sync_all()?;
    Ok(())
}
fn read_generation(cache: &Path, version: u64) -> Result<Manifest> {
    Ok(serde_json::from_slice(&std::fs::read(
        cache.join("manifests").join(format!("{version}.json")),
    )?)?)
}
fn valid_generation(cache: &Path, m: &Manifest) -> bool {
    m.items.iter().all(|i| {
        let path = cache.join(format!("{}.media", i.sha256));
        path.exists() && hash_file(&path).is_ok_and(|h| h == i.sha256)
    })
}
fn valid_version(cache: &Path, version: u64) -> bool {
    read_generation(cache, version).is_ok_and(|m| valid_generation(cache, &m))
}
fn load_generation(cache: &Path, state: &CacheState) -> Option<Manifest> {
    read_generation(cache, state.current_version)
        .ok()
        .filter(|m| valid_generation(cache, m))
        .or_else(|| {
            state.previous_version.and_then(|v| {
                read_generation(cache, v)
                    .ok()
                    .filter(|m| valid_generation(cache, m))
            })
        })
}
fn write_state(
    cache: &Path,
    version: u64,
    item_id: Option<String>,
    ack_status: Option<&str>,
) -> Result<()> {
    let old = cache.join("STATE.json");
    let previous = if old.exists() {
        serde_json::from_slice::<CacheState>(&std::fs::read(&old)?)
            .ok()
            .map(|s| {
                if s.playing_version_recorded {
                    s.playing_version
                        .filter(|v| valid_version(cache, *v))
                        .or_else(|| {
                            s.playing_version
                                .and_then(|_| load_generation(cache, &s).map(|m| m.version))
                        })
                } else {
                    load_generation(cache, &s).map(|m| m.version)
                }
            })
            .flatten()
    } else {
        None
    };
    let state = CacheState {
        current_version: version,
        previous_version: previous.filter(|v| *v != version),
        playing_version: Some(version),
        playing_version_recorded: true,
        ack_version: ack_status.map(|_| version),
        ack_pending: ack_status.is_some(),
        current_item_id: item_id,
        ack_status: ack_status.map(str::to_owned),
        ack_error: None,
    };
    write_state_record(cache, &state)
}
fn write_state_record(cache: &Path, state: &CacheState) -> Result<()> {
    let old = cache.join("STATE.json");
    let temp = cache.join(format!("STATE.{}.tmp", uuid::Uuid::new_v4()));
    std::fs::write(&temp, serde_json::to_vec(&state)?)?;
    std::fs::File::open(&temp)?.sync_all()?;
    std::fs::rename(temp, old)?;
    std::fs::File::open(cache)?.sync_all()?;
    Ok(())
}
fn directory_bytes(p: &Path) -> Result<u64> {
    let mut total = 0u64;
    for e in std::fs::read_dir(p)?.flatten() {
        let md = e.metadata()?;
        if md.is_file() {
            total = total.saturating_add(md.len())
        } else if md.is_dir() {
            for f in std::fs::read_dir(e.path())?.flatten() {
                if f.metadata().is_ok_and(|m| m.is_file()) {
                    total = total.saturating_add(f.metadata()?.len());
                }
            }
        }
    }
    Ok(total)
}
fn available_bytes(p: &Path) -> Result<u64> {
    let c = std::ffi::CString::new(p.as_os_str().as_encoded_bytes())?;
    let mut s = unsafe { std::mem::zeroed::<libc::statvfs>() };
    anyhow::ensure!(
        unsafe { libc::statvfs(c.as_ptr(), &mut s) } == 0,
        "cannot determine free disk space"
    );
    Ok(s.f_bavail as u64 * s.f_frsize as u64)
}
fn write_spool_values(path: &Path, values: &[serde_json::Value]) -> Result<()> {
    use std::io::Write;
    let tmp = path.with_extension("jsonl.tmp");
    let mut file = std::fs::File::create(&tmp)?;
    for value in values {
        writeln!(file, "{}", serde_json::to_string(value)?)?;
    }
    file.sync_all()?;
    std::fs::rename(tmp, path)?;
    Ok(())
}
fn telemetry_batch(samples: &[serde_json::Value]) -> (&[serde_json::Value], &[serde_json::Value]) {
    let end = samples.len().min(100);
    (&samples[..end], &samples[end..])
}

#[cfg(test)]
mod tests {
    use super::*;
    use tokio::{
        io::{AsyncReadExt, AsyncWriteExt},
        net::TcpListener,
    };
    #[test]
    fn shared_manifest_fixtures_match_wire_structs() {
        let full: Manifest = serde_json::from_str(include_str!(
            "../../../packages/contracts/fixtures/manifest.json"
        ))
        .unwrap();
        let empty: Manifest = serde_json::from_str(include_str!(
            "../../../packages/contracts/fixtures/manifest-empty.json"
        ))
        .unwrap();
        assert_eq!(full.version, 7);
        assert_eq!(full.items.len(), 1);
        assert_eq!(empty.version, 8);
        assert!(empty.items.is_empty());
    }
    async fn one_shot(body: Vec<u8>) -> String {
        let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
        let addr = listener.local_addr().unwrap();
        tokio::spawn(async move {
            let (mut stream, _) = listener.accept().await.unwrap();
            let mut request = [0u8; 1024];
            let _ = stream.read(&mut request).await;
            let header = format!(
                "HTTP/1.1 200 OK\r\nContent-Length: {}\r\nConnection: close\r\n\r\n",
                body.len()
            );
            let _ = stream.write_all(header.as_bytes()).await;
            let _ = stream.write_all(&body).await;
        });
        format!("http://{addr}/asset")
    }
    #[test]
    fn telemetry_batches_respect_api_limit_and_keep_remainder() {
        let values = (0..257)
            .map(|n| serde_json::json!({"n": n}))
            .collect::<Vec<_>>();
        let (first, rest) = telemetry_batch(&values);
        assert_eq!(first.len(), 100);
        assert_eq!(rest.len(), 157);
        assert_eq!(first[0]["n"], 0);
        assert_eq!(rest[0]["n"], 100);
    }
    #[tokio::test]
    async fn reconcile_error_before_first_manifest_does_not_queue_unknown_version() {
        let d = tempfile::tempdir().unwrap();
        let client = Client {
            http: reqwest::Client::new(),
            download_http: reqwest::Client::new(),
            base: "http://127.0.0.1:1".into(),
            token: "test-token".into(),
            cache: d.path().into(),
            quota: 1024,
            playing_version: std::sync::Arc::new(Mutex::new(None)),
            state: std::sync::Arc::new(Mutex::new((0, None))),
            item_ids: std::sync::Arc::new(Mutex::new(Vec::new())),
            recovery_error: std::sync::Arc::new(Mutex::new(None)),
            last_capabilities: std::sync::Arc::new(Mutex::new(None)),
        };
        client
            .report_reconcile_error("API is temporarily unavailable")
            .await
            .unwrap();
        assert!(!d.path().join("STATE.json").exists());
        assert_eq!(*client.recovery_error.lock().unwrap(), None);
    }
    #[tokio::test]
    async fn ack_transport_errors_keep_ack_context() {
        let d = tempfile::tempdir().unwrap();
        let client = Client {
            http: reqwest::Client::new(),
            download_http: reqwest::Client::new(),
            base: "http://127.0.0.1:1".into(),
            token: "test-token".into(),
            cache: d.path().into(),
            quota: 1024,
            playing_version: std::sync::Arc::new(Mutex::new(None)),
            state: std::sync::Arc::new(Mutex::new((0, None))),
            item_ids: std::sync::Arc::new(Mutex::new(Vec::new())),
            recovery_error: std::sync::Arc::new(Mutex::new(None)),
            last_capabilities: std::sync::Arc::new(Mutex::new(None)),
        };
        let error = client
            .ack_status(1, "playing", None, None, None)
            .await
            .unwrap_err();
        assert!(error.to_string().contains("device ack failed"));
    }
    fn item(data: &[u8], size: u64) -> Item {
        Item {
            id: "item-1".into(),
            asset_id: "asset-1".into(),
            rendition_id: "rendition-1".into(),
            sha256: hex::encode(Sha256::digest(data)),
            size_bytes: size,
            duration_ms: 1000,
        }
    }
    #[test]
    fn state_rotation_keeps_last_good_generation() {
        let d = tempfile::tempdir().unwrap();
        let empty = Manifest {
            schema_version: 1,
            screen_id: "screen".into(),
            version: 7,
            profile: "720p30-v1".into(),
            orientation: 0,
            muted: true,
            volume: 0,
            items: vec![],
        };
        write_generation(d.path(), &empty).unwrap();
        write_generation(
            d.path(),
            &Manifest {
                version: 8,
                ..empty
            },
        )
        .unwrap();
        write_state(d.path(), 7, None, None).unwrap();
        write_state(d.path(), 8, None, None).unwrap();
        let s: CacheState =
            serde_json::from_slice(&std::fs::read(d.path().join("STATE.json")).unwrap()).unwrap();
        assert_eq!(s.current_version, 8);
        assert_eq!(s.previous_version, Some(7));
    }
    #[test]
    fn committed_state_retains_ack_until_success_is_persisted() {
        let d = tempfile::tempdir().unwrap();
        write_state(d.path(), 7, Some("item-7".into()), Some("playing")).unwrap();
        let path = d.path().join("STATE.json");
        let mut state: CacheState = serde_json::from_slice(&std::fs::read(&path).unwrap()).unwrap();
        assert!(state.ack_pending);
        assert_eq!(state.ack_status.as_deref(), Some("playing"));
        state.ack_pending = false;
        state.ack_status = None;
        write_state_record(d.path(), &state).unwrap();
        let saved: CacheState = serde_json::from_slice(&std::fs::read(path).unwrap()).unwrap();
        assert!(!saved.ack_pending);
        assert_eq!(saved.current_version, 7);
        assert_eq!(saved.current_item_id.as_deref(), Some("item-7"));
    }
    #[test]
    fn pointer_write_failure_keeps_last_good_state() {
        let d = tempfile::tempdir().unwrap();
        write_state(d.path(), 7, None, None).unwrap();
        std::fs::remove_file(d.path().join("STATE.json")).unwrap();
        std::fs::create_dir(d.path().join("STATE.json")).unwrap();
        assert!(write_state(d.path(), 8, None, None).is_err());
        assert!(d.path().join("STATE.json").is_dir());
    }
    #[test]
    fn corrupted_current_generation_recovers_previous() {
        let d = tempfile::tempdir().unwrap();
        let old = b"previous";
        let new = b"current";
        let m1 = Manifest {
            schema_version: 1,
            screen_id: "screen".into(),
            version: 7,
            profile: "720p30-v1".into(),
            orientation: 0,
            muted: true,
            volume: 0,
            items: vec![item(old, old.len() as u64)],
        };
        let m2 = Manifest {
            version: 8,
            items: vec![item(new, new.len() as u64)],
            ..m1.clone()
        };
        std::fs::create_dir_all(d.path().join("manifests")).unwrap();
        std::fs::write(d.path().join(format!("{}.media", m1.items[0].sha256)), old).unwrap();
        std::fs::write(
            d.path().join(format!("{}.media", m2.items[0].sha256)),
            b"corrupt",
        )
        .unwrap();
        write_generation(d.path(), &m1).unwrap();
        write_generation(d.path(), &m2).unwrap();
        write_state(d.path(), 7, None, None).unwrap();
        write_state(d.path(), 8, None, None).unwrap();
        let s: CacheState =
            serde_json::from_slice(&std::fs::read(d.path().join("STATE.json")).unwrap()).unwrap();
        assert_eq!(load_generation(d.path(), &s).unwrap().version, 7);
    }
    #[test]
    fn hash_file_reads_full_content() {
        let d = tempfile::tempdir().unwrap();
        let p = d.path().join("asset");
        std::fs::write(&p, b"pixel8").unwrap();
        assert_eq!(
            hash_file(&p).unwrap(),
            hex::encode(Sha256::digest(b"pixel8"))
        );
    }
    #[tokio::test]
    async fn pending_idle_ack_is_retried_then_cleared_durably() {
        let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
        let address = listener.local_addr().unwrap();
        let server = tokio::spawn(async move {
            let (mut stream, _) = listener.accept().await.unwrap();
            let mut request = Vec::new();
            let mut buf = [0; 1024];
            loop {
                let n = stream.read(&mut buf).await.unwrap();
                request.extend_from_slice(&buf[..n]);
                let text = String::from_utf8_lossy(&request);
                if let Some((head, body)) = text.split_once("\r\n\r\n") {
                    let length = head
                        .lines()
                        .find_map(|l| {
                            l.to_ascii_lowercase()
                                .strip_prefix("content-length: ")
                                .and_then(|n| n.parse::<usize>().ok())
                        })
                        .unwrap_or(0);
                    if body.len() >= length {
                        break;
                    }
                }
            }
            let text = String::from_utf8_lossy(&request);
            let body = text.split_once("\r\n\r\n").unwrap().1;
            let value: serde_json::Value = serde_json::from_str(body).unwrap();
            stream.write_all(b"HTTP/1.1 200 OK\r\nContent-Length: 11\r\nConnection: close\r\n\r\n{\"ok\":true}").await.unwrap();
            value
        });
        let d = tempfile::tempdir().unwrap();
        std::fs::create_dir_all(d.path()).unwrap();
        write_state(d.path(), 8, None, Some("idle")).unwrap();
        let client = Client {
            http: reqwest::Client::new(),
            download_http: reqwest::Client::new(),
            base: format!("http://{address}"),
            token: "test-token".into(),
            cache: d.path().into(),
            quota: 1024,
            playing_version: std::sync::Arc::new(Mutex::new(Some(8))),
            state: std::sync::Arc::new(Mutex::new((8, None))),
            item_ids: std::sync::Arc::new(Mutex::new(Vec::new())),
            recovery_error: std::sync::Arc::new(Mutex::new(None)),
            last_capabilities: std::sync::Arc::new(Mutex::new(None)),
        };
        client.retry_pending_ack().await.unwrap();
        let sent = server.await.unwrap();
        assert_eq!(sent["version"], 8);
        assert_eq!(sent["status"], "idle");
        let saved: CacheState =
            serde_json::from_slice(&std::fs::read(d.path().join("STATE.json")).unwrap()).unwrap();
        assert!(!saved.ack_pending);
    }

    #[cfg(feature = "native-gstreamer")]
    #[tokio::test]
    async fn renderer_error_records_fallback_actual_playing_version_before_failed_ack() {
        let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
        let address = listener.local_addr().unwrap();
        let server = tokio::spawn(async move {
            let (mut stream, _) = listener.accept().await.unwrap();
            let mut request = Vec::new();
            let mut buffer = [0; 1024];
            loop {
                let n = stream.read(&mut buffer).await.unwrap();
                request.extend_from_slice(&buffer[..n]);
                let text = String::from_utf8_lossy(&request);
                if let Some((head, body)) = text.split_once("\r\n\r\n") {
                    let length = head
                        .lines()
                        .find_map(|line| {
                            line.to_ascii_lowercase()
                                .strip_prefix("content-length: ")
                                .and_then(|n| n.parse::<usize>().ok())
                        })
                        .unwrap_or(0);
                    if body.len() >= length {
                        break;
                    }
                }
            }
            let body = String::from_utf8_lossy(&request)
                .split_once("\r\n\r\n")
                .unwrap()
                .1
                .to_owned();
            stream.write_all(b"HTTP/1.1 503 Service Unavailable\r\nContent-Length: 0\r\nConnection: close\r\n\r\n").await.unwrap();
            body
        });
        let d = tempfile::tempdir().unwrap();
        let media = d.path().join("fallback.png");
        image::RgbImage::from_pixel(2, 2, image::Rgb([45, 65, 85]))
            .save(&media)
            .unwrap();
        let bytes = std::fs::read(&media).unwrap();
        let fallback = Manifest {
            schema_version: 1,
            screen_id: "screen".into(),
            version: 7,
            profile: "720p30-v1".into(),
            orientation: 0,
            muted: true,
            volume: 0,
            items: vec![item(&bytes, bytes.len() as u64)],
        };
        std::fs::rename(
            &media,
            d.path().join(format!("{}.media", fallback.items[0].sha256)),
        )
        .unwrap();
        let desired = Manifest {
            version: 8,
            ..fallback.clone()
        };
        write_generation(d.path(), &fallback).unwrap();
        write_generation(d.path(), &desired).unwrap();
        write_state(d.path(), 7, None, None).unwrap();
        write_state(d.path(), 8, None, None).unwrap();
        let client = Client {
            http: reqwest::Client::new(),
            download_http: reqwest::Client::new(),
            base: format!("http://{address}"),
            token: "test-token".into(),
            cache: d.path().into(),
            quota: 1024 * 1024,
            playing_version: std::sync::Arc::new(Mutex::new(Some(8))),
            state: std::sync::Arc::new(Mutex::new((8, None))),
            item_ids: std::sync::Arc::new(Mutex::new(Vec::new())),
            recovery_error: std::sync::Arc::new(Mutex::new(None)),
            last_capabilities: std::sync::Arc::new(Mutex::new(None)),
        };
        let mut renderer = crate::player::GstRenderer::new_cpu_test_renderer().unwrap();
        assert!(client
            .recover_renderer_error(&mut renderer, "decode failed")
            .await
            .is_err());
        assert_eq!(*client.playing_version.lock().unwrap(), Some(7));
        assert_eq!(client.state.lock().unwrap().0, 8);
        assert_eq!(
            client.recovery_error.lock().unwrap().as_deref(),
            Some("decode failed")
        );
        let pending: CacheState =
            serde_json::from_slice(&std::fs::read(d.path().join("STATE.json")).unwrap()).unwrap();
        assert!(pending.ack_pending);
        assert_eq!(pending.ack_status.as_deref(), Some("error"));
        assert_eq!(pending.ack_error.as_deref(), Some("decode failed"));
        assert_eq!(pending.playing_version, Some(7));
        let body: serde_json::Value = serde_json::from_str(&server.await.unwrap()).unwrap();
        assert_eq!(body["version"], 8);
        assert_eq!(body["status"], "error");
        assert_eq!(body["playingVersion"], 7);
        assert_eq!(body["currentItemId"], "item-1");
        write_state(d.path(), 9, None, None).unwrap();
        let next: CacheState =
            serde_json::from_slice(&std::fs::read(d.path().join("STATE.json")).unwrap()).unwrap();
        assert_eq!(next.previous_version, Some(7));
        renderer.stop().unwrap();
    }

    #[cfg(feature = "native-gstreamer")]
    #[tokio::test]
    async fn failed_desired_activation_keeps_desired_ack_version_after_restoring_old_playlist() {
        let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
        let address = listener.local_addr().unwrap();
        let server = tokio::spawn(async move {
            let (mut stream, _) = listener.accept().await.unwrap();
            let mut request = Vec::new();
            let mut buffer = [0; 1024];
            loop {
                let n = stream.read(&mut buffer).await.unwrap();
                request.extend_from_slice(&buffer[..n]);
                let text = String::from_utf8_lossy(&request);
                if let Some((head, body)) = text.split_once("\r\n\r\n") {
                    let length = head
                        .lines()
                        .find_map(|line| {
                            line.to_ascii_lowercase()
                                .strip_prefix("content-length: ")
                                .and_then(|n| n.parse::<usize>().ok())
                        })
                        .unwrap_or(0);
                    if body.len() >= length {
                        break;
                    }
                }
            }
            let body = String::from_utf8_lossy(&request)
                .split_once("\r\n\r\n")
                .unwrap()
                .1
                .to_owned();
            stream.write_all(b"HTTP/1.1 200 OK\r\nContent-Length: 11\r\nConnection: close\r\n\r\n{\"ok\":true}").await.unwrap();
            body
        });

        let d = tempfile::tempdir().unwrap();
        let media = d.path().join("committed.png");
        image::RgbImage::from_pixel(2, 2, image::Rgb([45, 65, 85]))
            .save(&media)
            .unwrap();
        let bytes = std::fs::read(&media).unwrap();
        let committed = Manifest {
            schema_version: 1,
            screen_id: "screen".into(),
            version: 7,
            profile: "720p30-v1".into(),
            orientation: 0,
            muted: true,
            volume: 0,
            items: vec![item(&bytes, bytes.len() as u64)],
        };
        std::fs::rename(
            &media,
            d.path()
                .join(format!("{}.media", committed.items[0].sha256)),
        )
        .unwrap();
        write_generation(d.path(), &committed).unwrap();
        write_state(d.path(), 7, Some("item-1".into()), None).unwrap();
        let client = Client {
            http: reqwest::Client::new(),
            download_http: reqwest::Client::new(),
            base: format!("http://{address}"),
            token: "test-token".into(),
            cache: d.path().into(),
            quota: 1024 * 1024,
            playing_version: std::sync::Arc::new(Mutex::new(None)),
            state: std::sync::Arc::new(Mutex::new((8, None))),
            item_ids: std::sync::Arc::new(Mutex::new(Vec::new())),
            recovery_error: std::sync::Arc::new(Mutex::new(None)),
            last_capabilities: std::sync::Arc::new(Mutex::new(None)),
        };
        let mut renderer = crate::player::GstRenderer::new_cpu_test_renderer().unwrap();
        client.restore_committed(&mut renderer).unwrap();
        assert_eq!(*client.playing_version.lock().unwrap(), Some(7));
        assert_eq!(client.state.lock().unwrap().0, 8);
        client
            .report_reconcile_error("new playlist failed to activate")
            .await
            .unwrap();
        let body: serde_json::Value = serde_json::from_str(&server.await.unwrap()).unwrap();
        assert_eq!(body["version"], 8);
        assert_eq!(body["playingVersion"], 7);
        assert_eq!(body["currentItemId"], "item-1");
        renderer.stop().unwrap();
    }

    #[cfg(feature = "native-gstreamer")]
    #[tokio::test]
    async fn renderer_error_without_fallback_clears_actual_playing_version() {
        let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
        let address = listener.local_addr().unwrap();
        let server = tokio::spawn(async move {
            let (mut stream, _) = listener.accept().await.unwrap();
            let mut request = Vec::new();
            let mut buffer = [0; 1024];
            loop {
                let n = stream.read(&mut buffer).await.unwrap();
                request.extend_from_slice(&buffer[..n]);
                let text = String::from_utf8_lossy(&request);
                if let Some((head, body)) = text.split_once("\r\n\r\n") {
                    let length = head
                        .lines()
                        .find_map(|line| {
                            line.to_ascii_lowercase()
                                .strip_prefix("content-length: ")
                                .and_then(|n| n.parse::<usize>().ok())
                        })
                        .unwrap_or(0);
                    if body.len() >= length {
                        break;
                    }
                }
            }
            stream.write_all(b"HTTP/1.1 200 OK\r\nContent-Length: 11\r\nConnection: close\r\n\r\n{\"ok\":true}").await.unwrap();
            String::from_utf8_lossy(&request)
                .split_once("\r\n\r\n")
                .unwrap()
                .1
                .to_owned()
        });
        let d = tempfile::tempdir().unwrap();
        write_state(d.path(), 7, None, None).unwrap();
        write_state(d.path(), 8, None, Some("playing")).unwrap();
        let client = Client {
            http: reqwest::Client::new(),
            download_http: reqwest::Client::new(),
            base: format!("http://{address}"),
            token: "test-token".into(),
            cache: d.path().into(),
            quota: 1024,
            playing_version: std::sync::Arc::new(Mutex::new(Some(8))),
            state: std::sync::Arc::new(Mutex::new((8, None))),
            item_ids: std::sync::Arc::new(Mutex::new(Vec::new())),
            recovery_error: std::sync::Arc::new(Mutex::new(None)),
            last_capabilities: std::sync::Arc::new(Mutex::new(None)),
        };
        let mut renderer = crate::player::GstRenderer::new_cpu_test_renderer().unwrap();
        client
            .recover_renderer_error(&mut renderer, "no fallback")
            .await
            .unwrap();
        assert_eq!(*client.playing_version.lock().unwrap(), None);
        let saved: CacheState =
            serde_json::from_slice(&std::fs::read(d.path().join("STATE.json")).unwrap()).unwrap();
        assert_eq!(saved.playing_version, None);
        let body: serde_json::Value = serde_json::from_str(&server.await.unwrap()).unwrap();
        assert_eq!(body["playingVersion"], serde_json::Value::Null);
        assert!(body.get("currentItemId").is_none());
    }

    #[cfg(feature = "native-gstreamer")]
    #[tokio::test]
    async fn boot_restore_falls_back_when_hash_valid_current_media_cannot_decode() {
        let d = tempfile::tempdir().unwrap();
        let good_path = d.path().join("good.png");
        image::RgbImage::from_pixel(2, 2, image::Rgb([45, 65, 85]))
            .save(&good_path)
            .unwrap();
        let good = std::fs::read(&good_path).unwrap();
        let fallback = Manifest {
            schema_version: 1,
            screen_id: "screen".into(),
            version: 7,
            profile: "720p30-v1".into(),
            orientation: 0,
            muted: true,
            volume: 0,
            items: vec![item(&good, good.len() as u64)],
        };
        std::fs::rename(
            &good_path,
            d.path().join(format!("{}.media", fallback.items[0].sha256)),
        )
        .unwrap();
        let invalid = b"hash-valid but not decodable media";
        let current = Manifest {
            version: 8,
            items: vec![item(invalid, invalid.len() as u64)],
            ..fallback.clone()
        };
        std::fs::write(
            d.path().join(format!("{}.media", current.items[0].sha256)),
            invalid,
        )
        .unwrap();
        write_generation(d.path(), &fallback).unwrap();
        write_generation(d.path(), &current).unwrap();
        write_state(d.path(), 7, Some("item-1".into()), None).unwrap();
        write_state(d.path(), 8, Some("item-1".into()), None).unwrap();

        let client = Client {
            http: reqwest::Client::new(),
            download_http: reqwest::Client::new(),
            base: "http://127.0.0.1:1".into(),
            token: "test-token".into(),
            cache: d.path().into(),
            quota: 1024 * 1024,
            playing_version: std::sync::Arc::new(Mutex::new(None)),
            state: std::sync::Arc::new(Mutex::new((8, None))),
            item_ids: std::sync::Arc::new(Mutex::new(Vec::new())),
            recovery_error: std::sync::Arc::new(Mutex::new(None)),
            last_capabilities: std::sync::Arc::new(Mutex::new(None)),
        };
        let mut renderer = crate::player::GstRenderer::new_cpu_test_renderer().unwrap();
        client.restore(&mut renderer).await.unwrap();
        assert_eq!(*client.playing_version.lock().unwrap(), Some(7));
        assert_eq!(client.state.lock().unwrap().0, 8);
        let pending: CacheState =
            serde_json::from_slice(&std::fs::read(d.path().join("STATE.json")).unwrap()).unwrap();
        assert_eq!(pending.ack_version, Some(8));
        assert_eq!(pending.playing_version, Some(7));
        assert_eq!(pending.current_item_id.as_deref(), Some("item-1"));
        assert_eq!(pending.ack_status.as_deref(), Some("error"));
        assert!(renderer.check_health().is_ok());
        renderer.stop().unwrap();
    }

    #[tokio::test]
    async fn reconcile_retries_committed_ack_before_same_version_fast_path() {
        let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
        let address = listener.local_addr().unwrap();
        let server = tokio::spawn(async move {
            async fn read_request(stream: &mut tokio::net::TcpStream) -> String {
                let mut request = Vec::new();
                let mut buffer = [0; 1024];
                loop {
                    let n = stream.read(&mut buffer).await.unwrap();
                    assert!(n > 0, "connection closed before full request");
                    request.extend_from_slice(&buffer[..n]);
                    let text = String::from_utf8_lossy(&request);
                    if let Some((head, body)) = text.split_once("\r\n\r\n") {
                        let length = head
                            .lines()
                            .find_map(|line| {
                                line.to_ascii_lowercase()
                                    .strip_prefix("content-length: ")
                                    .and_then(|n| n.parse::<usize>().ok())
                            })
                            .unwrap_or(0);
                        if body.len() >= length {
                            break;
                        }
                    }
                }
                String::from_utf8_lossy(&request).into_owned()
            }
            let (mut stream, _) = listener.accept().await.unwrap();
            let ack = read_request(&mut stream).await;
            assert!(ack.starts_with("POST /v1/device/ack "));
            stream
                .write_all(b"HTTP/1.1 200 OK\r\nContent-Length: 11\r\nConnection: close\r\n\r\n{\"ok\":true}")
                .await
                .unwrap();
            drop(stream);
            let (mut stream, _) = listener.accept().await.unwrap();
            assert!(read_request(&mut stream)
                .await
                .starts_with("PUT /v1/device/capabilities "));
            stream
                .write_all(b"HTTP/1.1 200 OK\r\nContent-Length: 11\r\nConnection: close\r\n\r\n{\"ok\":true}")
                .await
                .unwrap();
            drop(stream);
            let (mut stream, _) = listener.accept().await.unwrap();
            assert!(read_request(&mut stream)
                .await
                .starts_with("GET /v1/device/manifest "));
            let manifest = serde_json::json!({
                "schemaVersion": 1, "screenId": "screen", "version": 8,
                "profile": "720p30-v1", "orientation": 0, "muted": true,
                "volume": 0, "items": []
            })
            .to_string();
            let response = format!(
                "HTTP/1.1 200 OK\r\nContent-Length: {}\r\nConnection: close\r\n\r\n{}",
                manifest.len(),
                manifest
            );
            stream.write_all(response.as_bytes()).await.unwrap();
            drop(stream);
            let (mut stream, _) = listener.accept().await.unwrap();
            let ack = read_request(&mut stream).await;
            assert!(ack.starts_with("POST /v1/device/ack "));
            assert!(ack.contains("\"status\":\"idle\""));
            stream
                .write_all(b"HTTP/1.1 200 OK\r\nContent-Length: 11\r\nConnection: close\r\n\r\n{\"ok\":true}")
                .await
                .unwrap();
        });
        let d = tempfile::tempdir().unwrap();
        write_state(d.path(), 8, None, Some("idle")).unwrap();
        let client = Client {
            http: reqwest::Client::new(),
            download_http: reqwest::Client::new(),
            base: format!("http://{address}"),
            token: "test-token".into(),
            cache: d.path().into(),
            quota: 1024,
            playing_version: std::sync::Arc::new(Mutex::new(Some(8))),
            state: std::sync::Arc::new(Mutex::new((8, None))),
            item_ids: std::sync::Arc::new(Mutex::new(Vec::new())),
            recovery_error: std::sync::Arc::new(Mutex::new(None)),
            last_capabilities: std::sync::Arc::new(Mutex::new(None)),
        };
        *client.recovery_error.lock().unwrap() = Some("temporary offline error".into());
        let mut renderer = crate::player::GstRenderer::default();
        let mut cfg = crate::config::Config {
            api_base_url: None,
            device_id: "test".into(),
            device_token: None,
            cache_dir: d.path().display().to_string(),
            cache_quota_bytes: 1024,
            audio_device: "test".into(),
        };
        client
            .reconcile(&mut cfg, &mut renderer, d.path())
            .await
            .unwrap();
        server.await.unwrap();
        let saved: CacheState =
            serde_json::from_slice(&std::fs::read(d.path().join("STATE.json")).unwrap()).unwrap();
        assert!(!saved.ack_pending);
        assert_eq!(*client.recovery_error.lock().unwrap(), None);
    }

    #[tokio::test]
    async fn verified_download_publishes_atomically() {
        let d = tempfile::tempdir().unwrap();
        let bytes = b"verified media".to_vec();
        let i = item(&bytes, bytes.len() as u64);
        let url = one_shot(bytes.clone()).await;
        download_verified(&reqwest::Client::new(), &url, &i, d.path(), 1024 * 1024)
            .await
            .unwrap();
        assert_eq!(
            std::fs::read(d.path().join(format!("{}.media", i.sha256))).unwrap(),
            bytes
        );
        assert!(!d.path().join(format!("{}.part", i.sha256)).exists());
    }
    #[tokio::test]
    async fn wrong_digest_removes_staging_file() {
        let d = tempfile::tempdir().unwrap();
        let bytes = b"bad media".to_vec();
        let i = item(b"different", bytes.len() as u64);
        let url = one_shot(bytes).await;
        assert!(
            download_verified(&reqwest::Client::new(), &url, &i, d.path(), 1024 * 1024)
                .await
                .is_err()
        );
        assert!(!d.path().join(format!("{}.part", i.sha256)).exists());
        assert!(!d.path().join(format!("{}.media", i.sha256)).exists());
    }
    #[tokio::test]
    async fn oversized_download_is_rejected() {
        let d = tempfile::tempdir().unwrap();
        let bytes = b"too long".to_vec();
        let i = item(&bytes, 2);
        let url = one_shot(bytes).await;
        assert!(
            download_verified(&reqwest::Client::new(), &url, &i, d.path(), 1024 * 1024)
                .await
                .is_err()
        );
    }
    #[test]
    fn garbage_collection_preserves_manifest_pins() {
        let d = tempfile::tempdir().unwrap();
        let pinned = d
            .path()
            .join(format!("{}.media", hex::encode(Sha256::digest(b"keep"))));
        std::fs::write(&pinned, b"keep").unwrap();
        std::fs::write(d.path().join("old.media"), vec![1u8; 64]).unwrap();
        let c = Client {
            http: reqwest::Client::new(),
            download_http: reqwest::Client::new(),
            base: "http://localhost".into(),
            token: "token".into(),
            cache: d.path().into(),
            quota: 4,
            playing_version: std::sync::Arc::new(Mutex::new(None)),
            state: std::sync::Arc::new(Mutex::new((1, None))),
            item_ids: std::sync::Arc::new(Mutex::new(Vec::new())),
            recovery_error: std::sync::Arc::new(Mutex::new(None)),
            last_capabilities: std::sync::Arc::new(Mutex::new(None)),
        };
        let m = Manifest {
            schema_version: 1,
            screen_id: "screen".into(),
            version: 1,
            profile: "720p30-v1".into(),
            orientation: 0,
            muted: true,
            volume: 0,
            items: vec![item(b"keep", 4)],
        };
        c.collect(&m).unwrap();
        assert!(pinned.exists());
        assert!(!d.path().join("old.media").exists());
    }
    #[test]
    fn garbage_collection_reclaims_to_quota_minus_missing_bytes() {
        let d = tempfile::tempdir().unwrap();
        std::fs::write(d.path().join("old.media"), vec![1u8; 80]).unwrap();
        std::fs::write(d.path().join("stale.part"), vec![2u8; 40]).unwrap();
        let c = Client {
            http: reqwest::Client::new(),
            download_http: reqwest::Client::new(),
            base: "http://localhost".into(),
            token: "token".into(),
            cache: d.path().into(),
            quota: 100,
            playing_version: std::sync::Arc::new(Mutex::new(None)),
            state: std::sync::Arc::new(Mutex::new((1, None))),
            item_ids: std::sync::Arc::new(Mutex::new(Vec::new())),
            recovery_error: std::sync::Arc::new(Mutex::new(None)),
            last_capabilities: std::sync::Arc::new(Mutex::new(None)),
        };
        let m = Manifest {
            schema_version: 1,
            screen_id: "screen".into(),
            version: 2,
            profile: "720p30-v1".into(),
            orientation: 0,
            muted: true,
            volume: 0,
            items: vec![],
        };
        c.collect_reserving(&m, 60).unwrap();
        assert!(directory_bytes(d.path()).unwrap() <= 40);
    }
    #[test]
    fn reserved_collection_keeps_current_and_previous_generation_media() {
        let d = tempfile::tempdir().unwrap();
        let current_bytes = b"committed current";
        let previous_bytes = b"last known good";
        let current = Manifest {
            schema_version: 1,
            screen_id: "screen".into(),
            version: 8,
            profile: "720p30-v1".into(),
            orientation: 0,
            muted: true,
            volume: 0,
            items: vec![item(current_bytes, current_bytes.len() as u64)],
        };
        let previous = Manifest {
            version: 7,
            items: vec![item(previous_bytes, previous_bytes.len() as u64)],
            ..current.clone()
        };
        let incoming = Manifest {
            version: 9,
            items: vec![item(b"new incoming", 12)],
            ..current.clone()
        };
        for m in [&current, &previous] {
            let media = &m.items[0];
            std::fs::write(
                d.path().join(format!("{}.media", media.sha256)),
                if m.version == 8 {
                    current_bytes.as_slice()
                } else {
                    previous_bytes.as_slice()
                },
            )
            .unwrap();
            write_generation(d.path(), m).unwrap();
        }
        std::fs::write(d.path().join("unreferenced.part"), vec![1u8; 100]).unwrap();
        write_state(d.path(), 7, None, None).unwrap();
        write_state(d.path(), 8, None, None).unwrap();
        let c = Client {
            http: reqwest::Client::new(),
            download_http: reqwest::Client::new(),
            base: "http://localhost".into(),
            token: "token".into(),
            cache: d.path().into(),
            quota: 256,
            playing_version: std::sync::Arc::new(Mutex::new(Some(8))),
            state: std::sync::Arc::new(Mutex::new((8, None))),
            item_ids: std::sync::Arc::new(Mutex::new(Vec::new())),
            recovery_error: std::sync::Arc::new(Mutex::new(None)),
            last_capabilities: std::sync::Arc::new(Mutex::new(None)),
        };
        c.collect_reserving(&incoming, 12).unwrap();
        assert!(d
            .path()
            .join(format!("{}.media", current.items[0].sha256))
            .exists());
        assert!(d
            .path()
            .join(format!("{}.media", previous.items[0].sha256))
            .exists());
        assert!(!d.path().join("unreferenced.part").exists());
    }
    #[test]
    fn state_rotation_uses_recovered_valid_generation_as_previous() {
        let d = tempfile::tempdir().unwrap();
        let good = b"good generation";
        let bad = b"corrupt";
        let seven = Manifest {
            schema_version: 1,
            screen_id: "screen".into(),
            version: 7,
            profile: "720p30-v1".into(),
            orientation: 0,
            muted: true,
            volume: 0,
            items: vec![item(good, good.len() as u64)],
        };
        let eight = Manifest {
            version: 8,
            items: vec![item(b"eight", 5)],
            ..seven.clone()
        };
        std::fs::create_dir_all(d.path().join("manifests")).unwrap();
        std::fs::write(
            d.path().join(format!("{}.media", seven.items[0].sha256)),
            good,
        )
        .unwrap();
        std::fs::write(
            d.path().join(format!("{}.media", eight.items[0].sha256)),
            bad,
        )
        .unwrap();
        write_generation(d.path(), &seven).unwrap();
        write_generation(d.path(), &eight).unwrap();
        write_state(d.path(), 7, None, None).unwrap();
        write_state(d.path(), 8, None, None).unwrap();
        write_state(d.path(), 9, None, None).unwrap();
        let saved: CacheState =
            serde_json::from_slice(&std::fs::read(d.path().join("STATE.json")).unwrap()).unwrap();
        assert_eq!(saved.current_version, 9);
        assert_eq!(saved.previous_version, Some(7));
    }
    #[test]
    fn state_rotation_uses_runtime_fallback_instead_of_failed_desired_version() {
        let d = tempfile::tempdir().unwrap();
        let old = b"fallback seven";
        let failed = b"desired eight";
        let seven = Manifest {
            schema_version: 1,
            screen_id: "screen".into(),
            version: 7,
            profile: "720p30-v1".into(),
            orientation: 0,
            muted: true,
            volume: 0,
            items: vec![item(old, old.len() as u64)],
        };
        let eight = Manifest {
            version: 8,
            items: vec![item(failed, failed.len() as u64)],
            ..seven.clone()
        };
        std::fs::create_dir_all(d.path().join("manifests")).unwrap();
        for (m, bytes) in [(&seven, old.as_slice()), (&eight, failed.as_slice())] {
            std::fs::write(d.path().join(format!("{}.media", m.items[0].sha256)), bytes).unwrap();
            write_generation(d.path(), m).unwrap();
        }
        write_state(d.path(), 7, None, None).unwrap();
        write_state(d.path(), 8, None, Some("playing")).unwrap();
        let mut failed_state: CacheState =
            serde_json::from_slice(&std::fs::read(d.path().join("STATE.json")).unwrap()).unwrap();
        failed_state.playing_version = Some(7);
        failed_state.playing_version_recorded = true;
        failed_state.ack_version = Some(8);
        failed_state.ack_status = Some("error".into());
        write_state_record(d.path(), &failed_state).unwrap();

        write_state(d.path(), 9, None, None).unwrap();
        let saved: CacheState =
            serde_json::from_slice(&std::fs::read(d.path().join("STATE.json")).unwrap()).unwrap();
        assert_eq!(saved.current_version, 9);
        assert_eq!(saved.previous_version, Some(7));
    }
}
