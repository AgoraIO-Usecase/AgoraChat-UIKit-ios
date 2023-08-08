Pod::Spec.new do |s|
    s.name             = 'chat-uikit'
    s.version          = '1.1.0'
    s.summary = 'agora im UIKit'
    s.homepage = 'https://github.com/AgoraIO-Usecase/AgoraChat-UIKit-ios'
    s.description = <<-DESC
                    chat-uikit Supported features:

                    1. Conversation list
                    2. Chat page (singleChat,groupChat,chatRoom)
                  DESC
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'agora' => 'dev@agora.com' }
    s.source = { :git => 'https://github.com/AgoraIO-Usecase/AgoraChat-UIKit-ios.git', :tag => 'chat-uikit_1.1.0'}
    s.frameworks = 'UIKit'
    s.libraries = 'stdc++'
    s.ios.deployment_target = '11.0'
    s.source_files = [
        'chat-uikit/EaseChatKit.h',
        'chat-uikit/EasePublicHeaders.h',
        'chat-uikit/**/*.{h,m,mm}'
    ]
    s.public_header_files = [
        'chat-uikit/EaseChatKit.h',
        'chat-uikit/EasePublicHeaders.h',
        'chat-uikit/Classes/EaseChatKitManager.h',
        'chat-uikit/Classes/EaseChatEnums.h',
        'chat-uikit/Classes/Common/EaseDefines.h',
        'chat-uikit/Classes/BaseTableViewController/EaseBaseTableViewModel.h',
        'chat-uikit/Classes/Conversations/Views/EaseConversationCell.h',
        'chat-uikit/Classes/Conversations/Models/EaseConversationViewModel.h',
        'chat-uikit/Classes/Conversations/Models/EaseConversationAvatarParam.h',
        'chat-uikit/Classes/Conversations/Models/EaseConversationModel.h',
        'chat-uikit/Classes/Conversations/Controllers/EaseConversationsViewController.h',
        
        'chat-uikit/Classes/Chat/EaseChatViewController.h',
        'chat-uikit/Classes/Chat/EaseChatViewControllerDelegate.h',
        'chat-uikit/Classes/Chat/InputMenu/EaseInputMenu.h',
        'chat-uikit/Classes/Chat/ChatModels/EaseExtendMenuViewModel.h',
        'chat-uikit/Classes/Chat/ChatModels/EaseExtendMenuModel.h',
        'chat-uikit/Classes/Chat/ChatModels/EaseMessageModel.h',
        'chat-uikit/Classes/Chat/InputMenu/ChatEmojiUtil/EaseEmojiHelper.h',
        'chat-uikit/Classes/Chat/ChatModels/EaseChatViewModel.h',
        'chat-uikit/Classes/Chat/MessageCell/EaseMessageCell.h',
        'chat-uikit/Classes/Chat/MessageCell/EaseMessageCell+Category.h',
        'chat-uikit/Classes/Chat/MessageCell/BubbleView/EaseChatMessageBubbleView.h',
        'chat-uikit/Classes/Chat/MessageCell/Forward/ForwardList.h',
        'chat-uikit/Classes/Chat/ChatComponents/ForwardMessagesController/ForwardMessagesViewController.h',        'chat-uikit/Classes/Chat/InputMenu/ChatEmojiUtil/Emoticon/EaseInputMenuEmoticonView.h',
        'chat-uikit/Classes/Chat/InputMenu/ChatEmojiUtil/EaseEmoticon.h',
        'chat-uikit/Classes/Chat/InputMenu/MoreView/AudioRecord/EaseInputMenuRecordAudioView.h',
        'chat-uikit/Classes/Chat/InputMenu/MoreView/MoreFunction/EaseExtendMenuView.h',
        
        'chat-uikit/Classes/BaseTableViewController/EaseBaseTableViewModel.h',
        'chat-uikit/Classes/BaseTableviewController/EaseUserProfile.h',
        'chat-uikit/Classes/BaseTableViewController/EaseBaseTableViewController.h',
        
        'chat-uikit/Classes/Chat/LiveStream/EaseChatView.h',
        'chat-uikit/Classes/Chat/LiveStream/EaseCustomMessageHelper.h',
        'chat-uikit/Classes/Chat/LiveStream/EaseChatViewCustomOption.h',
        'chat-uikit/Classes/Chat/LiveStream/UserInfo/EaseUserInfoManagerHelper.h',
        'chat-uikit/Classes/BaseTableViewController/EaseBaseTableViewController.h',
        'chat-uikit/Classes/Chat/ChatComponents/ThreadChatController/EaseThreadCreateViewController.h',
        'chat-uikit/Classes/Chat/ChatComponents/ThreadChatController/EaseThreadListViewController.h',
        'chat-uikit/Classes/Chat/ChatComponents/ThreadChatController/EaseThreadChatViewController.h',
        'chat-uikit/Classes/Chat/ChatComponents/ThreadChatController/EaseThreadChatHeader.h',
        'chat-uikit/Classes/Chat/ChatModels/EaseThreadConversation.h',
        'chat-uikit/Classes/Chat/InputMenu/MoreView/MoreFunction/EMBottomMoreFunctionView.h',
        'chat-uikit/Classes/Chat/MessageCell/EaseThreadCell.h',
        'chat-uikit/Classes/Chat/MessageCell/EaseThreadCreateCell.h',
    ]
    
    s.static_framework = true
    s.resources = ['chat-uikit/**/*.bundle','chat-uikit/**/*.xib']
    s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
                              'VALID_ARCHS' => 'arm64 armv7 x86_64',
                              'CLANG_WARN_DOCUMENTATION_COMMENTS' => 'NO'
                            }
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

    s.dependency 'Agora_Chat_iOS', '>= 1.0.7'
    s.dependency 'EMVoiceConvert', '0.1.0'
    s.dependency 'MJRefresh'

end
