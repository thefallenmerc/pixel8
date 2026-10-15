use anyhow::{bail, Result};
use serde::Serialize;
use std::{fs, path::Path};
#[derive(Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct Mode {
    pub width: u32,
    pub height: u32,
    pub refresh_hz: u32,
}
#[derive(Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct Capabilities {
    pub display_modes: Vec<Mode>,
    pub selected_mode: Mode,
    pub decoders: Vec<String>,
    pub supports_1080p: bool,
    pub software_version: String,
}
pub fn capabilities() -> Capabilities {
    #[cfg(feature = "native-gstreamer")]
    let decoders = {
        let _ = gstreamer::init();
        let registry = gstreamer::Registry::get();
        if registry.lookup_feature("v4l2h264dec").is_some() {
            vec!["v4l2h264dec".to_owned()]
        } else {
            Vec::new()
        }
    };
    #[cfg(not(feature = "native-gstreamer"))]
    let decoders: Vec<String> = Vec::new();
    let mut modes = Vec::new();
    if let Ok(entries) = fs::read_dir("/sys/class/drm") {
        for e in entries.flatten() {
            if let Ok(edid) = fs::read(e.path().join("edid")) {
                modes.extend(parse_edid_modes(&edid));
            }
        }
    }
    modes.sort_by_key(|m| (m.width * m.height, m.width, m.refresh_hz));
    modes.dedup_by(|a, b| {
        a.width == b.width && a.height == b.height && a.refresh_hz == b.refresh_hz
    });
    let selected_mode = selected_mode(&modes);
    let supports_1080p = std::env::var("PIXEL8_1080P_QUALIFIED").is_ok_and(|v| v == "1")
        && modes.iter().any(|m| m.width >= 1920 && m.height >= 1080);
    Capabilities {
        display_modes: modes,
        selected_mode,
        decoders,
        supports_1080p,
        software_version: env!("CARGO_PKG_VERSION").into(),
    }
}
fn selected_mode(supported: &[Mode]) -> Mode {
    if let Ok(entries) = fs::read_dir("/sys/class/drm") {
        for e in entries.flatten() {
            if let Ok(value) = fs::read_to_string(e.path().join("mode")) {
                if let Some(mode) = parse_active_mode(&value) {
                    return mode;
                }
            }
        }
    }
    if let Ok(value) = std::env::var("PIXEL8_DISPLAY_MODE") {
        if let Some(mode) = parse_active_mode(&value) {
            if supported.is_empty()
                || supported.iter().any(|m| {
                    m.width == mode.width
                        && m.height == mode.height
                        && m.refresh_hz == mode.refresh_hz
                })
            {
                return mode;
            }
        }
    }
    // This is the configured 720p30 target profile, not a claim that a display
    // is connected or that KMS has selected this mode. `doctor` labels it so.
    Mode {
        width: 1280,
        height: 720,
        refresh_hz: 30,
    }
}
fn parse_active_mode(value: &str) -> Option<Mode> {
    let line = value.trim().trim_start_matches("U:");
    let (dimensions, hz) = line.rsplit_once('-').or_else(|| line.rsplit_once('@'))?;
    let (width, height) = dimensions
        .trim_end_matches(|c| c == 'p' || c == 'i')
        .split_once('x')?;
    Some(Mode {
        width: width.parse().ok()?,
        height: height.parse().ok()?,
        refresh_hz: hz.trim_end_matches("Hz").parse().ok()?,
    })
}
fn parse_edid_modes(edid: &[u8]) -> Vec<Mode> {
    let mut modes = Vec::new();
    if edid.len() < 128 {
        return modes;
    }
    if edid.get(..8) != Some(&[0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00])
        || edid
            .chunks_exact(128)
            .any(|b| b.iter().fold(0u8, |a, v| a.wrapping_add(*v)) != 0)
    {
        return modes;
    }
    let mut ranges = vec![(54usize, 126usize)];
    for (block_index, block) in edid.chunks_exact(128).enumerate().skip(1) {
        if block[0] == 0x02 {
            let end = if block[2] == 0 {
                127
            } else {
                usize::from(block[2]).min(127)
            };
            if end < 127 {
                ranges.push((128 * block_index + end, 128 * block_index + 127));
            }
        }
    }
    // The base block contains four detailed timing descriptors.
    ranges[0] = (54, 126);
    for (start, end) in ranges {
        let mut off = start;
        while off + 18 <= end && off + 18 <= edid.len() {
            let d = &edid[off..off + 18];
            let pixel_clock = u16::from_le_bytes([d[0], d[1]]) as u64 * 10_000;
            if pixel_clock > 0 {
                let ha = u32::from(d[2]) + ((u32::from(d[4]) & 0xf0) << 4);
                let hb = u32::from(d[3]) + ((u32::from(d[4]) & 0x0f) << 8);
                let va = u32::from(d[5]) + ((u32::from(d[7]) & 0xf0) << 4);
                let vb = u32::from(d[6]) + ((u32::from(d[7]) & 0x0f) << 8);
                let total = u64::from(ha + hb) * u64::from(va + vb);
                if total > 0 {
                    let refresh = ((pixel_clock + total / 2) / total) as u32;
                    if ha > 0
                        && va > 0
                        && refresh > 0
                        && !modes.iter().any(|m: &Mode| {
                            m.width == ha && m.height == va && m.refresh_hz == refresh
                        })
                    {
                        modes.push(Mode {
                            width: ha,
                            height: va,
                            refresh_hz: refresh,
                        });
                    }
                }
            }
            off += 18;
        }
    }
    modes
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn edid_detailed_timing_reports_real_refresh() {
        let mut e = vec![0u8; 128];
        e[..8].copy_from_slice(&[0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00]);
        e[54..72].copy_from_slice(&[
            0x02, 0x3a, 0x80, 0x18, 0x71, 0x38, 0x2d, 0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        ]);
        e[127] = 0u8.wrapping_sub(e[..127].iter().fold(0u8, |a, v| a.wrapping_add(*v)));
        let m = parse_edid_modes(&e);
        assert!(m
            .iter()
            .any(|x| x.width == 1920 && x.height == 1080 && x.refresh_hz == 60));
    }
}
pub fn doctor(cfg: &crate::config::Config) -> Result<()> {
    let c = capabilities();
    println!("Pixel8 Player {}", c.software_version);
    println!("Device ID: {}", cfg.device_id);
    println!("API configured: {}", cfg.api_base_url.is_some());
    println!("Paired: {}", cfg.device_token.is_some());
    println!(
        "Scanout modes: {}",
        c.display_modes
            .iter()
            .map(|m| format!("{}x{}@{}", m.width, m.height, m.refresh_hz))
            .collect::<Vec<_>>()
            .join(", ")
    );
    let selected = &c.selected_mode;
    println!(
        "Target mode: {}x{}@{}",
        selected.width, selected.height, selected.refresh_hz
    );
    println!(
        "Target mode source: {}",
        if active_drm_mode().is_some() {
            "reported by DRM sysfs (verify during playback)"
        } else if std::env::var_os("PIXEL8_DISPLAY_MODE").is_some() {
            "PIXEL8_DISPLAY_MODE target; not confirmed active by DRM"
        } else {
            "default 720p30 target; not confirmed active by DRM"
        }
    );
    println!("ALSA HDMI device: {}", cfg.audio_device);
    #[cfg(feature = "native-gstreamer")]
    {
        gstreamer::init()?;
        for plugin in [
            "playbin3",
            "kmssink",
            "alsasink",
            "imagefreeze",
            "v4l2h264dec",
        ] {
            let found = gstreamer::ElementFactory::find(plugin).is_some();
            println!(
                "GStreamer {plugin}: {}",
                if found { "available" } else { "missing" }
            );
            if !found {
                bail!("required GStreamer plugin {plugin} is unavailable");
            }
        }
    }
    #[cfg(not(feature = "native-gstreamer"))]
    println!("GStreamer renderer: unavailable in this build");
    for p in ["/dev/dri/card0", "/dev/snd"] {
        println!(
            "{p}: {}",
            if Path::new(p).exists() {
                "available"
            } else {
                "missing"
            }
        );
    }
    if !Path::new("/dev/dri/card0").exists() {
        bail!("KMS device unavailable")
    };
    Ok(())
}
fn active_drm_mode() -> Option<Mode> {
    let entries = fs::read_dir("/sys/class/drm").ok()?;
    entries.flatten().find_map(|e| {
        fs::read_to_string(e.path().join("mode"))
            .ok()
            .and_then(|s| parse_active_mode(&s))
    })
}
