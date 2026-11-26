Pod::Spec.new do |s|
s.name             = 'chat-uikit'
s.version          = '2.2.0'
s.summary = 'agora im UIKit'
s.homepage = 'https://github.com/AgoraIO-Usecase/AgoraChat-UIKit-ios'
s.description = <<-DESC
chat-uikit new version
DESC
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'agora' => 'dev@agora.com' }
s.source = { :git => 'https://github.com/AgoraIO-Usecase/AgoraChat-UIKit-ios.git', :tag => s.version.to_s}
s.ios.deployment_target = '15.0'



s.source_files = [ 'Sources/EaseChatUIKit/Classes/**/*.swift', 'Sources/EaseChatUIKit/Classes/UI/Core/Foundation/chat-uikit-Bridge.h' ]
s.resources = ['Sources/EaseChatUIKit/Classes/UI/**/*.bundle','Sources/EaseChatUIKit/Classes/UI/**/*.xcprivacy']
s.dependency 'Agora_Chat_iOS', '5.2.0'
s.dependency 'FLAnimatedImage', '~> 1.0'
s.static_framework = true

s.swift_version = '5.0'
s.prefix_header_contents = '
# if __has_include (<chat-uikit/chat-uikit-Bridge.h>)
#import <chat-uikit/chat-uikit-Bridge.h>
# else
#import "chat-uikit-Bridge.h"
# endif
'
s.public_header_files = 'Sources/EaseChatUIKit/Classes/UI/Core/Foundation/chat-uikit-Bridge.h'

s.vendored_frameworks = 'Sources/EaseChatUIKit/Classes/UI/Core/Foundation/third-party/AMRCodec.xcframework'
s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }

s.frameworks = 'UIKit', 'Foundation', 'Combine', 'AudioToolbox', 'AVFoundation','AVFAudio','Photos'


s.app_spec 'TestHost' do |app|
  app.source_files = 'Tests/HostApp/*.swift'
  app.resources = 'Tests/AgoraChatUIKitTests/HostResources/**/*'
  app.info_plist = { 'UILaunchScreen' => {} }
end
s.test_spec 'IntegrationTests' do |test|
  test.source_files = 'Tests/AgoraChatUIKitTests/*.swift'
  test.dependency 'chat-uikit/TestHost'
  test.requires_app_host = true
  test.app_host_name = 'chat-uikit/TestHost'
end
end
