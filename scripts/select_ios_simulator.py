#!/usr/bin/env python3
"""Print an available iPhone UDID matching the active simulator SDK's major version."""
import json
import subprocess


def select_simulator():
    sdk_version = subprocess.check_output(
        ["xcrun", "--sdk", "iphonesimulator", "--show-sdk-version"], text=True
    ).strip()
    sdk_major = int(sdk_version.split(".")[0])
    devices = json.loads(subprocess.check_output(
        ["xcrun", "simctl", "list", "devices", "available", "--json"], text=True
    ))["devices"]
    runtimes = sorted(
        (
            runtime for runtime in devices
            if ".iOS-" in runtime
            and int(runtime.split(".iOS-")[1].split("-")[0]) == sdk_major
        ),
        key=lambda runtime: tuple(map(int, runtime.split(".iOS-")[1].split("-"))),
        reverse=True,
    )
    for runtime in runtimes:
        for device in devices[runtime]:
            if device["isAvailable"] and device["name"].startswith("iPhone"):
                return device["udid"]
    # Minor runtime updates can work with the same SDK major (for example,
    # iOS 26.2 with Xcode 26.0.1), so do not require an exact minor match.
    raise SystemExit(
        f"No available iPhone simulator for iOS {sdk_major}.x "
        f"(active SDK {sdk_version}); install a matching runtime in Xcode"
    )


if __name__ == "__main__":
    print(select_simulator())
