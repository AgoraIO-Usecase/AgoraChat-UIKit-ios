#!/usr/bin/env bash
# Run from the repository root. All outputs go to a dedicated temporary directory.
set -euo pipefail
integration="${1:-spm}"
output="${CI_OUTPUT_DIR:-${RUNNER_TEMP:-${TMPDIR:-/tmp}}/AgoraChatUIKit-${integration}}"
mkdir -p "$output"
exec > >(tee "$output/integration.log") 2>&1
xcodebuild -version
simulator_id="${CI_SIMULATOR_ID:-$(python3 scripts/select_ios_simulator.py)}"
derived="$output/DerivedData"
if [[ "$integration" == "spm" ]]; then
  project=(-project ExampleSPM/AgoraChatUIKitSPMExample.xcodeproj)
  test_scheme=AgoraChatUIKitSPMExample
  archive_scheme=AgoraChatUIKitSPMExample
elif [[ "$integration" == "pods" ]]; then
  (cd Example && pod install)
  project=(-workspace Example/EaseChatUIKit.xcworkspace)
  test_scheme=chat-uikit-Unit-IntegrationTests
  archive_scheme=EaseChatUIKit_Example
else
  echo "Usage: $0 spm|pods" >&2
  exit 2
fi
xcodebuild test "${project[@]}" -scheme "$test_scheme" \
  -destination "platform=iOS Simulator,id=$simulator_id" \
  -derivedDataPath "$derived" -resultBundlePath "$output/Tests.xcresult" \
  -parallel-testing-enabled NO CODE_SIGNING_ALLOWED=NO
if [[ "$integration" == "spm" ]]; then
  python3 scripts/verify_integration_artifacts.py \
    "$derived/Build/Products/Debug-iphonesimulator/AgoraChatUIKitSPMExample.app"
fi
xcodebuild archive "${project[@]}" -scheme "$archive_scheme" \
  -destination 'generic/platform=iOS' -configuration Release \
  -derivedDataPath "$derived" -archivePath "$output/Example.xcarchive" \
  -disableAutomaticPackageResolution CODE_SIGNING_ALLOWED=NO
python3 scripts/verify_integration_artifacts.py "$output/Example.xcarchive"
