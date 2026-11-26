# Remote Swift Package validation

The planned AgoraChatUIKit Swift Package release is **2.0.0**. No revision containing this SDK migration has been published yet. This directory intentionally does not include a resolved remote project or claim that remote integration has passed.

After publishing the migration to the AgoraChat UIKit repository:

1. Copy `ExampleSPM` into a directory outside this checkout.
2. Replace its local package reference (`..`) in Xcode with the published AgoraChat UIKit Git URL and the `2.0.0` release tag after it exists (or an actual published commit for pre-release validation).
3. Select the `AgoraChatUIKit` product. Swift source imports remain `import chat_uikit`.
4. Copy `Tests/AgoraChatUIKitTests` alongside the standalone example and update the Shared Tests path if necessary. Keep HostResources assigned to the app target.
5. Run the `AgoraChatUIKitSPMExample` scheme on an iPhone simulator with parallel testing disabled, then create an unsigned Release archive for generic iOS.
6. Run `scripts/verify_integration_artifacts.py` from the matching published source checkout against the built app and archive. Record the actual Git URL, revision, Xcode version, test result and artifact verification output.

The package currently includes `Vendor/AgoraChat.xcframework` and resolves `AgoraInfra_iOS` 1.3.16 plus FLAnimatedImage. Do not replace the unpublished revision with an unrelated historical release. The local integration project in `ExampleSPM` is ready to validate the current checkout.

Release repository: the current fork `zjc19891106/AgoraChat-UIKit-ios` has no
`2.0.0` tag yet. The official `AgoraIO-Usecase/AgoraChat-UIKit-ios` already has a
historical `2.0.0` tag (`373b429f79109ede14b690e3024764e1e0610cdd`), which is
not this migration. Preserve that tag and validate against the actual new release
repository and revision.
