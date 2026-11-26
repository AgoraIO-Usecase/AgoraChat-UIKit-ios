// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "AgoraChatUIKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "AgoraChatUIKit", targets: ["chat_uikit"])
    ],
    dependencies: [
        .package(url: "https://github.com/AgoraIO/AgoraInfra_iOS.git", exact: "1.3.16"),
        .package(url: "https://github.com/Flipboard/FLAnimatedImage.git", from: "1.0.16")
    ],
    targets: [
        .target(
            name: "chat_uikit",
            dependencies: [
                "AgoraChat",
                .product(name: "AgoraInfra_iOS", package: "AgoraInfra_iOS"),
                .product(name: "FLAnimatedImage", package: "FLAnimatedImage"),
                "AMRCodec"
            ],
            path: "Sources/EaseChatUIKit/Classes",
            exclude: [
                "UI/Core/Foundation/EaseChatUIKit-Bridge.h",
                "UI/Core/Foundation/chat-uikit-Bridge.h",
                "UI/Core/Foundation/third-party",
                "UI/Core/UIKit/FrameWorks/VoiceConvert.m"
            ],
            resources: [
                // Keep the existing bundle layout, including localized strings and image scales.
                .copy("UI/Resources/EaseChatResource.bundle"),
                .process("UI/Resources/PrivacyInfo.xcprivacy")
            ],
            linkerSettings: [
                .linkedFramework("UIKit"),
                .linkedFramework("Foundation"),
                .linkedFramework("Combine"),
                .linkedFramework("AudioToolbox"),
                .linkedFramework("AVFoundation"),
                .linkedFramework("AVFAudio"),
                .linkedFramework("Photos")
            ]
        ),
        .binaryTarget(name: "AgoraChat", path: "Vendor/AgoraChat.xcframework"),
        .binaryTarget(
            name: "AMRCodec",
            path: "Sources/EaseChatUIKit/Classes/UI/Core/Foundation/third-party/AMRCodec.xcframework"
        ),
        .testTarget(
            name: "AgoraChatUIKitTests",
            dependencies: ["chat_uikit"],
            path: "Tests/AgoraChatUIKitTests",
            exclude: ["HostResources"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
