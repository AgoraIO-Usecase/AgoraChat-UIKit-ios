# chat_uikit for iOS

This guide gives a comprehensive overview into chat_uikit (V2.0.0). The new chat_uikit is intended to provide developers with an efficient, plug-and-play, and highly customizable UI component library, helping you build complete and elegant IM applications that can easily satisfy most instant messaging scenarios. Please download the demo to try it out.

# Demo

In this project, there is a best-practice demonstration project in the `Example` folder for you to build your own business capabilities.

If you want to experience the functions of chat_uikit, you can scan the following QR code to try the demo.

![Demo](./Documentation/demo.png)

# chat_uikit Guide

## Introduction

This guide provides an overview and usage examples of the chat_uikit framework in iOS development, and presents various components and functions of this UIKit, giving developers a good understanding of how chat_uikit works and how to use it efficiently.

## Table of contents

- [Development Environment](#development-environment)
- [Installation](#installation)
- [Structure](#structure)
- [Quick Start](#quick-start)
- [Advance Usage](#advanced-usage)
- [Customize](#customize)
- [Theme](#theme)
- [Design Guide](#design-guide)
- [Documentation](#documentation)
- [Contribution](#contribution)
- [LICENSE](#license)

# Development Environment

- Xcode 15.0 or later. The reason is that the audio detection AVAudioApplication API is used in UIKit to adapt to iOS 17 and later. 
- Minimum system version: iOS 13.0
- A valid developer signature for your project

# Installation

You can install chat_uikit using CocoaPods as a dependency of your Xcode project.

## CocoaPods

Add the following dependencies to `podfile`.

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'

target 'YourTarget' do
  use_frameworks!

  pod 'chat_uikit'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end
```

Then run the `cd` command on the terminal to navigate to the folder where `podfile` is located:

```
    pod install
```

>⚠️If the compilation error `Sandbox: rsync.samba(47334) deny(1) file-write-create...` is reported in Xcode15, you can: 

> Search for `ENABLE_USER_SCRIPT_SANDBOXING` in **Build Setting** and change `User Script Sandboxing` to `NO`.


# Structure

### Basic project structure of chat_uikit

```
Classes
├─ Service // Basic service component.
│ ├─ Client // APIs relating to initialization, login, and caching.
│ ├─ Protocol // Business protocol.
│ │ ├─ ConversationService // Conversation protocol: including various processing operations on the conversation.
│ │ ├─ ContactService // Contact protocol: including subsequent contact addition and deletion operations.
│ │ ├─ ChatService // Chat protocol: including various processing operations on messages.
│ │ ├─ UserService // User login protocol: including user login and socket connection status changes.
│ │ ├─ MultiService // Multi-device notification protocol: including one-to-one chat, group chat, conversation, contact, and member changes.
│ │ └─ GroupService // Group chat management protocol: including joining and leaving the group and editing group information.
│ └─ Implement // Components implementing the above protocols.
│
└─ UI // Basic UI components without business.
├─ Resource // Images or localization files.
├─ Component // UI modules containing specific business, specifically some functional UI components.
│ ├─ Chat // Container for all chat views.
│ ├─ Contact // Container for contacts, groups and their details.
│ └─ Conversation // Conversation list container.
└─ Core
├─ UIKit // Some common UIKit components, custom components, and some UI-related tool classes.
├─ Foundation // Logs and some audio conversion tool classes.
├─ Theme // Theme-related components, including colors, fonts, skinning protocols and their components.
└─ Extension // Some convenient system class extensions.
```

# Quick Start

Take the following steps to create an iOS app in Xcode:

* Fill in `chat_uikitQuickStart` for **Product Name**.

* Set **Organization Identifier** to your identifier.

* Select **Storyboard** for **User Interface**.

* Select your favorite development language for **Language**.

* Add permissions:
  
  Add relevant permissions in `info.plist` of the project:

```
Privacy - Photo Library Usage Description //Album privileges.
Privacy - Microphone Usage Description //Microphone privileges.
Privacy - Camera Usage Description //Camera privileges.
```

### 1. Initialize chat_uikit

```Swift
import chat_uikit

@UIApplicationMain
class AppDelegate：UIResponder，UIApplicationDelegate {

     var window：UIWindow？

     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
         // You can initialize chat_uikit when your app loads or before your app is ready to use。
         // Pass in the app key.
         // Get the app key by reference to the following URL: 
         // https://docs.agora.io/en/agora-chat/get-started/enable#get-chat-project-information
         let error = EaseChatUIKitClient.shared.setup(appKey: "Appkey")
     }
}
```

### 2. Login

``` Swift
public final class YourAppUser: NSObject, EaseProfileProtocol {

    var id: String = ""
    
    var remark: String = ""
    
    var selected: Bool = false
    
    var nickname: String = ""
    
    var avatarURL: String = ""
    
    public func toJsonObject() -> Dictionary<String, Any>? {
        ["ease_chat_uikit_user_info":["nickname":self.nickname,"avatarURL":self.avatarURL,"userId":self.id]]
    }

}
// Use the user information of the current user object that conforms to the `EaseProfileProtocol` protocol to log in to chat_uikit.
// For token generation, refer to the URL: https://docs.agora.io/en/agora-chat/get-started/enable?platform=ios#generate-a-user-token
// You can obtain a token from your application server or use a temporary token generated by the Agora Console.
// To generate a user and a temporary user token on the Agora Console, refer to to the following URL:
// https://docs.agora.io/en/agora-chat/get-started/enable?platform=ios#register-a-user
  EaseChatUIKitClient.shared.login(user: YourAppUser(), token: ExampleRequiredConfig.chatToken) { error in 
 }
```

### 3. Create chat view controller

```Swift
        // Create a new user on the Agora Console, copy the user ID and pass it to the following constructor parameter to jump to the page.
        let vc = ComponentsRegister.shared.MessageViewController.init(conversationId: <#user id#>, chatType: .chat)
        //push or present
        vc.modalPresentationStyle = .fullScreen
        ControllerStack.toDestination(vc: vc)

```

# Advanced Usage

Following are some examples of advanced usage. The conversation list page, message list page, and contact list page can be used separately.

## 1. Initialize chat_uikit

Compared with UIKit initialization in the quick start above, `ChatOptions` parameters are added here, including whether to print SDK logs, whether to enable automatic login, and whether to use user attributes by default. `ChatOptions` refers to the `AgoraChatOptions` class of the Agora Chat SDK, which contains many switch properties. 

```Swift
let error = EaseChatUIKitClient.shared.setup(option: ChatOptions(appkey: appKey))
```

## 2. Login

```Swift
public final class YourAppUser: NSObject, EaseProfileProtocol {

            public func toJsonObject() -> Dictionary<String, Any>? {
        ["ease_chat_uikit_user_info":["nickname":self.nickname,"avatarURL":self.avatarURL,"userId":self.id]]
    }
    
    
    public var id: String = ""
        
    public var nickname: String = ""
        
    public var selected: Bool = false
    
    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

    public var avatarURL: String = "https://accktvpic.oss-cn-beijing.aliyuncs.com/pic/sample_avatar/sample_avatar_1.png"

}
// Use the user information of the current user object that conforms to the `EaseProfileProtocol` protocol to log in to chat_uikit.
// For token generation, refer to the URL: https://docs.agora.io/en/agora-chat/get-started/enable?platform=ios#generate-a-user-token
 EaseChatUIKitClient.shared.login(user: YourAppUser(), token: ExampleRequiredConfig.chatToken) { error in 
 }
```

## 3. Provider of the EaseChatUIKitContext

**Note: The provider is used only for the conversation list and contact list. Provider is not required when you run the Quick Start sample project to enter the chat page.**

Provider is a data provider. When the conversation list is displayed and the sliding is slowed down, chat_uikit will request you to provide the conversation information to be displayed on the current screen, such as the avatar and nickname. The following is a specific example and usage of Provider.

```Swift
    private func setupDataProvider() {
        //userProfileProvider is the provider of user data. The provider implemented via a coroutine cannot co-exist with userProfileProviderOC. userProfileProviderOC is implemented via a closure.
        EaseChatUIKitContext.shared?.userProfileProvider = self
        EaseChatUIKitContext.shared?.userProfileProviderOC = nil
        //groupProvider
        EaseChatUIKitContext.shared?.groupProfileProvider = self
        EaseChatUIKitContext.shared?.groupProfileProviderOC = nil
    }

//MARK: - EaseProfileProvider for conversations&contacts usage.
//For example, use conversations controller as follows:
extension MainViewController: EaseProfileProvider,EaseGroupProfileProvider {
    //MARK: - EaseProfileProvider
    func fetchProfiles(profileIds: [String]) async -> [any chat_uikit.EaseProfileProtocol] {
        return await withTaskGroup(of: [chat_uikit.EaseProfileProtocol].self, returning: [chat_uikit.EaseProfileProtocol].self) { group in
            var resultProfiles: [chat_uikit.EaseProfileProtocol] = []
            group.addTask {
                var resultProfiles: [chat_uikit.EaseProfileProtocol] = []
                let result = await self.requestUserInfos(profileIds: profileIds)
                if let infos = result {
                    resultProfiles.append(contentsOf: infos)
                }
                return resultProfiles
            }
            //Await alls tasks are executed. Return values.
            for await result in group {
                resultProfiles.append(contentsOf: result)
            }
            return resultProfiles
        }
    }
    //MARK: - EaseGroupProfileProvider
    func fetchGroupProfiles(profileIds: [String]) async -> [any chat_uikit.EaseProfileProtocol] {
        
        return await withTaskGroup(of: [chat_uikit.EaseProfileProtocol].self, returning: [chat_uikit.EaseProfileProtocol].self) { group in
            var resultProfiles: [chat_uikit.EaseProfileProtocol] = []
            group.addTask {
                var resultProfiles: [chat_uikit.EaseProfileProtocol] = []
                let result = await self.requestGroupsInfo(groupIds: profileIds)
                if let infos = result {
                    resultProfiles.append(contentsOf: infos)
                }
                return resultProfiles
            }
            //Await all task are executed.Return values.
            for await result in group {
                resultProfiles.append(contentsOf: result)
            }
            return resultProfiles
        }
    }
    
    private func requestUserInfos(profileIds: [String]) async -> [EaseProfileProtocol]? {
        var unknownIds = [String]()
        var resultProfiles = [EaseProfileProtocol]()
        for profileId in profileIds {
            if let profile = chat_uikitContext.shared?.userCache?[profileId] {
                if profile.nickname.isEmpty {
                    unknownIds.append(profile.id)
                } else {
                    resultProfiles.append(profile)
                }
            } else {
                unknownIds.append(profileId)
            }
        }
        if unknownIds.isEmpty {
            return resultProfiles
        }
        let result = await ChatClient.shared().userInfoManager?.fetchUserInfo(byId: unknownIds)
        if result?.1 == nil,let infoMap = result?.0 {
            for (userId,info) in infoMap {
                let profile = EaseChatProfile()
                let nickname = info.nickname ?? ""
                profile.id = userId
                profile.nickname = nickname
                if let remark = ChatClient.shared().contactManager?.getContact(userId)?.remark {
                    profile.remark = remark
                }
                profile.avatarURL = info.avatarUrl ?? ""
                resultProfiles.append(profile)
                if (chat_uikitContext.shared?.userCache?[userId]) != nil {
                    profile.updateFFDB()
                } else {
                    profile.insert()
                }
                chat_uikitContext.shared?.userCache?[userId] = profile
            }
            return resultProfiles
        }
        return []
    }
    
    private func requestGroupsInfo(groupIds: [String]) async -> [EaseProfileProtocol]? {
        var resultProfiles = [EaseProfileProtocol]()
        let groups = ChatClient.shared().groupManager?.getJoinedGroups() ?? []
        for groupId in groupIds {
            if let group = groups.first(where: { $0.groupId == groupId }) {
                let profile = EaseChatProfile()
                profile.id = groupId
                profile.nickname = group.groupName
                profile.avatarURL = group.settings.ext
                resultProfiles.append(profile)
                chat_uikitContext.shared?.groupCache?[groupId] = profile
            }

        }
        return resultProfiles
    }
}
```

## 4. Create chat view controller

Most of the message processing and page processing logics in the chat page can be overridden, including ViewModel.

```Swift
        // Create a new user on the Agora Console, copy the user ID and pass it into the following constructor parameter to jump to the page.
        let vc = ComponentsRegister.shared.MessageViewController.init(conversationId: <#ID of user#>, chatType: .chat)
        //push or present
        vc.modalPresentationStyle = .fullScreen
        ControllerStack.toDestination(vc: vc)
```

## 5. Create conversation view controller

```Swift
        let vc = ConversationListController()
        vc.modalPresentationStyle = .fullScreen
        ControllerStack.toDestination(vc: vc)
```

## 6. Create contact view controller

```Swift
        let vc = ContactViewController()
        vc.modalPresentationStyle = .fullScreen
        ControllerStack.toDestination(vc: vc)
```

## 7. Listen for chat_uikit events and errors

You can call the `registerUserStateListener` method to listen for events and errors concerning users and link state changes in chat_uikit.

```Swift
EaseChatUIKitClient.shared.unregisterUserStateListener(self)
```

# Customization

## 1. Modify configuration items

The following example shows how to change the message content display.

```Swift
        // You can display or hide a message style by adding or removing the items in the content display array.
        Appearance.chat.contentStyle = [.withReply,.withAvatar,.withNickName,.withDateAndTime]
        let vc = ComponentsRegister.shared.MessageViewController.init(conversationId: <#ID of user#>, chatType: .chat)
        vc.modalPresentationStyle = .fullScreen
        ControllerStack.toDestination(vc: vc)
```

For more information, see [Appearance](./Documentation/Appearance.md)。

## 2.Customize UI Components

- The following shows how to customize the location message cell.

```Swift
class CustomLocationMessageCell: LocationMessageCell {
    //Create and return the view you want to display, and the bubble will wrap your view
    @objc open override func createContent() -> UIView {
        UIView(frame: .zero).backgroundColor(.clear).tag(bubbleTag)
    }
}
//Register a custom class that inherits the original class in chat_uikit to replace the original class.
//Call this method before creating a message page or using other UI components.
ComponentsRegister.shared.ChatLocationCell = CustomLocationMessageCell.self
```

- The following shows how to register a custom message type and a message style by inheriting original ones. 
  
```Swift
    ComponentsRegister.shared.registerCustomizeCellClass(cellType: YourMessageCell.self)
    class YourMessageCell: MessageCell {
        override func createAvatar() -> ImageView {
            ImageView(frame: .zero)
        }
    }
```

For more information, see [ComponentsRegister](./Documentation/ComponentsRegister.md).

## 3. Intercept the original component click event

**Note: After interception, all business related to the original click event are handled by the user.**

```Swift
        
        ComponentViewsActionHooker.shared.conversation.longPressed = { [weak self] indexPath,info in 
            //Process you business logic.
        }

```

# Theme

- Switch to the light or dark theme coming with chat_uikit. Switching the theme before initializing the UIKit view can change the default theme. When using the view, you can also switch the theme according to the system theme.
  
```swift
Theme.switchTheme(style: .dark)
// or
Theme.switchTheme(style: .light)
```

- Switch to a custom theme.

```swift
/**
How to customize a theme?

To customize a theme, you need to define the hue values of the following five theme colors by reference to the theme color of the design document.

All colors in chat_uikit are defined with the HSLA color model that is a way of representing colors using hue, saturation, lightness, and alpha. 

H (Hue): Hue, the basic attribute of color, is a degree on the color wheel from 0 to 360. 0 is red, 120 is green, and 240 is blue.

S (Saturation): Saturation is the intensity and purity of a color. The higher the saturation is, the brighter the color is; the lower the saturation is, the closer the color gets to gray. Saturation is represented by a percentage value, ranging from 0% to 100%. 0% means a shade of gray, and 100% is the full color.

L (Lightness): Lightness is the brightness or darkness of a color. The higher the brightness is, the brighter the color is; the lower the brightness is, the darker the color is. Lightness is represented by a percentage value, ranging from 0% to 100%. 0% indicates a black color and 100% will result in a white color.

A (Alpha): Alpha is the transparency of a color. The value 1 means fully opaque and 0 is fully transparent.

By adjusting the values of individual components of the HSLA model, you can achieve precise color control.
  */
Appearance.primaryHue = 191/360.0
Appearance.secondaryHue = 210/360.0
Appearance.errorHue = 189/360.0
Appearance.neutralHue = 191/360.0
Appearance.neutralSpecialHue = 199/360.0
Theme.switchTheme(style: .custom)
```

# Documentation

## [Documentation](/Documentation/chat_uikit.doccarchive)

You can open the `chat_uikit.doccarchive` file in Xcode to view files in it. 

Also, you can right-click the file to show the package contents and copy all files inside to a folder. Then drag this folder to the `terminal` app and run the following command to deploy it on the local IP address.

```bash
python3 -m http.server 8080
```

After deployment, you can visit `http://yourlocalhost:8080/documentation/chat_uikit` in your browser, where `yourlocalhost` is your local IP address. Alternatively, you can deploy this folder on an external network address.

## 1. Appearance 

[Appearance](./Documentation/Appearance.md). 

All configuration items that can be modified before loading the UI, which include public configurations and three types of business function configurations:
- Public configuration: including the hue value configuration of custom skins and default avatars. 
- Conversation list: including menu items shown after sliding the conversation, and menu item configurations shown after clicking the '+' button in the conversation list.
- Contacts: including configuration items such as contact page and header.
- Chat page: including configurable menu items such as message long press and sending attachment messages via the keyboard, as well as the bubble color and font color of the message sender and recipient.

## 2. ComponentRegister 

[ComponentRegister](./Documentation/ComponentsRegister.md). 

UI components that you can inherit for customization.

Includes pages related to the conversation list and UITableViewCell, contact pages and UITableViewCell, chat pages, and customizable components for different types of message content.

## 3. ComponentViewsActionHooker

[ComponentViewsActionHooker](./Documentation/ComponentsActionEventsRegister.md). All interceptable click events.

## 4. Intercept click and jump events on main pages 

[More](./Documentation/customize_click_jump.md).

## 5. Intercept callback event listeners on main pages 

[More](./Documentation/modular_events_listener.md).

# Design Guide

For any questions about design guidelines and details, you can add comments to the Figma design draft and mention our designer Stevie Jiang.

[UI](https://www.figma.com/community/file/1327193019424263350/chat-uikit-for-mobile)。
[Guide of UI Design](https://github.com/StevieJiang/Chat-UIkit-Design-Guide/blob/main/README.md)

# Contribution

Contributions and feedback are welcome! For any issues or improvement suggestions, you can open an issue or submit a pull request.

## Author

zjc19891106, [984065974@qq.com](mailto:984065974@qq.com)

## LICENSE

chat_uikit is available under the MIT License. See the LICENSE file for details.
