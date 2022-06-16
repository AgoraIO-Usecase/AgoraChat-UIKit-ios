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
@property (nonatomic, weak) id<EaseChatViewControllerDelegate> delegate;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic) EaseChatViewModel *viewModel;


- (instancetype)initWithType:(EMThreadHeaderType)type viewModel:(EaseChatViewModel *)viewModel message:(EaseMessageModel *)message;

- (void)setUserProfiles:(NSArray<id<EaseUserProfile>> *)userProfileAry;

// Set chat controller view
- (void)setChatVCWithViewModel:(EaseChatViewModel *)viewModel;

- (void)setNavgation:(UIView *)view;

// Setup inputbar
- (void)setupInputMenu:(EaseInputMenu *)inputbar;

// Sending text messages
- (void)sendTextAction:(NSString *)aText ext:(NSDictionary * __nullable)aExt;

// Sending message body
- (void)sendMessageWithBody:(AgoraChatMessageBody * __nonnull)aBody ext:(NSDictionary * __nullable)aExt;

// Stop playing audio
- (void)stopAudioPlayer;

@end


