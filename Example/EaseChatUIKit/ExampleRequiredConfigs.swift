//
//  ExampleRequiredConfigs.swift
//  EaseChatUIKit_Example
//
//  Created by 朱继超 on 2024/9/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import chat_uikit

/*
Quick Start required configuration
 **/
public class ExampleRequiredConfig {
    // You can initialize chat_uikit when your app loads or before your app is ready to use。
    // Pass in the app key.
    // Get the app key by reference to the following URL:
    // https://docs.agora.io/en/agora-chat/get-started/enable#get-chat-project-information
    static let appKey: String = <#App Key#>
    
    // Use the user information of the current user object that conforms to the `EaseProfileProtocol` protocol to log in to chat_uikit.
    // For token generation, refer to the URL: https://docs.agora.io/en/agora-chat/get-started/enable?platform=ios#generate-a-user-token
    static var chatToken: String = <#chat token#>
    
    /// ``YourAppUser`` can be regarded as the user class in your App.
    public final class YourAppUser: NSObject, ChatUserProfileProtocol {
        
        /// Created user id.
        public var id: String = <#user id#>
        
        public var remark: String = ""
        
        public var selected: Bool = false
        
        public var nickname: String = "tester001"
        
        public var avatarURL: String = "https://accktvpic.oss-cn-beijing.aliyuncs.com/pic/sample_avatar/sample_avatar_1.png"
        
        public func toJsonObject() -> Dictionary<String, Any>? {
            ["ease_chat_uikit_user_info":["nickname":self.nickname,"avatarURL":self.avatarURL,"userId":self.id]]
        }

    }
}
