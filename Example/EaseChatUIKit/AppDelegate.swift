//
//  AppDelegate.swift
//  EaseChatUIKit
//
//  Created by zjc19891106 on 11/01/2023.
//  Copyright (c) 2023 zjc19891106. All rights reserved.
//

import UIKit
import chat_uikit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // You can initialize chat_uikit when your app loads or before your app is ready to use。
        // Pass in the app key.
        // Get the app key by reference to the following URL:
        // https://docs.agora.io/en/agora-chat/get-started/enable#get-chat-project-information
        let option = ChatOptions(appkey: ExampleRequiredConfig.appKey)
        option.enableConsoleLog = true
        option.isAutoLogin = false
        _ = EaseChatUIKitClient.shared.setup(option: option)
        self.setupEaseChatUIKitConfig()
        return true
    }
    
    private func setupEaseChatUIKitConfig() {
        //Set the theme of the chat demo UI.
        Appearance.avatarRadius = .large
        Appearance.chat.inputBarCorner = .large
        Appearance.alertStyle = .large
        Appearance.chat.bubbleStyle = .withMultiCorner
        
        Appearance.chat.enableTyping = true
        
        Appearance.ease_chat_language = .English
        //Whether show message topic or not.
//        Appearance.chat.contentStyle.append(.withMessageThread)
        //Whether show message reaction or not.
//        Appearance.chat.contentStyle.append(.withMessageReaction)
        //Notice: - Feature identify can't changed, it's used to identify feature action.
        
        //Register custom components
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

