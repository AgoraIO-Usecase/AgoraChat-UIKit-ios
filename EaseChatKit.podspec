Pod::Spec.new do |s|
    s.name             = 'EaseChatKit'
    s.version          = '3.8.7'
    s.summary = 'agora im sdk UIKit'
    s.homepage = 'http://docs-im.easemob.com/im/ios/other/easechatkit'
    s.description = <<-DESC
                    EaseChatKit Supported features:

                    1. Conversation list
                    2. Chat page (singleChat,groupChat,chatRoom)
                    3. Contact list
                  DESC
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'agora' => 'dev@agora.com' }
    #s.source = { :git => 'https://github.com/easemob/easeui_ios.git', :tag => 'EaseChatKit_3.8.7'}
    s.source = { :git => 'https://github.com/MThrone/EaseChatKit.git', :tag => 'EaseChatKit_1.1.0'}
    s.frameworks = 'UIKit'
    s.libraries = 'stdc++'
    s.ios.deployment_target = '10.0'
    s.source_files = [
        'EaseChatKit/EaseChatKit.h',
        'EaseChatKit/EasePublicHeaders.h',
        'EaseChatKit/**/*.{h,m,mm}'
    ]
    s.public_header_files = [
        'EaseChatKit/EaseChatKit.h',
        'EaseChatKit/EasePublicHeaders.h',
        'EaseChatKit/Classes/EaseChatKitManager.h',
        'EaseChatKit/Classes/EaseChatEnums.h',
        'EaseChatKit/Classes/Common/EaseDefines.h',
        'EaseChatKit/Classes/BaseTableViewController/EaseBaseTableViewModel.h',
        'EaseChatKit/Classes/Conversations/Views/EaseConversationCell.h',
        'EaseChatKit/Classes/Conversations/Models/EaseConversationViewModel.h',
        'EaseChatKit/Classes/Conversations/Models/EaseConversationModel.h',
        'EaseChatKit/Classes/Conversations/Controllers/EaseConversationsViewController.h',
        
        'EaseChatKit/Classes/Chat/EaseChatViewController.h',
        'EaseChatKit/Classes/Chat/EaseChatViewControllerDelegate.h',
        'EaseChatKit/Classes/Chat/InputMenu/EaseInputMenu.h',
        'EaseChatKit/Classes/Chat/ChatModels/EaseExtendMenuViewModel.h',
        'EaseChatKit/Classes/Chat/ChatModels/EaseExtendMenuModel.h',
        'EaseChatKit/Classes/Chat/ChatModels/EaseMessageModel.h',
        'EaseChatKit/Classes/Chat/ChatModels/EaseChatViewModel.h',
        'EaseChatKit/Classes/Chat/MessageCell/EaseMessageCell.h',
        'EaseChatKit/Classes/Chat/MessageCell/EaseMessageCell+Category.h',
        'EaseChatKit/Classes/Chat/MessageCell/BubbleView/EaseChatMessageBubbleView.h',
        'EaseChatKit/Classes/Chat/InputMenu/ChatEmojiUtil/Emoticon/EaseInputMenuEmoticonView.h',
        'EaseChatKit/Classes/Chat/InputMenu/ChatEmojiUtil/EaseEmoticon.h',
        'EaseChatKit/Classes/Chat/InputMenu/MoreView/AudioRecord/EaseInputMenuRecordAudioView.h',
        'EaseChatKit/Classes/Chat/InputMenu/MoreView/MoreFunction/EaseExtendMenuView.h',
        
        'EaseChatKit/Classes/BaseTableViewController/EaseBaseTableViewModel.h',
        'EaseChatKit/Classes/BaseTableviewController/EaseUserProfile.h',
        'EaseChatKit/Classes/BaseTableViewController/EaseBaseTableViewController.h'
    ]
    
    s.static_framework = true
    s.resource = 'EaseChatKit/Resources/EaseChatKit.bundle'
    #s.resources = ['Images/*.png', 'Sounds/*']
    
    #s.ios.resource_bundle = { 'EaseChatKit' => 'EaseChatKit/Assets/*.png' }
    #s.resource_bundles = {
     # 'EaseChatKit' => ['EaseChatKit/Assets/*.png']
    #}
    s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
                              'VALID_ARCHS' => 'arm64 armv7 x86_64'
                            }
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

    s.dependency 'AgoraChat'
    s.dependency 'EMVoiceConvert', '0.1.0'

end
