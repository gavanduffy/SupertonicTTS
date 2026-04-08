# SupertonicTTS — Agent Guide

iOS app that runs SupertonicTTS ONNX models locally with on-device inference.

## Project Type

- **Single-target Xcode project** — `SupertonicTTS.xcodeproj`
- **iOS / SwiftUI** app, Swift 6, `@Observable` state
- **No tests, no CI, no linter, no formatter** — build in Xcode only

## Build & Run

- Open `SupertonicTTS.xcodeproj` in Xcode → run on device or simulator
- No CLI build commands (no `swift build`, no SPM package manifest)

## Model Assets (Critical Setup)

Models are **NOT** in the repo. Before building, download from [HuggingFace](https://huggingface.co/Supertone/supertonic/tree/main/onnx):

**Required files in `/onnx/` (folder reference in Copy Bundle Resources):**
- `tts.json` — engine config (sample rate, chunk sizes)
- `unicode_indexer.json` — Unicode→token ID mapping
- `duration_predictor.onnx`
- `text_encoder.onnx`
- `vector_estimator.onnx`
- `vocoder.onnx`

**Required files in `/voice_styles/` (folder reference in Copy Bundle Resources):**
- `M1.json` — American Male (Tim)
- `F1.json` — American Female (Ellen)
- `M2.json` — British Male (Charlie)
- `F2.json` — British Female (Tina)

If the app throws `"Could not find the onnx directory in the bundle"`, the folders are missing or not added as folder references (not groups) in Copy Bundle Resources.

## Dependencies (Swift Package Manager via Xcode)

| Package | Min Version | Purpose |
|---------|------------|---------|
| `microsoft/onnxruntime-swift-package-manager` | 1.20.0 | ONNX inference (CPU only) |
| `TimOliver/BlurUIKit` | 1.2.2 | Variable blur for bottom bar |
| `buh/CompactSlider` | 2.1.0 | NFE steps slider |
| `AbodiDawoud/KeyboardDismisser` | main (branch) | Tap-to-dismiss keyboard |

All are resolved via Xcode's SPM integration — there is no `Package.swift`.

## Architecture

```
App.swift                    → @main entry, appearance toggle on shake
ContentView.swift            → Main UI: text input, slider, voice picker, generate button
Core/
  SupertonicSynthesizerEngine.swift → ONNX inference pipeline (CPU only, GPU throws)
  TTSService.swift           → Service layer: loads models, warms up, synthesizes to WAV
  OnnxHelpers.swift          → UnicodeProcessor, WAV I/O, model loading, config parsing
Content/
  TextInputView.swift        → Text entry field
  GeneratedAudioView.swift   → Playback controls for generated audio
  PromptListView.swift       → History of past prompts
  PreferencesView.swift      → Settings screen
  PerformanceMonitorView.swift → RTF / timing HUD
  ShakeDetector.swift        → Gesture modifier for appearance toggle
Services/
  ApplicationVM.swift        → @Observable view model (state + generate logic)
  TTSAudioPlayer.swift       → AVAudioPlayer wrapper
  PromptStorage.swift        → Persistent prompt history (file-based)
  CacheController.swift      → Generated audio cache management
  PerformanceMonitor.swift   → Timing/metrics collection
  Preferences.swift          → @AppStorage settings
  Haptics.swift              → Haptic feedback wrapper
  KeyboardObserver.swift     → Keyboard height tracking
Helpers/
  Voice.swift                → Voice enum (4 voices), VoiceStyle, VoiceRawData
  SynthesisConfig.swift      → EngineConfig, SynthesisRequest, SynthesisResult
  SampleText.swift           → Default prompt text
  Helpers.swift              → ShakeEffect, ProgressiveBlurView, String Identifiable
```

## Key Constraints

- **GPU inference is not supported** — `loadSynthesizer` explicitly throws if `useGpu` is true
- **ONNX models run on CPU** via `OnnxRuntimeBindings`
- **Warmup is async and detached** — engine loads in background to avoid blocking UI
- **Text chunking** — max 300 chars per chunk, split by paragraphs → sentences → commas → words
- **Output is WAV** (16-bit PCM, mono) written to `FileManager.cachesDirectory`
- **Voice styles are precomputed and cached** at warmup or first use

## Preferences (@AppStorage keys)

| Key | Default | Purpose |
|-----|---------|---------|
| `WarmupOnLaunch` | `true` | Auto-load engine on app launch |
| `AutoPlayOnNewGeneration` | `true` | Play audio immediately after generation |
| `SavePromptsOnNewGeneration` | `true` | Persist text to prompt history |
| `AutoPasteOnLaunch` | `false` | Paste clipboard text on app foreground |
| `HapticsEnabled` | `true` | Enable haptic feedback |
| `AppAppearance` | nil | `"light"` or `"dark"` (system default if nil) |

## Conventions

- `@Observable` + `@MainActor` for view models (SwiftUI Observation framework)
- `@AppStorage` for all user preferences (no UserDefaults direct access)
- Error handling via `vm.errorMessage` → SwiftUI `.alert(item:)` — never crashes
- `@ObservationIgnored` for non-Observable properties in `@Observable` classes (service, player)
- `String` retroactively conforms to `Identifiable` in `Helpers.swift` for alert binding
