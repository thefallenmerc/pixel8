#[cfg(feature = "native-gstreamer")]
use anyhow::{Context, Result};
#[cfg(feature = "native-gstreamer")]
use std::collections::VecDeque;
use std::sync::Arc;
#[cfg(feature = "native-gstreamer")]
use std::sync::Mutex;

pub struct GstRenderer {
    #[cfg(feature = "native-gstreamer")]
    current: Option<gstreamer::Element>,
    #[cfg(feature = "native-gstreamer")]
    video_sink: Arc<Mutex<Option<gstreamer::Element>>>,
    #[cfg(feature = "native-gstreamer")]
    playlist: Arc<Mutex<PlaylistState>>,
    #[cfg(feature = "native-gstreamer")]
    audio_device: String,
    #[cfg(feature = "native-gstreamer")]
    video_sink_factory: String,
    #[cfg(feature = "native-gstreamer")]
    audio_sink_factory: String,
    change_notify: Arc<tokio::sync::Notify>,
}
#[derive(Clone)]
pub struct RendererMetrics {
    #[cfg(feature = "native-gstreamer")]
    playlist: Arc<Mutex<PlaylistState>>,
    #[cfg(feature = "native-gstreamer")]
    video_sink: Arc<Mutex<Option<gstreamer::Element>>>,
    change_notify: Arc<tokio::sync::Notify>,
}
impl RendererMetrics {
    pub async fn item_changed(&self) {
        self.change_notify.notified().await;
    }
    pub fn snapshot(&self) -> (usize, u64, String) {
        #[cfg(feature = "native-gstreamer")]
        {
            use gstreamer::prelude::*;
            let (current, decoder) = {
                let state = self.playlist.lock().unwrap();
                (
                    state.current,
                    state
                        .decoder
                        .clone()
                        .unwrap_or_else(|| "not-yet-negotiated".into()),
                )
            };
            let dropped = self
                .video_sink
                .lock()
                .unwrap()
                .as_ref()
                .map(|s| {
                    s.property::<gstreamer::Structure>("stats")
                        .get::<u64>("dropped")
                        .unwrap_or(0)
                })
                .unwrap_or(0);
            return (current, dropped, decoder);
        }
        #[cfg(not(feature = "native-gstreamer"))]
        (0, 0, "unavailable".into())
    }
}
#[cfg(feature = "native-gstreamer")]
struct PlaylistState {
    uris: Vec<String>,
    current: usize,
    pending: VecDeque<usize>,
    last_error: Option<String>,
    async_done: bool,
    stream_started: bool,
    initial_stream_seen: bool,
    segment_seen: bool,
    pending_activation: Option<usize>,
    pending_rendered_baseline: Option<u64>,
    last_rendered_frames: Option<u64>,
    requested_uri: Option<String>,
    frame_received: bool,
    decoded_frames: u64,
    switching_publication: bool,
    ready_or_null_transitions: u64,
    decoder: Option<String>,
}
impl Default for GstRenderer {
    fn default() -> Self {
        Self {
            #[cfg(feature = "native-gstreamer")]
            current: None,
            #[cfg(feature = "native-gstreamer")]
            video_sink: Arc::new(Mutex::new(None)),
            #[cfg(feature = "native-gstreamer")]
            playlist: Arc::new(Mutex::new(PlaylistState {
                uris: Vec::new(),
                current: 0,
                pending: VecDeque::new(),
                last_error: None,
                async_done: false,
                stream_started: false,
                initial_stream_seen: false,
                segment_seen: false,
                pending_activation: None,
                pending_rendered_baseline: None,
                last_rendered_frames: None,
                requested_uri: None,
                frame_received: false,
                decoded_frames: 0,
                switching_publication: false,
                ready_or_null_transitions: 0,
                decoder: None,
            })),
            #[cfg(feature = "native-gstreamer")]
            audio_device: "hw:0,0".into(),
            #[cfg(feature = "native-gstreamer")]
            video_sink_factory: "kmssink".into(),
            #[cfg(feature = "native-gstreamer")]
            audio_sink_factory: "alsasink".into(),
            change_notify: Arc::new(tokio::sync::Notify::new()),
        }
    }
}
impl GstRenderer {
    pub fn metrics(&self) -> RendererMetrics {
        RendererMetrics {
            #[cfg(feature = "native-gstreamer")]
            playlist: Arc::clone(&self.playlist),
            #[cfg(feature = "native-gstreamer")]
            video_sink: Arc::clone(&self.video_sink),
            change_notify: Arc::clone(&self.change_notify),
        }
    }
    #[cfg(feature = "native-gstreamer")]
    pub fn new(audio_device: &str) -> Result<Self> {
        use gstreamer::prelude::*;
        gstreamer::init()?;
        let registry = gstreamer::Registry::get();
        let decoder = registry
            .lookup_feature("v4l2h264dec")
            .context("the Raspberry Pi V4L2 H.264 decoder plugin is required")?;
        decoder.set_rank(gstreamer::Rank::PRIMARY);
        if let Some(software) = registry.lookup_feature("avdec_h264") {
            software.set_rank(gstreamer::Rank::NONE);
        }
        let mut renderer = Self::default();
        renderer.audio_device = audio_device.to_owned();
        Ok(renderer)
    }
    #[cfg(all(test, feature = "native-gstreamer"))]
    pub(crate) fn new_cpu_test_renderer() -> Result<Self> {
        gstreamer::init()?;
        let mut renderer = Self::default();
        renderer.video_sink_factory = "fakesink".into();
        renderer.audio_sink_factory = "fakesink".into();
        Ok(renderer)
    }
    #[cfg(not(feature = "native-gstreamer"))]
    pub fn new(_: &str) -> anyhow::Result<Self> {
        anyhow::bail!("native GStreamer support was not compiled")
    }
    #[cfg(feature = "native-gstreamer")]
    pub fn start_playlist(
        &mut self,
        paths: &[std::path::PathBuf],
        muted: bool,
        volume: u8,
    ) -> Result<()> {
        use gst::prelude::*;
        use gstreamer as gst;
        anyhow::ensure!(!paths.is_empty(), "cannot start an empty playlist");
        let playbin = if let Some(p) = &self.current {
            p.clone()
        } else {
            let p = gst::ElementFactory::make("playbin3")
                .build()
                .context("GStreamer playbin3 unavailable")?;
            let video = gst::ElementFactory::make(&self.video_sink_factory)
                .property("sync", true)
                .build()
                .context("GStreamer kmssink unavailable")?;
            if self.video_sink_factory == "fakesink" {
                video.set_property("enable-last-sample", true);
                video.set_property("signal-handoffs", true);
            }
            let video_pad = video
                .static_pad("sink")
                .context("video sink has no sink pad")?;
            let frame_state = Arc::clone(&self.playlist);
            let frame_notify = Arc::clone(&self.change_notify);
            video_pad
                .add_probe(
                    gst::PadProbeType::BUFFER | gst::PadProbeType::EVENT_DOWNSTREAM,
                    move |_, info| {
                        let downstream_event = info.event().map(|event| event.type_());
                        let has_buffer = info.buffer().is_some();
                        let mut state = frame_state
                            .lock()
                            .unwrap_or_else(std::sync::PoisonError::into_inner);
                        if let Some(event_type) = downstream_event {
                            match event_type {
                                gst::EventType::StreamStart => {
                                    let last_rendered = state.last_rendered_frames;
                                    complete_rendered_activation(
                                        &mut state,
                                        last_rendered,
                                        &frame_notify,
                                    );
                                    state.stream_started = true;
                                    state.segment_seen = false;
                                    state.frame_received = false;
                                    if state.pending_rendered_baseline.is_none() {
                                        state.pending_rendered_baseline =
                                            state.last_rendered_frames;
                                    }
                                    if state.initial_stream_seen {
                                        state.pending_activation = state.pending.front().copied();
                                        if let Some(index) = state.pending_activation {
                                            state.requested_uri = state.uris.get(index).cloned();
                                        }
                                    } else {
                                        state.initial_stream_seen = true;
                                        state.pending_activation = Some(state.current);
                                    }
                                }
                                gst::EventType::Segment => state.segment_seen = true,
                                _ => {}
                            }
                            return gst::PadProbeReturn::Ok;
                        }
                        if has_buffer && state.stream_started && state.segment_seen {
                            state.frame_received = true;
                            state.decoded_frames = state.decoded_frames.saturating_add(1);
                        }
                        gst::PadProbeReturn::Ok
                    },
                )
                .context("cannot observe decoded video frames")?;
            let audio = if self.audio_sink_factory == "alsasink" {
                gst::ElementFactory::make("alsasink")
                    .property("device", self.audio_device.as_str())
                    .property("sync", true)
                    .build()
            } else {
                gst::ElementFactory::make(&self.audio_sink_factory)
                    .property("sync", true)
                    .build()
            }
            .context("GStreamer audio sink unavailable")?;
            p.set_property("video-sink", video);
            *self.video_sink.lock().unwrap() = Some(p.property::<gst::Element>("video-sink"));
            p.set_property("audio-sink", audio);
            let state = Arc::clone(&self.playlist);
            p.connect("about-to-finish", false, move |values| {
                let Ok(element) = values[0].get::<gst::Element>() else {
                    return None;
                };
                let uri = {
                    let mut state = state
                        .lock()
                        .unwrap_or_else(std::sync::PoisonError::into_inner);
                    if state.uris.is_empty() {
                        return None;
                    }
                    let next = state
                        .pending
                        .back()
                        .copied()
                        .unwrap_or(state.current)
                        .wrapping_add(1)
                        % state.uris.len();
                    state.pending.push_back(next);
                    let uri = state.uris[next].clone();
                    state.pending_rendered_baseline = state.last_rendered_frames;
                    uri
                };
                element.set_property("uri", uri.as_str());
                None
            });
            let state = Arc::clone(&self.playlist);
            p.connect("deep-element-added", false, move |values| {
                let Ok(element) = values[2].get::<gst::Element>() else {
                    return None;
                };
                if let Some(factory) = element.factory() {
                    let name = factory.name().to_string();
                    if name.contains("h264") && (name.contains("dec") || name.contains("decoder")) {
                        state
                            .lock()
                            .unwrap_or_else(std::sync::PoisonError::into_inner)
                            .decoder = Some(name);
                    }
                }
                None
            });
            self.current = Some(p.clone());
            let bus = p.bus().context("playbin3 has no bus")?;
            let playbin_for_bus = p.clone();
            let state = Arc::clone(&self.playlist);
            let video_sink_for_bus = Arc::clone(&self.video_sink);
            let notify_for_bus = Arc::clone(&self.change_notify);
            std::thread::Builder::new()
                .name("pixel8-gst-bus".into())
                .spawn(move || loop {
                    let message = bus.timed_pop(gstreamer::ClockTime::from_mseconds(250));
                    let rendered = video_sink_for_bus
                        .lock()
                        .unwrap_or_else(std::sync::PoisonError::into_inner)
                        .as_ref()
                        .and_then(sink_rendered_frames);
                    let source_is_pipeline = message.as_ref().is_some_and(|message| {
                        message.src().is_some_and(|source| {
                            source == playbin_for_bus.upcast_ref::<gstreamer::Object>()
                        })
                    });
                    let bus_event = message.as_ref().map(|message| match message.view() {
                        gstreamer::MessageView::Error(error) => (
                            Some(format!("{} ({:?})", error.error(), error.debug())),
                            false,
                            false,
                        ),
                        gstreamer::MessageView::AsyncDone(_) => (None, true, false),
                        gstreamer::MessageView::StateChanged(changed) => (
                            None,
                            false,
                            source_is_pipeline
                                && matches!(
                                    changed.current(),
                                    gstreamer::State::Ready | gstreamer::State::Null
                                ),
                        ),
                        _ => (None, false, false),
                    });
                    let mut s = state
                        .lock()
                        .unwrap_or_else(std::sync::PoisonError::into_inner);
                    complete_rendered_activation(&mut s, rendered, &notify_for_bus);
                    s.last_rendered_frames = rendered;
                    let Some(bus_event) = bus_event else {
                        continue;
                    };
                    if let Some(error) = bus_event.0 {
                        s.last_error = Some(error);
                    }
                    let resume_playing = bus_event.1 && s.requested_uri.is_some();
                    if resume_playing {
                        // A pending switch can report ASYNC_DONE before its
                        // read-only current-uri property changes. StreamStart
                        // and a rendered frame remain required for readiness.
                        s.async_done = true;
                    }
                    if bus_event.2 {
                        s.ready_or_null_transitions = s.ready_or_null_transitions.saturating_add(1);
                    }
                    drop(s);
                    if resume_playing {
                        let _ = playbin_for_bus.set_state(gstreamer::State::Playing);
                    }
                })?;
            p
        };
        let uris = paths
            .iter()
            .map(|p| {
                url::Url::from_file_path(p)
                    .map(|u| u.to_string())
                    .map_err(|_| anyhow::anyhow!("invalid media path"))
            })
            .collect::<Result<Vec<_>>>()?;
        if let Some(current) = &self.current {
            let unchanged = {
                let state = self.playlist.lock().unwrap();
                state.uris == uris && state.last_error.is_none()
            };
            if unchanged && current.current_state() == gst::State::Playing {
                current.set_property("volume", f64::from(volume.min(100)) / 100.0);
                current.set_property("mute", muted);
                return Ok(());
            }
        }
        let decoded_frames = self.playlist.lock().unwrap().decoded_frames;
        let ready_or_null_transitions = self.playlist.lock().unwrap().ready_or_null_transitions;
        let decoder = self.playlist.lock().unwrap().decoder.clone();
        let rendered_before = self
            .video_sink
            .lock()
            .unwrap()
            .as_ref()
            .and_then(sink_rendered_frames);
        let previous_uri = self.playlist.lock().unwrap().uris.first().cloned();
        *self.playlist.lock().unwrap() = PlaylistState {
            requested_uri: Some(uris[0].clone()),
            uris,
            current: 0,
            pending: VecDeque::new(),
            last_error: None,
            async_done: false,
            stream_started: false,
            initial_stream_seen: false,
            segment_seen: false,
            pending_activation: None,
            pending_rendered_baseline: rendered_before,
            last_rendered_frames: rendered_before,
            frame_received: false,
            decoded_frames,
            switching_publication: true,
            ready_or_null_transitions,
            decoder,
        };
        playbin.set_property("volume", f64::from(volume.min(100)) / 100.0);
        playbin.set_property("mute", muted);
        let uri = self.playlist.lock().unwrap().uris[0].clone();
        let has_instant_uri = playbin.find_property("instant-uri").is_some();
        // Still images (pairing QR) need an imagefreeze filter to stay on screen.
        let is_still = uri.ends_with(".png");
        let was_still = previous_uri
            .as_deref()
            .is_some_and(|previous| previous.ends_with(".png"));
        let image_mode_switch = previous_uri.is_some() && (was_still || is_still);
        if image_mode_switch {
            // playbin3 1.22 cannot renegotiate a still-image imagefreeze branch
            // in place. QR refreshes and QR↔video handoffs intentionally
            // rebuild that branch; normal video publication changes stay live.
            playbin.set_state(gst::State::Ready)?;
        }
        if is_still && !was_still {
            let filter = gst::ElementFactory::make("imagefreeze")
                .build()
                .context("GStreamer imagefreeze plugin is required to display pairing QR")?;
            playbin.set_property("video-filter", filter);
        } else if !is_still && was_still {
            playbin.set_property("video-filter", Option::<gst::Element>::None);
        }
        // URI changes are applied in-place. The running pipeline keeps its
        // clock and display surface; instant-uri asks playbin3 to switch to the
        // new publication without waiting for EOS on the previous one.
        let has_active_publication = !self.playlist.lock().unwrap().uris.is_empty();
        let replacing_live = has_active_publication
            && !image_mode_switch
            && matches!(
                playbin.current_state(),
                gst::State::Paused | gst::State::Playing
            );
        if has_instant_uri && replacing_live {
            playbin.set_property("instant-uri", true);
        }
        playbin.set_property("uri", uri.as_str());
        if has_instant_uri && replacing_live {
            // The property is a one-shot switch mode; leaving it enabled can
            // hold playbin3 in PAUSED after preroll instead of resuming output.
            playbin.set_property("instant-uri", false);
        }
        if !replacing_live {
            self.playlist.lock().unwrap().switching_publication = false;
        }
        // For a first activation or a renderer left in READY by an empty list,
        // this starts playback. It is a no-op for an already-running pipeline.
        playbin.set_state(gst::State::Playing)?;
        let deadline = std::time::Instant::now() + std::time::Duration::from_secs(10);
        loop {
            let pipeline_state = playbin.current_state();
            let (error, ready, resume_live, snapshot) = {
                let mut state = self.playlist.lock().unwrap();
                let error = state.last_error.take();
                let ready = (replacing_live || state.async_done)
                    && state.stream_started
                    && state.frame_received
                    && state.pending_activation.is_none()
                    && pipeline_state == gst::State::Playing;
                let resume_live =
                    replacing_live && state.stream_started && pipeline_state == gst::State::Paused;
                let snapshot = (state.async_done, state.stream_started, state.frame_received);
                (error, ready, resume_live, snapshot)
            };
            if let Some(error) = error {
                anyhow::bail!("renderer failed to start: {error}");
            }
            if resume_live {
                playbin.set_state(gst::State::Playing)?;
            }
            if ready {
                self.playlist.lock().unwrap().switching_publication = false;
                break;
            }
            if std::time::Instant::now() >= deadline {
                self.playlist.lock().unwrap().switching_publication = false;
                let current_uri = playbin.property::<Option<String>>("uri");
                let final_pipeline_state = playbin.current_state();
                anyhow::bail!(
                    "renderer did not preroll within 10 seconds (async_done={}, stream_started={}, frame_received={}, current_uri={:?}, pipeline_state={:?})",
                    snapshot.0,
                    snapshot.1,
                    snapshot.2,
                    current_uri,
                    final_pipeline_state
                );
            }
            std::thread::sleep(std::time::Duration::from_millis(20));
        }
        Ok(())
    }
    #[cfg(not(feature = "native-gstreamer"))]
    pub fn start_playlist(
        &mut self,
        _: &[std::path::PathBuf],
        _: bool,
        _: u8,
    ) -> anyhow::Result<()> {
        anyhow::bail!("native GStreamer support was not compiled")
    }
    #[cfg(feature = "native-gstreamer")]
    pub fn stop(&mut self) -> Result<()> {
        use gst::prelude::*;
        use gstreamer as gst;
        if let Some(p) = &self.current {
            let ready_or_null_transitions = {
                let mut state = self.playlist.lock().unwrap();
                let transitions = state.ready_or_null_transitions;
                // Disable about-to-finish URI changes and stale bus-driven
                // PLAYING resumes before taking the active pipeline to READY.
                *state = PlaylistState {
                    uris: Vec::new(),
                    current: 0,
                    pending: VecDeque::new(),
                    last_error: None,
                    async_done: false,
                    stream_started: false,
                    initial_stream_seen: false,
                    segment_seen: false,
                    pending_activation: None,
                    pending_rendered_baseline: None,
                    last_rendered_frames: None,
                    requested_uri: None,
                    frame_received: false,
                    decoded_frames: 0,
                    switching_publication: false,
                    ready_or_null_transitions: transitions,
                    decoder: None,
                };
                transitions
            };
            p.set_state(gst::State::Ready)?;
            p.set_property("uri", "");
            p.set_property("video-filter", Option::<gst::Element>::None);
            let mut state = self.playlist.lock().unwrap();
            state.ready_or_null_transitions = state
                .ready_or_null_transitions
                .max(ready_or_null_transitions);
        }
        Ok(())
    }
    #[cfg(feature = "native-gstreamer")]
    pub fn check_health(&self) -> Result<()> {
        let mut state = self.playlist.lock().unwrap();
        if let Some(error) = state.last_error.take() {
            anyhow::bail!("GStreamer playback error: {error}")
        }
        Ok(())
    }
    #[cfg(not(feature = "native-gstreamer"))]
    pub fn stop(&mut self) -> anyhow::Result<()> {
        anyhow::bail!("native GStreamer support was not compiled")
    }
    #[cfg(not(feature = "native-gstreamer"))]
    pub fn check_health(&self) -> anyhow::Result<()> {
        anyhow::bail!("native GStreamer support was not compiled")
    }
}

#[cfg(feature = "native-gstreamer")]
fn sink_rendered_frames(sink: &gstreamer::Element) -> Option<u64> {
    use gstreamer::prelude::*;
    sink.property::<gstreamer::Structure>("stats")
        .get::<u64>("rendered")
        .ok()
}

#[cfg(feature = "native-gstreamer")]
fn complete_rendered_activation(
    state: &mut PlaylistState,
    rendered_frames: Option<u64>,
    notify: &tokio::sync::Notify,
) {
    let Some(index) = state.pending_activation else {
        return;
    };
    let Some(baseline) = state.pending_rendered_baseline else {
        return;
    };
    let Some(rendered) = rendered_frames else {
        return;
    };
    if rendered < baseline {
        // playbin flushes reset GstBaseSink's rendered counter to zero.
        state.pending_rendered_baseline = Some(rendered);
        return;
    }
    if rendered <= baseline {
        return;
    }
    state.pending_activation = None;
    state.pending_rendered_baseline = None;
    if state.pending.front() == Some(&index) {
        state.pending.pop_front();
    }
    if state.current != index {
        state.current = index;
        notify.notify_one();
    }
}

#[cfg(all(test, feature = "native-gstreamer"))]
mod native_tests {
    use super::*;
    use gstreamer::prelude::*;
    use std::time::{Duration, Instant};

    fn wait_for_item(renderer: &GstRenderer, expected: usize) {
        let deadline = Instant::now() + Duration::from_secs(5);
        loop {
            if renderer.playlist.lock().unwrap().current == expected {
                return;
            }
            if Instant::now() >= deadline {
                let snapshot = {
                    let state = renderer.playlist.lock().unwrap();
                    (
                        state.current,
                        state.requested_uri.clone(),
                        state.pending.clone(),
                        state.async_done,
                        state.stream_started,
                        state.frame_received,
                        state.switching_publication,
                    )
                };
                let pipeline_state = renderer
                    .current
                    .as_ref()
                    .map(|pipeline| pipeline.current_state());
                panic!(
                    "playlist did not reach item {expected}; state={snapshot:?}; pipeline={:?}",
                    pipeline_state
                );
            }
            std::thread::sleep(Duration::from_millis(10));
        }
    }

    fn last_chroma(renderer: &GstRenderer) -> (u8, u8) {
        let sink = renderer.video_sink.lock().unwrap().clone().unwrap();
        let sample = sink
            .property::<Option<gstreamer::Sample>>("last-sample")
            .expect("fakesink should retain the latest decoded sample");
        let map = sample
            .buffer()
            .expect("decoded sample should have a buffer")
            .map_readable()
            .expect("decoded buffer should be readable");
        let structure = sample.caps().unwrap().structure(0).unwrap();
        let width = structure.get::<i32>("width").unwrap() as usize;
        let height = structure.get::<i32>("height").unwrap() as usize;
        let luma_bytes = width * height;
        let data = map.as_slice();
        let format = structure.get::<String>("format").unwrap();
        let (first, second): (Vec<u8>, Vec<u8>) = if format == "I420" || format == "YV12" {
            let plane = luma_bytes / 4;
            (
                data[luma_bytes..luma_bytes + plane].to_vec(),
                data[luma_bytes + plane..luma_bytes + plane * 2].to_vec(),
            )
        } else {
            let chroma = &data[luma_bytes..];
            (
                chroma.iter().step_by(2).copied().collect(),
                chroma.iter().skip(1).step_by(2).copied().collect(),
            )
        };
        let mean = |plane: &[u8]| -> u8 {
            (plane.iter().map(|v| u64::from(*v)).sum::<u64>() / plane.len() as u64) as u8
        };
        (mean(&first), mean(&second))
    }

    fn wait_for_frame_after(renderer: &GstRenderer, previous: u64) {
        let deadline = Instant::now() + Duration::from_secs(5);
        loop {
            if renderer.playlist.lock().unwrap().decoded_frames > previous {
                return;
            }
            assert!(Instant::now() < deadline, "no new decoded frame arrived");
            std::thread::sleep(Duration::from_millis(10));
        }
    }

    fn wait_for_chroma(renderer: &GstRenderer, expected: (u8, u8)) {
        let deadline = Instant::now() + Duration::from_secs(5);
        loop {
            if last_chroma(renderer) == expected {
                return;
            }
            assert!(
                Instant::now() < deadline,
                "sink did not render expected chroma {expected:?}; last={:?}",
                last_chroma(renderer)
            );
            std::thread::sleep(Duration::from_millis(10));
        }
    }

    fn wait_for_different_chroma(renderer: &GstRenderer, previous: (u8, u8)) -> (u8, u8) {
        let deadline = Instant::now() + Duration::from_secs(5);
        loop {
            let current = last_chroma(renderer);
            if current != previous {
                return current;
            }
            assert!(
                Instant::now() < deadline,
                "sink did not render a frame distinct from {previous:?}"
            );
            std::thread::sleep(Duration::from_millis(10));
        }
    }

    fn handoff_counter(renderer: &GstRenderer) -> Arc<std::sync::atomic::AtomicU64> {
        let sink = renderer.video_sink.lock().unwrap().clone().unwrap();
        let counter = Arc::new(std::sync::atomic::AtomicU64::new(0));
        let observed = Arc::clone(&counter);
        sink.connect("handoff", false, move |_| {
            observed.fetch_add(1, std::sync::atomic::Ordering::SeqCst);
            None
        });
        counter
    }

    fn wait_for_handoffs(
        renderer: &GstRenderer,
        counter: &std::sync::atomic::AtomicU64,
        baseline: u64,
        count: u64,
    ) {
        let sink = renderer.video_sink.lock().unwrap().clone().unwrap();
        let deadline = Instant::now() + Duration::from_secs(5);
        loop {
            let observed = counter.load(std::sync::atomic::Ordering::SeqCst);
            if observed >= baseline + count {
                return;
            }
            let (current, pending) = {
                let state = renderer.playlist.lock().unwrap();
                (state.current, state.pending.clone())
            };
            let pipeline_state = renderer
                .current
                .as_ref()
                .map(|pipeline| pipeline.current_state());
            assert!(
                Instant::now() < deadline,
                "sink did not hand off {count} frames after baseline {baseline}; current={:?}, pending={:?}, state={:?}, handoffs={observed}, rendered={:?}",
                current,
                pending,
                pipeline_state,
                sink_rendered_frames(&sink)
            );
            std::thread::sleep(Duration::from_millis(10));
        }
    }

    fn clip(temp: &std::path::Path, name: &str, bytes: &[u8]) -> std::path::PathBuf {
        let path = temp.join(name);
        std::fs::write(&path, bytes).unwrap();
        path
    }

    #[test]
    fn cpu_fakesink_decodes_advances_loops_and_replaces_live_publications() {
        use gstreamer::prelude::*;
        let temp = tempfile::tempdir().unwrap();
        let first = clip(
            temp.path(),
            "first.mp4",
            include_bytes!("../tests/fixtures/tiny-red.mp4"),
        );
        let second = clip(
            temp.path(),
            "second.mp4",
            include_bytes!("../tests/fixtures/tiny-blue.mp4"),
        );
        let broken = temp.path().join("broken.png");
        std::fs::write(&broken, b"not a decodable image").unwrap();

        let mut renderer = GstRenderer::new_cpu_test_renderer().unwrap();
        assert!(renderer.start_playlist(&[], true, 0).is_err());
        renderer
            .start_playlist(&[first.clone(), second.clone()], true, 0)
            .unwrap();
        let pipeline = renderer.current.as_ref().unwrap().clone();
        std::thread::sleep(Duration::from_millis(100));
        assert_eq!(pipeline.current_state(), gstreamer::State::Playing);
        assert_eq!(renderer.current.as_ref().unwrap(), &pipeline);
        assert!(renderer.playlist.lock().unwrap().decoded_frames > 0);
        let first_chroma = last_chroma(&renderer);
        let frames_before_second = renderer.playlist.lock().unwrap().decoded_frames;
        wait_for_item(&renderer, 1);
        wait_for_frame_after(&renderer, frames_before_second);
        let second_chroma = (240, 110);
        assert_eq!(first_chroma, (90, 240));
        wait_for_chroma(&renderer, second_chroma);
        wait_for_item(&renderer, 0);
        wait_for_chroma(&renderer, first_chroma);

        // A settings-only update applies in place and leaves the playing item
        // and decoded-frame stream untouched.
        let item = renderer.playlist.lock().unwrap().current;
        renderer
            .start_playlist(&[first.clone(), second.clone()], false, 75)
            .unwrap();
        assert_eq!(renderer.playlist.lock().unwrap().current, item);

        // Replacing a publication keeps the same PLAYING pipeline and confirms
        // the new item only after its own stream-start and decoded frame.
        let transitions_before_replace =
            renderer.playlist.lock().unwrap().ready_or_null_transitions;
        let frames_before_replace = renderer.playlist.lock().unwrap().decoded_frames;
        let replacement_handoffs = handoff_counter(&renderer);
        renderer
            .start_playlist(&[second.clone()], false, 75)
            .unwrap();
        std::thread::sleep(Duration::from_millis(100));
        assert_eq!(renderer.current.as_ref().unwrap(), &pipeline);
        assert_eq!(pipeline.current_state(), gstreamer::State::Playing);
        assert_eq!(
            renderer.playlist.lock().unwrap().ready_or_null_transitions,
            transitions_before_replace,
            "live publication replacement transitioned the pipeline through READY or NULL"
        );
        wait_for_frame_after(&renderer, frames_before_replace);
        wait_for_chroma(&renderer, second_chroma);
        let handoffs_after_activation =
            replacement_handoffs.load(std::sync::atomic::Ordering::SeqCst);
        wait_for_handoffs(
            &renderer,
            &replacement_handoffs,
            handoffs_after_activation,
            16,
        );
        assert_eq!(renderer.playlist.lock().unwrap().current, 0);
        assert_eq!(pipeline.current_state(), gstreamer::State::Playing);

        renderer.stop().unwrap();
        renderer
            .start_playlist(std::slice::from_ref(&first), true, 0)
            .unwrap();
        assert_eq!(pipeline.current_state(), gstreamer::State::Playing);
        assert!(renderer.playlist.lock().unwrap().decoded_frames > 0);
        let qr = temp.path().join("pairing-one.png");
        image::RgbImage::from_pixel(2, 2, image::Rgb([90, 80, 70]))
            .save(&qr)
            .unwrap();
        let qr_two = temp.path().join("pairing-two.png");
        image::RgbImage::from_pixel(2, 2, image::Rgb([30, 180, 210]))
            .save(&qr_two)
            .unwrap();
        renderer.stop().unwrap();
        renderer.start_playlist(&[qr], true, 0).unwrap();
        assert!(renderer.playlist.lock().unwrap().decoded_frames > 0);
        let first_qr_chroma = last_chroma(&renderer);
        renderer.start_playlist(&[qr_two], true, 0).unwrap();
        let second_qr_chroma = wait_for_different_chroma(&renderer, first_qr_chroma);
        assert_ne!(first_qr_chroma, second_qr_chroma);
        renderer
            .start_playlist(std::slice::from_ref(&second), true, 0)
            .unwrap();
        wait_for_chroma(&renderer, second_chroma);
        renderer.stop().unwrap();
        renderer.start_playlist(&[first.clone()], true, 0).unwrap();
        wait_for_chroma(&renderer, first_chroma);
        assert!(renderer.start_playlist(&[broken], true, 0).is_err());
        renderer.stop().unwrap();
    }

    #[test]
    fn diagnostic_playbin_same_uri_loop_and_live_switch() {
        gstreamer::init().unwrap();
        let temp = tempfile::tempdir().unwrap();
        let first = clip(
            temp.path(),
            "minimal-red.mp4",
            include_bytes!("../tests/fixtures/tiny-red.mp4"),
        );
        let second = clip(
            temp.path(),
            "minimal-blue.mp4",
            include_bytes!("../tests/fixtures/tiny-blue.mp4"),
        );
        let uri_for_next = Arc::new(Mutex::new(
            url::Url::from_file_path(&first).unwrap().to_string(),
        ));
        let callbacks = Arc::new(std::sync::atomic::AtomicU64::new(0));
        let rendered = Arc::new(std::sync::atomic::AtomicU64::new(0));
        let playbin = gstreamer::ElementFactory::make("playbin3").build().unwrap();
        let video = gstreamer::ElementFactory::make("fakesink")
            .property("sync", true)
            .property("signal-handoffs", true)
            .build()
            .unwrap();
        let rendered_counter = Arc::clone(&rendered);
        video.connect("handoff", false, move |_| {
            rendered_counter.fetch_add(1, std::sync::atomic::Ordering::SeqCst);
            None
        });
        let audio = gstreamer::ElementFactory::make("fakesink")
            .property("sync", true)
            .build()
            .unwrap();
        playbin.set_property("video-sink", video);
        playbin.set_property("audio-sink", audio);
        let next_uri = Arc::clone(&uri_for_next);
        let callback_count = Arc::clone(&callbacks);
        playbin.connect("about-to-finish", false, move |values| {
            if let Ok(element) = values[0].get::<gstreamer::Element>() {
                let uri = next_uri.lock().unwrap().clone();
                element.set_property("uri", uri.as_str());
                callback_count.fetch_add(1, std::sync::atomic::Ordering::SeqCst);
            }
            None
        });
        let first_uri = url::Url::from_file_path(&first).unwrap().to_string();
        playbin.set_property("uri", first_uri.as_str());
        playbin.set_state(gstreamer::State::Playing).unwrap();
        let wait_for_frames = |target: u64, timeout: Duration| {
            let deadline = Instant::now() + timeout;
            while rendered.load(std::sync::atomic::Ordering::SeqCst) < target
                && Instant::now() < deadline
            {
                std::thread::sleep(Duration::from_millis(10));
            }
        };
        wait_for_frames(16, Duration::from_secs(5));
        let loop_frames = rendered.load(std::sync::atomic::Ordering::SeqCst);
        let loop_callbacks = callbacks.load(std::sync::atomic::Ordering::SeqCst);
        assert!(
            loop_frames >= 16,
            "same-URI playbin loop rendered {loop_frames} frames after {loop_callbacks} callbacks"
        );

        let blue_uri = url::Url::from_file_path(&second).unwrap().to_string();
        *uri_for_next.lock().unwrap() = blue_uri.clone();
        let before_switch = rendered.load(std::sync::atomic::Ordering::SeqCst);
        playbin.set_property("instant-uri", true);
        playbin.set_property("uri", blue_uri.as_str());
        playbin.set_property("instant-uri", false);
        wait_for_frames(before_switch + 16, Duration::from_secs(5));
        let after_switch = rendered.load(std::sync::atomic::Ordering::SeqCst);
        let after_switch_callbacks = callbacks.load(std::sync::atomic::Ordering::SeqCst);
        playbin.set_state(gstreamer::State::Null).unwrap();
        assert!(
            after_switch >= before_switch + 16,
            "red→instant-blue loop rendered {} frames after {} callbacks",
            after_switch.saturating_sub(before_switch),
            after_switch_callbacks
        );
    }
}
