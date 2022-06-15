//
//  AgoraChatThreadCreateViewController.h
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/18.
//

#import <UIKit/UIKit.h>
#import "EaseThreadCreateCell.h"
#import "EaseChatViewControllerDelegate.h"
@class EaseInputMenu;
@interface EaseThreadCreateViewController : UIViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIDocumentInteractionControllerDelegate,EaseThreadCreateCellDelegate>
{
    EMThreadHeaderType _displayType;
}
@property (nonatomic, weak) id<EaseChatViewControllerDelegate> _Nullable delegate;

@property (nonatomic, strong) UITableView * _Nonnull tableView;

@property (nonatomic, strong) NSMutableArray * _Nonnull dataArray;

@property (nonatomic) EaseChatViewModel * _Nonnull viewModel;


- (instancetype _Nonnull)initWithType:(EMThreadHeaderType)type viewModel:(EaseChatViewModel *_Nonnull)viewModel message:(EaseMessageModel *_Nonnull)message;

- (void)setUserProfiles:(NSArray<id<EaseUserProfile>> *_Nullable)userProfileAry;

// Set chat controller view
- (void)setChatVCWithViewModel:(EaseChatViewModel *_Nonnull)viewModel;

- (void)setNavgation:(UIView *_Nonnull)view;

// Setup inputbar
- (void)setupInputMenu:(EaseInputMenu * _Nonnull)inputbar;

// Sending text messages
- (void)sendTextAction:(NSString * _Nonnull)aText ext:(NSDictionary * __nullable)aExt;

// Sending message body
- (void)sendMessageWithBody:(AgoraChatMessageBody * __nonnull)aBody ext:(NSDictionary * __nullable)aExt;

// Stop playing audio
- (void)stopAudioPlayer;

@end


