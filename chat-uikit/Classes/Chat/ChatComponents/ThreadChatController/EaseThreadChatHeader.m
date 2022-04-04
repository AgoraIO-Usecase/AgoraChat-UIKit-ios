//
//  EaseThreadChatHeader.m
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/30.
//

#import "EaseThreadChatHeader.h"
@interface EaseThreadChatHeader ()<EaseThreadCreateCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) EMThreadHeaderType type;

@property (nonatomic, strong) EaseChatViewModel *viewModel;

@end

@implementation EaseThreadChatHeader

- (instancetype)initWithMessageType:(AgoraChatMessageType)aMessageType displayType:(EMThreadHeaderType)type viewModel:(EaseChatViewModel *)viewModel model:(EaseMessageModel *)model
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.type = type;
        EaseThreadCreateCell *cell = [[EaseThreadCreateCell alloc] initWithMessageType:model.type displayType:self.type viewModel:viewModel];
        cell.model = model;
        CGSize size = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        cell.frame = CGRectMake(0, 0, EMScreenWidth, size.height);
        cell.model = model;
        cell.delegate = self;
        if (model.message) {
            self.frame = CGRectMake(0, 0, EMScreenWidth, size.height);
        } else {
            self.frame = CGRectMake(0, 0, EMScreenWidth, 134);
        }
        [self addSubview:cell];
    }
    return self;
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
