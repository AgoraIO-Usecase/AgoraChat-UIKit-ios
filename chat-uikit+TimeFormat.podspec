Pod::Spec.new do |s|
    s.name             = 'chat-uikit+TimeFormat'
    s.version          = '1.1.1'
    s.summary = 'agora im UIKit'
    s.homepage = 'https://github.com/skylifeios/AgoraChat-UIKit-ios'
    s.description = <<-DESC
                    chat-uikit Supported features:

                    1. Conversation list
                    2. Chat page (singleChat,groupChat,chatRoom)
                  DESC
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Sky' => 'skylifewww@gmail.com' }
    s.source = { :git => 'https://github.com/skylifeios/AgoraChat-UIKit-ios.git', :tag => s.version }
    s.frameworks = 'UIKit'
    s.libraries = 'stdc++'
    s.ios.deployment_target = '11.0'
    s.source_files = 'Pod/Classes'
    s.resources = 'Pod/Assets/*'

  s.frameworks = 'UIKit', 'CoreText'
  s.module_name = 'Artsy_UIFonts'

    s.source_files = [
        'chat-uikit/EaseChatKit.h',
        'chat-uikit/EasePublicHeaders.h',
        'chat-uikit/**/*.{h,m,mm}'
    ]

end
