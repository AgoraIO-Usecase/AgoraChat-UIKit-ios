# AgoraChatUIKit 2.0.0 integration validation

`ExampleSPM/AgoraChatUIKitSPMExample.xcodeproj` references this checkout. Its shared `AgoraChatUIKitSPMExample` scheme runs hosted tests without a chat account or app key. The public package product is `AgoraChatUIKit`; the Swift module is `chat_uikit` for both SPM and CocoaPods.

Run from the repository root on a Mac with Xcode and an installed iPhone simulator:

```sh
bash scripts/ci_ios.sh spm
bash scripts/ci_ios.sh pods
```

The scripts run simulator tests with parallel execution disabled, create unsigned Release archives, and verify the complete PNG inventory, both localizations, privacy manifest, and embedded AMRCodec/AgoraChat/aosl frameworks. Set `CI_SIMULATOR_ID` to choose a specific simulator and `CI_OUTPUT_DIR` for an isolated output directory; use a new output directory for each invocation because Xcode does not overwrite `.xcresult` bundles.

Tests cover 328 PNG resources, language and host-resource overrides, narrow/wide-band AMR conversion, navigation layout, data-sync delegate delivery, SDK callback selectors, read-receipt eligibility, and cursor pagination (overlap, end-of-list, in-flight requests and retry). HostResources belong to the app target, not the XCTest bundle. Package-only test runs cannot verify Bundle.main overrides; use the hosted scheme above.

GitHub Actions runs both integration paths on every PR, pushes to main/sdk-5.0/SwiftUIKit, and manual dispatch. Logs and xcresult bundles are uploaded even after failure. CI selects Xcode 26.3 explicitly on macos-15, as listed in the [official runner image catalog](https://github.com/actions/runner-images/blob/main/images/macos/macos-15-Readme.md). Simulator selection matches the active SDK major version.

This document describes commands and coverage, not a claim that a remote release or signed device test passed. Release 2.0.0 must be published before the remote-template instructions in ExampleSPMRemote can be exercised. Microphone recording, playback on hardware, signing, and actual chat-server behavior require separate device/account validation.

Local verification on 2026-11-26: Xcode 26.0.1 / iOS 26.2 simulator. Both commands passed all 31 hosted tests and unsigned Release archives; artifact checks passed for both integrations. These are local results; GitHub Actions and the unpublished remote package have not been run.
