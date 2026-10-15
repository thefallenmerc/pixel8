mod config;
mod device;
mod player;
mod sync;
mod telemetry;
use anyhow::{bail, Context, Result};
use clap::{Parser, Subcommand};
use std::{path::PathBuf, time::Duration};
#[derive(Parser)]
#[command(name = "pixel8-player", version)]
struct Args {
    #[arg(long, default_value = "/etc/pixel8/player.toml")]
    config: PathBuf,
    #[command(subcommand)]
    command: Option<Command>,
}
#[derive(Subcommand)]
enum Command {
    Pair,
    Doctor,
    InitConfig,
}
#[tokio::main]
async fn main() -> Result<()> {
    let args = Args::parse();
    let mut cfg = config::Config::load_or_create(&args.config)?;
    let mut pair_renderer = player::GstRenderer::new(&cfg.audio_device).ok();
    if let Some(cmd) = args.command {
        match cmd {
            Command::Pair => return pairing(&mut cfg, &args.config, pair_renderer.as_mut()).await,
            Command::Doctor => return device::doctor(&cfg),
            Command::InitConfig => {
                println!("Player config initialized at {}", args.config.display());
                return Ok(());
            }
        }
    }
    #[cfg(not(feature = "native-gstreamer"))]
    bail!("this binary was built without native-gstreamer; production playback is unavailable (build with --features native-gstreamer on Raspberry Pi)");
    #[cfg(feature = "native-gstreamer")]
    {
        let mut renderer = pair_renderer.context("native renderer unavailable")?;
        let mut client = sync::Client::new(cfg.clone())?;
        client.restore(&mut renderer).await?;
        if cfg.device_token.is_none() {
            pairing(&mut cfg, &args.config, Some(&mut renderer)).await?;
            client = sync::Client::new(cfg.clone())?;
            client.restore(&mut renderer).await?;
        }
        let mut event_hints = client.event_hints();
        let mut interval = tokio::time::interval(Duration::from_secs(30));
        interval.set_missed_tick_behavior(tokio::time::MissedTickBehavior::Delay);
        let metrics = renderer.metrics();
        let telemetry_client = client.clone();
        tokio::spawn(async move {
            let mut telemetry = telemetry::Collector::new();
            let mut ticks = tokio::time::interval(Duration::from_secs(30));
            ticks.set_missed_tick_behavior(tokio::time::MissedTickBehavior::Delay);
            ticks.tick().await;
            loop {
                tokio::select! { _ = ticks.tick() => {}, _ = metrics.item_changed() => {} }
                if let Err(e) = telemetry_client
                    .send_telemetry(&mut telemetry, &metrics)
                    .await
                {
                    eprintln!(
                        "{{\"level\":\"warn\",\"component\":\"telemetry\",\"message\":{:?}}}",
                        e.to_string().chars().take(512).collect::<String>()
                    );
                }
            }
        });
        loop {
            tokio::select! { _=interval.tick()=>{}, hint=event_hints.recv()=>{if hint.is_none(){tokio::time::sleep(Duration::from_secs(3)).await;}} }
            if let Err(e) = renderer.check_health() {
                eprintln!(
                    "{{\"level\":\"error\",\"component\":\"renderer\",\"message\":{:?}}}",
                    e.to_string()
                );
                if let Err(r) = client
                    .recover_renderer_error(&mut renderer, &e.to_string())
                    .await
                {
                    eprintln!("{{\"level\":\"error\",\"component\":\"renderer-recovery\",\"message\":{:?}}}",r.to_string());
                }
            }
            if let Err(e) = client
                .reconcile(&mut cfg, &mut renderer, &args.config)
                .await
            {
                if let Err(ack_error) = client.report_reconcile_error(&e.to_string()).await {
                    eprintln!(
                        "{{\"level\":\"warn\",\"component\":\"ack-error\",\"message\":{:?}}}",
                        ack_error.to_string()
                    );
                }
                eprintln!(
                    "{{\"level\":\"error\",\"component\":\"reconcile\",\"message\":{:?}}}",
                    e.to_string()
                );
            }
        }
    }
}
async fn pairing(
    cfg: &mut config::Config,
    path: &std::path::Path,
    mut renderer: Option<&mut player::GstRenderer>,
) -> Result<()> {
    let api = cfg
        .api_base_url
        .clone()
        .context("set api_base_url in config")?;
    let client = reqwest::Client::new();
    let caps = device::capabilities();
    loop {
        let created: sync::Pairing = client
            .post(format!("{}/v1/device/pairing", api.trim_end_matches('/')))
            .json(&serde_json::json!({"deviceId":cfg.device_id,"capabilities":caps}))
            .send()
            .await?
            .error_for_status()?
            .json()
            .await?;
        let pairing_uri = format!("pixel8://pair?code={}", created.code);
        println!("Pixel8 pairing code: {}\nPairing expires: {}\nScan the QR or enter the 8 character code in Pixel8.",created.code,created.expires_at);
        let qr_path = pairing_qr_path(std::path::Path::new(&cfg.cache_dir), &created.pairing_id);
        let qr_result = if let Some(r) = renderer.as_mut() {
            render_pairing_qr(&pairing_uri, &qr_path)
                .and_then(|_| r.start_playlist(std::slice::from_ref(&qr_path), true, 0))
        } else {
            Err(anyhow::anyhow!("native renderer unavailable"))
        };
        match qr_result {
            Ok(()) => {
                cleanup_pairing_qrs(std::path::Path::new(&cfg.cache_dir), Some(&qr_path));
            }
            Err(e) => {
                eprintln!("QR scanout unavailable; use the terminal code: {e}");
                let _ = std::fs::remove_file(&qr_path);
            }
        }
        let expired = loop {
            tokio::time::sleep(Duration::from_secs(2)).await;
            let s: sync::PairingPoll = client
                .post(format!(
                    "{}/v1/device/pairing/{}/poll",
                    api.trim_end_matches('/'),
                    created.pairing_id
                ))
                .json(&serde_json::json!({"pollToken":created.poll_token}))
                .send()
                .await?
                .error_for_status()?
                .json()
                .await?;
            match s.status.as_str() {
                "pending" => continue,
                "expired" => break true,
                "claimed" => {
                    cfg.device_token = Some(s.device_token.context("claim omitted deviceToken")?);
                    config::save(path, cfg)?;
                    cleanup_pairing_qrs(std::path::Path::new(&cfg.cache_dir), None);
                    println!("Device paired; credential saved with owner-only permissions.");
                    return Ok(());
                }
                x => bail!("unexpected pairing status: {x}"),
            }
        };
        if expired {
            println!("Pairing code expired; displaying a new code.");
        }
    }
}

fn pairing_qr_path(cache_dir: &std::path::Path, pairing_id: &str) -> std::path::PathBuf {
    use sha2::{Digest, Sha256};
    let digest = Sha256::digest(pairing_id.as_bytes());
    cache_dir.join(format!("pairing-{}.png", hex::encode(&digest[..8])))
}

fn cleanup_pairing_qrs(cache_dir: &std::path::Path, keep: Option<&std::path::Path>) {
    let Ok(entries) = std::fs::read_dir(cache_dir) else {
        return;
    };
    for entry in entries.flatten() {
        let path = entry.path();
        let is_pairing_qr = path
            .file_name()
            .and_then(std::ffi::OsStr::to_str)
            .is_some_and(|name| {
                name == "pairing.png" || (name.starts_with("pairing-") && name.ends_with(".png"))
            });
        if is_pairing_qr && keep != Some(path.as_path()) {
            let _ = std::fs::remove_file(path);
        }
    }
}

fn render_pairing_qr(payload: &str, path: &std::path::Path) -> Result<()> {
    use image::Luma;
    use std::os::unix::fs::PermissionsExt;
    let code = qrcode::QrCode::new(payload.as_bytes())?;
    let img = code.render::<Luma<u8>>().min_dimensions(640, 640).build();
    if let Some(parent) = path.parent() {
        std::fs::create_dir_all(parent)?;
    }
    let temp = path.with_extension("png.tmp");
    img.save_with_format(&temp, image::ImageFormat::Png)?;
    std::fs::set_permissions(&temp, std::fs::Permissions::from_mode(0o600))?;
    std::fs::rename(temp, path)?;
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::{cleanup_pairing_qrs, pairing_qr_path};

    #[test]
    fn pairing_qr_paths_are_unique_and_cleanup_preserves_active_file() {
        let dir = tempfile::tempdir().unwrap();
        let previous = pairing_qr_path(dir.path(), "pairing-one");
        let active = pairing_qr_path(dir.path(), "pairing-two");
        let legacy = dir.path().join("pairing.png");
        assert_ne!(previous, active);
        std::fs::write(&previous, b"old").unwrap();
        std::fs::write(&active, b"new").unwrap();
        std::fs::write(&legacy, b"old-format").unwrap();

        cleanup_pairing_qrs(dir.path(), Some(&active));
        assert!(!previous.exists());
        assert!(!legacy.exists());
        assert!(active.exists());

        cleanup_pairing_qrs(dir.path(), None);
        assert!(!active.exists());
    }
}
