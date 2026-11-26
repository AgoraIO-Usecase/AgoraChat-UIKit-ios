//
//  UserServiceImplement.swift
//  ChatUIKit
//
//  Created by 朱继超 on 2023/8/30.
//

import UIKit

public var saveIdentifier: String {
    ChatClient.shared().options.appkey+(ChatUIKitContext.shared?.currentUserId ?? "")
}

@objc public final class UserServiceImplement: NSObject {
        
    private var responseDelegates: NSHashTable<UserStateChangedListener> = NSHashTable<UserStateChangedListener>.weakObjects()
    
    /// Init method
    /// - Parameters:
    ///   - userInfo: ``ChatUserProfileProtocol``
    ///   - token: Chat token
    ///   - completion: Callback,login successful or failure.
    @objc public init(userInfo: ChatUserProfileProtocol,token: String,completion: @escaping (ChatError?) -> Void) {
        super.init()
        self.registerEventListener()
        self.login(userId: userInfo.id.lowercased(), token: token) { success, error in
            if !success {
                let errorInfo = error?.errorDescription ?? ""
                consoleLogInfo(errorInfo, type: .error)
            }
            completion(error)
        }
    }
    
    @objc public override init() {
        super.init()
        self.registerEventListener()
    }
    
    @objc public func registerEventListener() {
        ChatClient.shared().add(self, delegateQueue: nil)
        if ChatClient.shared().options.enableUserInfo {
            ChatClient.shared().userInfoManager?.add(self, delegateQueue: nil)
        }
    }
    
    @objc public func removeEventListener() {
        ChatClient.shared().removeDelegate(self)
        ChatClient.shared().userInfoManager?.remove(self)
    }
    
    deinit {
        removeEventListener()
        consoleLogInfo("\(self.swiftClassName ?? "") deinit", type: .debug)
    }

}

extension UserServiceImplement:UserServiceProtocol {
    
    public func bindUserStateChangedListener(listener: UserStateChangedListener) {
        if self.responseDelegates.contains(listener) {
            return
        }
        self.responseDelegates.add(listener)
    }
    
    public func unBindUserStateChangedListener(listener: UserStateChangedListener) {
        if self.responseDelegates.contains(listener) {
            self.responseDelegates.remove(listener)
        }
    }
    
    public func userInfo(userId: String, completion: @escaping (ChatUserProfileProtocol?,ChatError?) -> Void) {
        self.userInfos(userIds: [userId]) { users, error in
            completion(users.first, error)
        }
    }

    public func userInfos(userIds: [String], completion: @escaping ([ChatUserProfileProtocol],ChatError?) -> Void) {
        guard !userIds.isEmpty else {
            completion([], nil)
            return
        }
        guard let manager = ChatClient.shared().userInfoManager else {
            completion([], ChatError(description: "User information manager is unavailable", code: .general))
            return
        }
        manager.fetchUserInfo(byId: userIds) { [self] infoMap, error in
            let users = userIds.compactMap { userId in
                infoMap?[userId].map { self.convertToUser(info: $0) }
            }
            if error == nil {
                ChatUIKitContext.shared?.updateChatAndUserTypeCaches(profiles: users)
            }
            completion(users, error)
        }
    }

    public func updateUserInfo(userInfo: ChatUserProfileProtocol, completion: @escaping (Bool, ChatError?) -> Void) {
        guard userInfo.id == ChatUIKitContext.shared?.currentUserId else {
            completion(false, ChatError(description: "Only the current user's information can be updated", code: .invalidParam))
            return
        }
        guard let manager = ChatClient.shared().userInfoManager else {
            completion(false, ChatError(description: "User information manager is unavailable", code: .general))
            return
        }
        manager.updateOwn(self.convertToUserInfo(user: userInfo)) { [self] info, error in
            if error == nil {
                let profile: ChatUserProfileProtocol = info.map { self.convertToUser(info: $0) } ?? userInfo
                ChatUIKitContext.shared?.currentUser = profile
                ChatUIKitContext.shared?.updateChatAndUserTypeCaches(profiles: [profile])
            }
            completion(error == nil, error)
        }
    }

    public func login(userId: String, token: String, completion: @escaping (Bool, ChatError?) -> Void) {
        ChatClient.shared().login(withUsername: userId, token: token) { user_id, error in
            completion(error == nil,error)
        }
    }
    
    public func logout(unbindNotificationDeviceToken: Bool = false, completion: @escaping (Bool, ChatError?) -> Void) {
        ChatClient.shared().logout(unbindNotificationDeviceToken) { error in
            completion(error == nil,error)
        }
    }
    
    fileprivate func convertToUser(info: UserInfo) -> ChatUserProfile {
        let user = ChatUserProfile()
        user.id = info.userId ?? ""
        user.nickname = info.nickname ?? ""
        if let remark = ChatClient.shared().contactManager?.getContact(user.id)?.remark {
            user.remark = remark
        }
        user.avatarURL = info.avatarUrl ?? ""
        return user
    }
    
    private func convertToUserInfo(user: ChatUserProfileProtocol) -> UserInfo {
        let info = UserInfo()
        info.userId = user.id
        info.nickname = user.nickname
        info.avatarUrl = user.avatarURL
        return info
    }
    
}

//MARK: - ChatClientDelegate
extension UserServiceImplement: ChatClientListener {
    public func tokenDidExpire(_ aErrorCode: ChatErrorCode) {
        for response in self.responseDelegates.allObjects {
            response.onUserTokenDidExpired()
        }
    }
    
    public func tokenWillExpire(_ aErrorCode: ChatErrorCode) {
        for response in self.responseDelegates.allObjects {
            response.onUserTokenWillExpired()
        }
    }
    
    public func userAccountDidLoginFromOtherDevice(with info: LoginExtensionInfo?) {
        for response in self.responseDelegates.allObjects {
            response.onUserLoginOtherDevice(device: info?.deviceName ?? "")
        }
    }
    
    public func connectionStateDidChange(_ aConnectionState: ConnectionState) {
        for response in self.responseDelegates.allObjects {
            response.onSocketConnectionStateChanged(state: aConnectionState)
        }
    }
    
    public func userDidForbidByServer() {
        for response in self.responseDelegates.allObjects {
            response.userDidForbidden()
        }
    }
    
    public func userAccountDidRemoveFromServer() {
        for response in self.responseDelegates.allObjects {
            response.userAccountDidRemoved()
        }
    }
    
    public func userAccountDidForced(toLogout aError: ChatError?) {
        for response in self.responseDelegates.allObjects {
            response.userAccountDidForcedToLogout(error: aError)
        }
    }
    
    public func onDatabaseOpened(_ error: ChatError?, username: String) {
        for response in self.responseDelegates.allObjects {
            response.onUserDatabaseOpened?(error: error, userId: username)
        }
    }

    public func syncDataStart(with type: DataSyncType) {
        for response in self.responseDelegates.allObjects {
            response.onUserDataSyncStart?(type: type)
        }
    }

    public func syncDataFinished(_ error: ChatError?, type: DataSyncType) {
        for response in self.responseDelegates.allObjects {
            response.onUserDataSyncFinished?(error: error, type: type)
        }
    }
}

extension UserServiceImplement: UserInfoManagerDelegate {
    public func onSelfUserInfoUpdate(_ aUserInfo: UserInfo) {
        ChatUIKitContext.shared?.updateChatAndUserTypeCaches(profiles: [self.convertToUser(info: aUserInfo)])
    }

    public func onUserInfoUpdate(_ aUserInfos: [String : UserInfo]) {
        ChatUIKitContext.shared?.updateChatAndUserTypeCaches(profiles: aUserInfos.values.map { self.convertToUser(info: $0) })
    }
}

