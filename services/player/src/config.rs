use anyhow::{Context, Result};
use serde::{Deserialize, Serialize};
use std::{fs, os::unix::fs::PermissionsExt, path::Path};
use uuid::Uuid;

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Config {
    pub api_base_url: Option<String>,
    #[serde(default = "new_device_id")]
    pub device_id: String,
    pub device_token: Option<String>,
    #[serde(default = "cache_default")]
    pub cache_dir: String,
    #[serde(default = "quota_default")]
    pub cache_quota_bytes: u64,
    #[serde(default = "audio_default")]
    pub audio_device: String,
}
fn cache_default() -> String {
    "/var/lib/pixel8/cache".into()
}
fn quota_default() -> u64 {
    4 * 1024 * 1024 * 1024
}
fn audio_default() -> String {
    "hw:0,0".into()
}
fn new_device_id() -> String {
    Uuid::new_v4().to_string()
}
impl Config {
    pub fn load_or_create(path: &Path) -> Result<Self> {
        if path.exists() {
            let contents = fs::read_to_string(path)?;
            let value: toml::Value = toml::from_str(&contents)?;
            let has_real_id = value
                .get("device_id")
                .and_then(toml::Value::as_str)
                .is_some_and(|id| !id.trim().is_empty() && id != "generated-by-pixel8-player");
            let mut c: Self = toml::from_str(&contents)?;
            if !has_real_id {
                c.device_id = new_device_id();
                save(path, &c)?;
            }
            return Ok(c);
        }
        let c = Self {
            api_base_url: None,
            device_id: new_device_id(),
            device_token: None,
            cache_dir: cache_default(),
            cache_quota_bytes: quota_default(),
            audio_device: audio_default(),
        };
        if let Some(p) = path.parent() {
            fs::create_dir_all(p)?
        }
        save(path, &c)?;
        Ok(c)
    }
}
pub fn save(path: &Path, c: &Config) -> Result<()> {
    if let Some(p) = path.parent() {
        fs::create_dir_all(p)?
    }
    let temp = path.with_extension("toml.tmp");
    fs::write(&temp, toml::to_string_pretty(c)?)?;
    fs::set_permissions(&temp, fs::Permissions::from_mode(0o600))
        .context("protect credential file")?;
    fs::rename(temp, path)?;
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn placeholder_ids_are_replaced_and_persisted_independently() {
        let temp = tempfile::tempdir().unwrap();
        let a = temp.path().join("a.toml");
        let b = temp.path().join("b.toml");
        let example = format!(
            "{}\ndevice_id = 'generated-by-pixel8-player'\n",
            include_str!("../packaging/player.toml.example")
                .replace("https://pixel8.example.com", "http://localhost:3001")
        );
        fs::write(&a, &example).unwrap();
        fs::write(&b, &example).unwrap();

        let first = Config::load_or_create(&a).unwrap();
        let second = Config::load_or_create(&b).unwrap();
        assert_ne!(first.device_id, "generated-by-pixel8-player");
        assert_ne!(first.device_id, second.device_id);
        assert_eq!(
            Config::load_or_create(&a).unwrap().device_id,
            first.device_id
        );
    }

    #[test]
    fn missing_device_id_gets_a_unique_default() {
        let temp = tempfile::tempdir().unwrap();
        let a = temp.path().join("a.toml");
        let b = temp.path().join("b.toml");
        fs::write(&a, "api_base_url = 'http://localhost:3001'\n").unwrap();
        fs::write(&b, "api_base_url = 'http://localhost:3001'\n").unwrap();
        let first = Config::load_or_create(&a).unwrap();
        let second = Config::load_or_create(&b).unwrap();
        assert_ne!(first.device_id, second.device_id);
        assert_eq!(
            Config::load_or_create(&a).unwrap().device_id,
            first.device_id
        );
    }
}
