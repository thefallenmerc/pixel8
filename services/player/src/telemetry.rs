use crate::device;
use anyhow::Result;
use serde::Serialize;
use std::{fs, path::Path};
#[derive(Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct Sample {
    sampled_at: String,
    cpu_percent: f64,
    memory_used_bytes: u64,
    memory_total_bytes: u64,
    #[serde(skip_serializing_if = "Option::is_none")]
    temperature_c: Option<f64>,
    throttled: bool,
    disk_free_bytes: u64,
    cache_bytes: u64,
    #[serde(skip_serializing_if = "Option::is_none")]
    current_item_id: Option<String>,
    desired_version: u64,
    #[serde(skip_serializing_if = "Option::is_none")]
    playing_version: Option<u64>,
    dropped_frames: u64,
    software_version: String,
    display_mode: crate::device::Mode,
    decoder: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    error: Option<String>,
}
pub struct Collector {
    prior: Option<(u64, u64)>,
}
impl Collector {
    pub fn new() -> Self {
        Self { prior: None }
    }
    pub fn sample(
        &mut self,
        cache: &Path,
        desired: u64,
        playing: Option<u64>,
        item: Option<String>,
        error: Option<String>,
        dropped_frames: u64,
        decoder: String,
    ) -> Result<Sample> {
        let (total, idle) = cpu_counters()?;
        let cpu = self
            .prior
            .map(|(pt, pi)| {
                if total > pt {
                    100.0
                        * (1.0 - (idle.saturating_sub(pi) as f64 / (total - pt) as f64))
                            .clamp(0.0, 1.0)
                } else {
                    0.0
                }
            })
            .unwrap_or(0.0);
        self.prior = Some((total, idle));
        let (used, mem_total) = memory()?;
        let cache_bytes = dir_size(cache);
        let mut st = unsafe { std::mem::zeroed::<libc::statvfs>() };
        let disk = if unsafe {
            libc::statvfs(
                std::ffi::CString::new(cache.as_os_str().as_encoded_bytes())
                    .unwrap()
                    .as_ptr(),
                &mut st,
            )
        } == 0
        {
            st.f_bavail as u64 * st.f_frsize as u64
        } else {
            0
        };
        let temperature_c = fs::read_to_string("/sys/class/thermal/thermal_zone0/temp")
            .ok()
            .and_then(|s| s.trim().parse::<f64>().ok())
            .map(|x| x / 1000.0);
        let mode = device::capabilities().selected_mode;
        let sampled_at = chrono::Utc::now().to_rfc3339_opts(chrono::SecondsFormat::Millis, true);
        let throttled = std::process::Command::new("vcgencmd")
            .arg("get_throttled")
            .output()
            .ok()
            .and_then(|o| String::from_utf8(o.stdout).ok())
            .and_then(|s| {
                u32::from_str_radix(
                    s.trim()
                        .strip_prefix("throttled=")?
                        .trim_start_matches("0x"),
                    16,
                )
                .ok()
            })
            .is_some_and(|v| v != 0);
        Ok(Sample {
            sampled_at,
            cpu_percent: cpu,
            memory_used_bytes: used,
            memory_total_bytes: mem_total,
            temperature_c,
            throttled,
            disk_free_bytes: disk,
            cache_bytes,
            current_item_id: item,
            desired_version: desired,
            playing_version: playing,
            dropped_frames,
            software_version: env!("CARGO_PKG_VERSION").into(),
            display_mode: mode,
            decoder,
            error,
        })
    }
}
fn cpu_counters() -> Result<(u64, u64)> {
    let line = fs::read_to_string("/proc/stat")?;
    let l = line
        .lines()
        .next()
        .ok_or_else(|| anyhow::anyhow!("missing cpu counters"))?;
    let v = l
        .split_whitespace()
        .skip(1)
        .filter_map(|x| x.parse::<u64>().ok())
        .collect::<Vec<_>>();
    if v.len() < 4 {
        return Err(anyhow::anyhow!("invalid cpu counters"));
    }
    Ok((v.iter().sum(), v[3] + v.get(4).copied().unwrap_or(0)))
}
fn memory() -> Result<(u64, u64)> {
    let m = fs::read_to_string("/proc/meminfo")?;
    let val = |n: &str| -> Result<u64> {
        let l = m
            .lines()
            .find(|l| l.starts_with(n))
            .ok_or_else(|| anyhow::anyhow!("missing {n}"))?;
        Ok(l.split_whitespace().nth(1).unwrap_or("0").parse::<u64>()? * 1024)
    };
    let total = val("MemTotal:")?;
    let available = val("MemAvailable:")?;
    Ok((total.saturating_sub(available), total))
}
fn dir_size(p: &Path) -> u64 {
    fn walk(path: &Path, total: &mut u64) {
        let Ok(entries) = fs::read_dir(path) else {
            return;
        };
        for entry in entries.flatten() {
            let Ok(meta) = entry.metadata() else { continue };
            if meta.is_dir() {
                walk(&entry.path(), total);
            } else if meta.is_file() {
                *total = total.saturating_add(meta.len());
            }
        }
    }
    let mut total = 0;
    walk(p, &mut total);
    total
}
pub fn append_spool(path: &Path, s: &Sample) -> Result<()> {
    use std::io::Write;
    let mut f = fs::OpenOptions::new()
        .create(true)
        .append(true)
        .open(path)?;
    writeln!(f, "{}", serde_json::to_string(s)?)?;
    f.sync_data()?;
    let data = fs::read_to_string(path)?;
    if data.len() > 1024 * 1024 {
        let retained = data
            .lines()
            .rev()
            .take(500)
            .collect::<Vec<_>>()
            .into_iter()
            .rev()
            .collect::<Vec<_>>()
            .join("\n")
            + "\n";
        let tmp = path.with_extension("jsonl.tmp");
        fs::write(&tmp, retained)?;
        fs::File::open(&tmp)?.sync_all()?;
        fs::rename(tmp, path)?;
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn serialized_sample_matches_contract_shape_and_omits_absent_optionals() {
        let sample = Sample {
            sampled_at: "2026-01-02T03:04:05.000Z".into(),
            cpu_percent: 4.5,
            memory_used_bytes: 1024,
            memory_total_bytes: 4096,
            temperature_c: None,
            throttled: false,
            disk_free_bytes: 2048,
            cache_bytes: 512,
            current_item_id: None,
            desired_version: 1,
            playing_version: None,
            dropped_frames: 0,
            software_version: "0.1.0".into(),
            display_mode: crate::device::Mode {
                width: 1280,
                height: 720,
                refresh_hz: 30,
            },
            decoder: "v4l2h264dec".into(),
            error: None,
        };
        let value = serde_json::to_value(sample).unwrap();
        assert_eq!(
            value["displayMode"],
            serde_json::json!({"width":1280,"height":720,"refreshHz":30})
        );
        for optional in ["temperatureC", "currentItemId", "playingVersion", "error"] {
            assert!(
                value.get(optional).is_none(),
                "{optional} must be omitted, not null"
            );
        }
        assert!(value["cpuPercent"].as_f64().unwrap() <= 100.0);
    }

    #[test]
    fn shared_contract_telemetry_fixture_matches_rust_wire_shape() {
        let expected: serde_json::Value = serde_json::from_str(include_str!(
            "../../../packages/contracts/fixtures/telemetry.json"
        ))
        .unwrap();
        let sample = Sample {
            sampled_at: "2026-10-11T12:00:00.000Z".into(),
            cpu_percent: 24.5,
            memory_used_bytes: 167_772_160,
            memory_total_bytes: 536_870_912,
            temperature_c: Some(51.2),
            throttled: false,
            disk_free_bytes: 4_294_967_296,
            cache_bytes: 104_857_600,
            current_item_id: Some("22222222-2222-4222-8222-222222222222".into()),
            desired_version: 7,
            playing_version: Some(7),
            dropped_frames: 2,
            software_version: "0.1.0".into(),
            display_mode: crate::device::Mode {
                width: 1280,
                height: 720,
                refresh_hz: 60,
            },
            decoder: "v4l2h264dec".into(),
            error: None,
        };
        assert_eq!(serde_json::to_value(sample).unwrap(), expected);
    }
}
