//
//  EaseChatViewController+ChatToolBarIncident.h
//  EaseIM
//
//  Created by zhangchong on 2020/7/13.
//  Copyright © 2020 zhangchong. All rights reserved.
//

#import "EaseChatViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EMChatToolBarComponentType) {
    EMChatToolBarPhotoAlbum = 0,
    EMChatToolBarCamera,
    EMChatToolBarLocation,
    EMChatToolBarFileOpen,
};

@interface EaseChatViewController (ChatToolBarMeida) <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;

- (NSString *)getAudioOrVideoPath;

- (void)chatToolBarComponentIncidentAction:(EMChatToolBarComponentType)componentType;
@end

@interface EaseChatViewController (ChatToolBarLocation)

- (void)chatToolBarLocationAction;
@end

@interface EaseChatViewController (ChatToolBarFileOpen) <UIDocumentPickerDelegate>

- (void)chatToolBarFileOpenAction;
@end

NS_ASSUME_NONNULL_END
