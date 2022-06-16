//
//  AgoraChatThreadCreateViewController+ChatToolBarMeida.h
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/19.
//

#import "EaseThreadCreateViewController.h"

typedef NS_ENUM(NSInteger, AgoraChatToolBarComponentType) {
    AgoraChatToolBarPhotoAlbum = 0,
    AgoraChatToolBarCamera,
    AgoraChatToolBarLocation,
    AgoraChatToolBarFileOpen,
};

@interface EaseThreadCreateViewController (ChatToolBarMeida) <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePicker;

- (NSString *)getAudioOrVideoPath;

- (void)chatToolBarComponentIncidentAction:(AgoraChatToolBarComponentType)componentType;

@end



@interface EaseThreadCreateViewController (ChatToolBarLocation)

- (void)chatToolBarLocationAction;
@end

@interface EaseThreadCreateViewController (ChatToolBarFileOpen) <UIDocumentPickerDelegate>

- (void)chatToolBarFileOpenAction;
@end
