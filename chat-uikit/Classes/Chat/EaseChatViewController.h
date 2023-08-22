//
//  EaseChatViewController.h
//  EaseChatKit
//
//  Update © 2020 zhangchong. All rights reserved.
//


#import "EaseChatViewModel.h"
#import "EaseChatViewControllerDelegate.h"
#import "EaseInputMenu.h"

NS_ASSUME_NONNULL_BEGIN

@interface EaseChatViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIDocumentInteractionControllerDelegate, AgoraChatManagerDelegate, EaseInputMenuDelegate, EaseMessageCellDelegate, EaseInputMenuEmoticonViewDelegate, EaseInputMenuRecordAudioViewDelegate>

@property (nonatomic, weak) id<EaseChatViewControllerDelegate> delegate;

@property (nonatomic, strong) AgoraChatConversation *currentConversation;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *moreMsgId;  //Message ID of the first message
@property (nonatomic) NSTimeInterval msgTimelTag;   //Message time formatting
@property (nonatomic, assign, readonly) AgoraChatConversationType conversationType;
@property (nonatomic, assign, readonly) BOOL isChatThread;
@property (atomic) BOOL loadFinished;
@property (nonatomic, strong, readonly) EaseChatViewModel *viewModel;
@property (nonatomic) BOOL endScroll;//When message list end scroll,the property value is `NO`.
@property (nonatomic, strong) EaseInputMenu *inputBar;
@property (nonatomic) BOOL editMode;//Whether to enter edit mode
@property (nonatomic) NSMutableArray <id<EaseUserProfile>>*profiles;
@property (nonatomic) EditToolBar *toolBar;

+ (EaseChatViewController *)initWithConversationId:(NSString *)aConversationId
                                  conversationType:(AgoraChatConversationType)aType
                                     chatViewModel:(EaseChatViewModel *)aModel;

+ (EaseChatViewController *)chatWithConversationId:(NSString *)aConversationId
                                  conversationType:(AgoraChatConversationType)aType
                                     chatViewModel:(EaseChatViewModel *)aModel parentMessageId:(NSString * )parentMessageId isChatThread:(BOOL)isChatThread;

// Set user profiles
- (void)setUserProfiles:(NSArray<id<EaseUserProfile>> *)userProfileAry;

// Set chat controller view
- (void)setChatVCWithViewModel:(EaseChatViewModel *)viewModel;

// Setup inputbar
- (void)setupInputMenu:(EaseInputMenu *)inputbar;

// Set whether to display typing indicator

- (void)setTypingIndicator:(BOOL)typingIndicator;

- (void)setEditingStatusVisible:(BOOL)typingIndicator;

// Sending text messages
- (void)sendTextAction:(NSString *)aText ext:(NSDictionary * __nullable)aExt;

// Sending message body
- (void)sendMessageWithBody:(AgoraChatMessageBody *)aBody ext:(NSDictionary * __nullable)aExt;

// Sending message read receipt
- (void)sendReadReceipt:(AgoraChatMessage *)msg;

// Refresh tableview.
//      isScrollBottom:Whether the list scrolls to the bottom (at the latest message)
- (void)refreshTableView:(BOOL)isScrollBottom;

// Clear other controller pages that pop up from the chat page (for example, clean album popup page, picture browsing page, input expansion area, etc.)
- (void)cleanPopupControllerView;

// Stop playing audio
- (void)stopAudioPlayer;

- (void)refreshTableViewWithData:(NSArray<AgoraChatMessage *> *)messages isInsertBottom:(BOOL)isInsertBottom isScrollBottom:(BOOL)isScrollBottom;

- (void)threadsList;

- (void)loadData:(BOOL)isScrollBottom;

@end

NS_ASSUME_NONNULL_END
