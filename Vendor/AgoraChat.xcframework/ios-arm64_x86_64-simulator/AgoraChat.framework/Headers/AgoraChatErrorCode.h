/**
 *  \
 *  @header AgoraChatErrorCode.h
 *  @abstract The SDK defined error type.
 *  @author Hyphenate
 *  @version 3.00
 */

#ifndef AgoraChatErrorCode_h
#define AgoraChatErrorCode_h

typedef NS_ENUM(NSInteger, AgoraChatErrorCode) {
    
    AgoraChatErrorNoError = 0,                      /** \ no error */

    AgoraChatErrorGeneral = 1,                      /** \ A general error. */
    AgoraChatErrorNetworkUnavailable,               /** \ The network is unavailable. */
    AgoraChatErrorDatabaseOperationFailed,          /** \ The database operation fails. */
    AgoraChatErrorExceedServiceLimit,               /** \ You have exceeded the service limit. */
    AgoraChatErrorServiceArrearages,                /** \ This error code is deprecated. Your account balance is insufficient.*/
    AgoraChatErrorPushReportActionFailed,            /** \ The push failed.*/
    AgoraChatErrorPartialSuccess,                    /** \ The operation succeeds partially.*/
    AgoraChatErrorAppActiveNumbersReachLimitation,       /** \ The number of daily active users (DAU) or monthly active users (MAU) for the app has reached the upper limit .*/
    
    AgoraChatErrorInvalidAppkey = 100,              /** \ The App key is invalid. */
    AgoraChatErrorInvalidUsername,                  /** \ The user ID is invalid. */
    AgoraChatErrorInvalidPassword,                  /** \ The password is invalid. */
    AgoraChatErrorInvalidURL,                       /** \ The URL is invalid. */
    AgoraChatErrorInvalidToken,                     /** \ The token is invalid. */
    AgoraChatErrorUsernameTooLong,                  /** \ The username is too long. */
    AgoraChatErrorChannelSyncNotOpen,               /** \ The channel message synchronization is not enabled. */
    AgoraChatErrorInvalidConversation,              /** \ Invalid conversation. */
    AgoraChatErrorTokenExpire,                      /** \ The token has expired. */
    AgoraChatErrorTokeWillExpire,                   /** \ The token will expire. */
    
    AgoraChatErrorInvalidParam = 110,               /** \ Parameters are invalid. */
    AgoraChatErrorOperationUnsupported,             /** \ The operation is not supported. */
    AgoraChatErrorQueryParamReachesLimit,           /** \ Query parameters have reached the limit. */
    
    AgoraChatErrorUserAlreadyLoginSame = 200,       /** \ The user is already logged in. */
    AgoraChatErrorUserNotLogin,                     /** \ The user is not logged in. */
    AgoraChatErrorUserAuthenticationFailed,         /** \ The user authentication fails. */
    AgoraChatErrorUserAlreadyExist,                 /** \ The user already exists. */
    AgoraChatErrorUserNotFound,                     /** \ The user is not found. */
    AgoraChatErrorUserIllegalArgument,              /** \ Invalid argument. */
    AgoraChatErrorUserLoginOnAnotherDevice,         /** \ The user has logged in from another device. */
    AgoraChatErrorUserRemoved,                      /** \ The user was removed from the server. */
    AgoraChatErrorUserRegisterFailed,               /** \ User registration fails. */
    AgoraChatErrorUpdateApnsConfigsFailed,          /** \ Fails to configure the Apple push notification.*/
    AgoraChatErrorUserPermissionDenied,             /** \ The user has no operation permission. */
    AgoraChatErrorUserBindDeviceTokenFailed,        /** \ Fails to bind the device token. */
    AgoraChatErrorUserUnbindDeviceTokenFailed,      /** \ Fails to unbind the user with the device token. */
    AgoraChatErrorUserBindAnotherDevice,            /** \ The user is bound to another device and automatic login is not allowed.*/
    AgoraChatErrorUserLoginTooManyDevices,          /** \ The user is logged on too many devices. By default, a user can log in to at most four devices with the same account. To increase this number or disable multi-device login, contact sales@agora.io. */
    AgoraChatErrorUserMuted,                        /** \ The user is muted in the chat group or chat room. */
    AgoraChatErrorUserKickedByChangePassword,       /** \ The user has changed the password. */
    AgoraChatErrorUserKickedByOtherDevice,          /** \ The user is kicked off from another device. */
    AgoraChatErrorUserAlreadyLoginAnother,          /** \ Another user is already logged in. */
    AgoraChatErrorUserMutedByAdmin,                 /** \ The user is muted by the admin. */
    AgoraChatErrorUserDeviceChanged,                /** \ User device different with last login, need login again */
    AgoraChatErrorUserNotOnRoster,                  /** \ The user is not your friend and therefore cannot send messages. */

    AgoraChatErrorServerNotReachable = 300,         /** \ The server is not reachable. */
    AgoraChatErrorServerTimeout,                    /** \ The server response times out. */
    AgoraChatErrorServerBusy,                       /** \ The server is busy. */
    AgoraChatErrorServerUnknownError,               /** \ An unknown server error occurs. */
    AgoraChatErrorServerGetDNSConfigFailed,         /** \ Fails to retrieve the DNS configurations. */
    AgoraChatErrorServerServingForbidden,           /** \ The service is forbidden. */
    AgoraChatErrorServerDecryptionFailed,           /** \ Server transfer decryption failure. */
    AgoraChatErrorServerGetRTCConfigFailed,        /** \ Cannot get the RTC configuration. */
    AgoraChatErrorServerNoMatchURL, /** \ Url doesn't matched with server */
    
    /** \ The connection to the server times out. */
    AgoraChatErrorConnectionTimeout = 350,
    /** \ A DNS error occurs when connecting to the server. */
    AgoraChatErrorConnectionDNSError,
    /** \ An I/O error occurs when connecting to the server. */
    AgoraChatErrorConnectionIOError,
    /** \ The stream is closed when connecting to the server. */
    AgoraChatErrorConnectionStreamClosed,
    /** \ Authentication times out when connecting to the server. */
    AgoraChatErrorConnectionProvisionTimeout,
    
    
    AgoraChatErrorFileNotFound = 400,               /** \ Cannot find the file. */
    AgoraChatErrorFileInvalid,                      /** \ The file is invalid. */
    AgoraChatErrorFileUploadFailed,                 /** \ Fails to upload the file. */
    AgoraChatErrorFileDownloadFailed,               /** \ Fails to download the file. */
    AgoraChatErrorFileDeleteFailed,                 /** \ Fails to delete the file. */
    AgoraChatErrorFileTooLarge,                     /** \ The file is too large. */
    AgoraChatErrorFileContentImproper,              /** \ The file contains improper content. */
    AgoraChatErrorFileExpired,                      /** \ The file is expired. */
    AgoraChatErrorFileDurationTooLong,             /** \ "The duration of the voice file to be transcribed to text exceeds the limit (60s). */
    AgoraChatErrorFileVoiceToTextFailed,           /** \ Fails to transcribe the voice file to text. */
    
    
    AgoraChatErrorMessageInvalid = 500,             /** \ The message is invalid. */
    AgoraChatErrorMessageIncludeIllegalContent,     /** \ The message contains invalid content. */
    AgoraChatErrorMessageTrafficLimit,              /** \ Message sending has exceeded the traffic limit. */
    AgoraChatErrorMessageEncryption,                /** \ An error occurs with message encryption. */
    AgoraChatErrorMessageRecallTimeLimit,           /** \ Message recall has exceeded the time limit. */
    AgoraChatErrorServiceNotEnable,                 /** \ The service is not enabled. */
    AgoraChatErrorMessageExpired,                   /** \  The message has expired. */
    AgoraChatErrorMessageIllegalWhiteList,          /** \  The message fails to be delivered because the user is not in the whitelist.*/
    AgoraChatErrorMessageExternalLogicBlocked,      /** \  The message is blocked by the external logic. */
    AgoraChatErrorMessageCurrentLimiting,           /** \  The message sending failure by the current limiting. */
    AgoraChatErrorMessageSizeLimit,                 /** \  The message sending failure because the body is too large. */
    AgoraChatErrorEditFailed,                      /** \  The message edit failed. */
    AgoraChatErrorStreamIntervalTimeout,    /** \ The chunk of stream message sending interval timeout.*/
    AgoraChatErrorMessageStreamTimeout,    /** \ The  stream message sending timeout.*/
    
    AgoraChatErrorGroupInvalidId = 600,             /** \ The group ID is invalid. */
    AgoraChatErrorGroupAlreadyJoined,               /** \ The user is already in the group. */
    AgoraChatErrorGroupNotJoined,                   /** \ The user has not joined the group. */
    AgoraChatErrorGroupPermissionDenied,            /** \ The user does not have permission to access the operation. */
    AgoraChatErrorGroupMembersFull,                 /** \ The group has reached the maximum member capacity.*/
    AgoraChatErrorGroupSharedFileInvalidId,         /** \ The shared file ID is invalid. */
    AgoraChatErrorGroupNotExist,                    /** \ The group does not exist. */
    AgoraChatErrorGroupDisabled,                    /** \ The group is disabled. */
    AgoraChatErrorGroupNameViolation,               /** \ The group name is invalid. */
    AgoraChatErrorGroupMemberAttributesReachLimit,  /** \ You have reached the maximum number of custom attributes for a group member.  */
    AgoraChatErrorGroupMemberAttributesUpdateFailed,/** \ Fails to set the custom attribute(s) of the group member. */

    AgoraChatErrorGroupMemberAttributesKeyReachLimit,/** \ The key of a custom attribute(s) of the group member has exceeded the maximum allowed length of 16 bytes. */
    
    AgoraChatErrorGroupMemberAttributesValueReachLimit,/** \ The value of a custom attribute(s) of the group member has exceeded the maximum allowed length of 512 bytes. */
    AgoraChatErrorGroupUserInBlockList,             /** \ The userId  is in group block list. */
    
    AgoraChatErrorChatroomInvalidId = 700,          /** \ The chatroom ID is invalid.*/
    AgoraChatErrorChatroomAlreadyJoined,            /** \ The user is already in the chatroom. */
    AgoraChatErrorChatroomNotJoined,                /** \ The user has not joined the chatroom. */
    AgoraChatErrorChatroomPermissionDenied,         /** \ The user does not have operation permission. */
    AgoraChatErrorChatroomMembersFull,              /** \ The chatroom has reached the maximum member capacity. */
    AgoraChatErrorChatroomNotExist,                 /** \ The chatroom does not exist. */
    AgoraChatErrorChatroomOwnerNotAllowLeave,       /** \ The owner of the chat room is not allowed to leave. */
    AgoraChatErrorChatroomUserInBlockList,          /** \ The userId  is in chatroom block list. */
    
    
    AgoraChatErrorUserCountExceed = 900,            /** \ The count of users to get userinfo more than 100 */
    AgoraChatErrorUserInfoDataLengthExceed = 901,   /** \ The count of The datalength of userinfo to set is too long */

    
    AgoraChatErrorContactAddFailed = 1000,           /** \ Fails to add the contact. */
    AgoraChatErrorContactReachLimit = 1001,    /** \ The number of inviter's friends has reached the maximum */
    AgoraChatErrorContactReachLimitPeer = 1002,    /** \ The number of invitee's friends has reached the maximum */

    AgoraChatErrorPresenceParamExceed = 1100, /** \ The value of a presence parameter has reached the upper limit. */
    AgoraChatErrorPresenceCannotSubscribeSelf = 1101, /** \ You cannot subscribe to the presence state of yourself. */
    
    AgoraChatErrorTranslateParamError = 1110, /** \ translation parameter error */
    AgoraChatErrorTranslateServiceNotEnabled = 1111,/** \ Translation service unavailable */
    AgoraChatErrorTranslateUsageLimit = 1112, /** \ Translation is limited */
    AgoraChatErrorTranslateServiceFail = 1113,/** \ Translation failed */
    
    AgoraChatErrorModerationFailed = 1200,           /** \ The service is forbidden. */
    AgoraChatErrorThirdServiceFailed = 1299,                /** \ The service is forbidden. */
    
    AgoraChatErrorReactionReachLimit = 1300,   /** \ The number of Reactions has reached the maximum. */
    AgoraChatErrorReactionHasBeenOperated = 1301,  /** \ The Reaction already exists. */
    AgoraChatErrorReactionOperationIsIllegal = 1302,   /** \ Illegal Reaction operation. */
    AgoraChatErrorThreadNotExist = 1400,/** \ The message thread does not exist. */
    AgoraChatErrorThreadAlreadyExist = 1401, /** \ The message thread already exists. */
    AgoraChatErrorThreadCreateMessageIllegal = 1402,/** \ The parent message for thread creation is invalid. */
    
    AgoraChatErrorNotSupportPush,          /** \ SDK  The current device doesn't support the push function.*/
    AgoraChatErrorPushBindFailed = 1501,/** \ Failed to bind the account with the push function. */
    AgoraChatErrorPushUnBindFailed = 1502,/** \ The push function failed to unbind the account. */
};

#endif
