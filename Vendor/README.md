# AgoraChat SDK snapshot

`AgoraChat.xcframework` is copied without modification from the supplied
`AgoraSDK_2026-11-26-145753/AgoraChat.xcframework` (CFBundleShortVersionString 5.2.0).
It contains arm64 device and arm64/x86_64 simulator slices. Debug symbols from the
original delivery are not duplicated here. The original delivery is ignored by Git.

SPM uses this local binary target; CocoaPods uses `Agora_Chat_iOS.podspec` with a
`:path` dependency. Both integrations include the required AgoraInfra/aosl runtime.
The official https://github.com/AgoraIO/AgoraChat_iOS repository currently exposes
1.4.0, so it cannot replace this SDK 5 snapshot. Recheck before a future release.

This SDK remains subject to its vendor license; the UIKit MIT license does not
relicense the binary. Keep the binary in the distributed checkout until a matching,
verified official binary URL/version is available. Do not hand-edit its headers.
