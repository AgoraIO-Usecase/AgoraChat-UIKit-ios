//
//  EaseThreadChatHeader.m
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/30.
//

#import "EaseThreadChatHeader.h"
#import "View+EaseAdditions.h"
@interface EaseThreadChatHeader ()<EaseThreadCreateCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) EMThreadHeaderType type;

@property (nonatomic, strong) EaseChatViewModel *viewModel;

@property (nonatomic) EaseThreadCreateCell *header;

@end

@implementation EaseThreadChatHeader

- (instancetype)initWithMessageType:(AgoraChatMessageType)aMessageType displayType:(EMThreadHeaderType)type viewModel:(EaseChatViewModel *)viewModel model:(EaseMessageModel *)model
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.type = type;
        model.isHeader = YES;
        EaseThreadCreateCell *cell = [[EaseThreadCreateCell alloc] initWithMessageType:model.type displayType:self.type viewModel:viewModel model:model];
        CGSize size = [cell systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
        cell.frame = CGRectMake(0, 0, EMScreenWidth, size.height);
        cell.delegate = self;
        if (type != EMThreadHeaderTypeDisplayNoMessage) {
            self.frame = CGRectMake(0, 0, EMScreenWidth, size.height);
        } else {
            self.frame = CGRectMake(0, 0, EMScreenWidth, 140);
        }
        [self addSubview:cell];
        self.header = cell;
    }
    return self;
}

- (void)setThreadName:(NSString *)threadName {
    [self.header changeThreadName:threadName];
}

#pragma mark - EaseThreadCreateCellDelegate

- (void)messageCellDidSelected:(EaseThreadCreateCell *)aCell
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerMessageDidSelected:)]) {
        [self.delegate headerMessageDidSelected:aCell];
    }
}

- (void)avatarDidSelected:(EaseMessageModel *)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerAvatarClick:)]) {
        [self.delegate headerAvatarClick:model];
    }
}

@end
