//
//  EMMsgTextBubbleView.m
//  EaseChat
//
//  Created by XieYajie on 2019/2/14.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EMMsgTextBubbleView.h"
#import "EaseEmojiHelper.h"
#import "EMMsgThreadPreviewBubble.h"
#define kHorizontalPadding 12
#define kVerticalPadding 8
#define KEMThreadBubbleWidth (EMScreenWidth*(3/5.0))
@interface EMMsgTextBubbleView ()
{
    EaseChatViewModel *_viewModel;
}
@property (nonatomic, strong) EMMsgThreadPreviewBubble *threadBubble;
@end
@implementation EMMsgTextBubbleView

- (instancetype)initWithDirection:(AgoraChatMessageDirection)aDirection
                             type:(AgoraChatMessageType)aType
                        viewModel:(EaseChatViewModel *)viewModel
{
    self = [super initWithDirection:aDirection type:aType viewModel:viewModel];
    if (self) {
        _viewModel = viewModel;
        [self _setupSubviews];
        self.threadBubble = [[EMMsgThreadPreviewBubble alloc] initWithDirection:aDirection type:aType viewModel:viewModel];
        self.threadBubble.tag = 666;
        [self addSubview:self.threadBubble];
        self.threadBubble.layer.cornerRadius = 8;
        self.threadBubble.clipsToBounds = YES;
    }
    
    return self;
}

#pragma mark - Subviews

- (void)_setupSubviews
{
    [self setupBubbleBackgroundImage];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.font = _viewModel.textMessaegFont;
    self.textLabel.numberOfLines = 0;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:self.textLabel];

    if (self.direction == AgoraChatMessageDirectionSend) {
        self.textLabel.textColor = _viewModel.sentFontColor;
    } else {
        self.textLabel.textColor = _viewModel.reveivedFontColor;
    }

}

- (void)remakeLayout:(EaseMessageModel *)model {
    if (model.message.msgOverView != nil) {
        [self.textLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(self.ease_top).offset(kHorizontalPadding);
            make.bottom.equalTo(self.ease_bottom).offset(-(KEMThreadBubbleWidth*0.4+12));
            make.left.equalTo(self).offset(kHorizontalPadding);
            make.right.equalTo(self).offset(-kHorizontalPadding);
        }];
        [self.threadBubble Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            make.left.Ease_equalTo(kHorizontalPadding);
            make.right.Ease_equalTo(-kHorizontalPadding);
            make.width.Ease_equalTo(KEMThreadBubbleWidth);
            make.height.Ease_equalTo(KEMThreadBubbleWidth*0.4);
            make.bottom.equalTo(self).offset(-kHorizontalPadding);
        }];
    } else {
        CGSize size = [self.textLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//        [self Ease_updateConstraints:^(EaseConstraintMaker *make) {
//            make.width.Ease_equalTo(size.width+kHorizontalPadding*2);
//            make.height.Ease_equalTo(size.height+kHorizontalPadding*2);
//        }];
//        if (self.direction == AgoraChatMessageDirectionReceive) {
            [self.textLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
                make.top.equalTo(self).offset(kHorizontalPadding);
                make.bottom.equalTo(self).offset(-kHorizontalPadding);
                make.left.equalTo(self).offset(kHorizontalPadding);
                make.right.equalTo(self).offset(-kHorizontalPadding);
                make.width.Ease_equalTo(ceilf(size.width));
                make.height.Ease_equalTo(ceilf(size.height));
            }];
//        } else {
//            [self.textLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
//                make.top.equalTo(self).offset(kHorizontalPadding);
//                make.bottom.equalTo(self).offset(-kHorizontalPadding);
//                make.right.equalTo(self).offset(-kHorizontalPadding);
//                make.width.Ease_equalTo(size.width);
//                make.height.Ease_equalTo(size.height);
//            }];
//        }
    }
}

#pragma mark - Setter

- (void)setModel:(EaseMessageModel *)model
{
    [super setModel:model];
    self.threadBubble.hidden = !model.message.msgOverView;
    if (model.thread && model.thread.threadId.length) {
        self.threadBubble.hidden = YES;
    }
    AgoraChatTextMessageBody *body = (AgoraChatTextMessageBody *)model.message.body;
    
    NSString *text = [EaseEmojiHelper convertEmoji:body.text];
    NSMutableAttributedString *attaStr = [[NSMutableAttributedString alloc] initWithString:text];
    /*
    //下滑线
    NSMutableAttributedString *underlineStr = [[NSMutableAttributedString alloc] initWithString:@"下滑线"];
    [underlineStr addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                  NSUnderlineColorAttributeName: [UIColor redColor]
                                  } range:NSMakeRange(0, 3)];
    [attaStr appendAttributedString:underlineStr];
    //删除线
    NSMutableAttributedString *throughlineStr = [[NSMutableAttributedString alloc] initWithString:@"删除线"];
    [throughlineStr addAttributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle),
                                    NSStrikethroughColorAttributeName: [UIColor orangeColor]
                                    } range:NSMakeRange(0, 3)];
    [attaStr appendAttributedString:throughlineStr];*/
    
    //Hyperlinks
    NSDataDetector *detector= [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *checkArr = [detector matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    for (NSTextCheckingResult *result in checkArr) {
        NSString *urlStr = result.URL.absoluteString;
        NSRange range = [text rangeOfString:urlStr options:NSCaseInsensitiveSearch];
        if(range.length > 0) {
            [attaStr setAttributes:@{NSLinkAttributeName : [NSURL URLWithString:urlStr]} range:NSMakeRange(range.location, urlStr.length)];
        }
    }
    /*
    NSString *urlStr = @"http://www.baidu.com";
    NSMutableAttributedString *linkStr = [[NSMutableAttributedString alloc] initWithString:urlStr];
    [linkStr addAttributes:@{NSLinkAttributeName: [NSURL URLWithString:urlStr]} range:NSMakeRange(0, urlStr.length)];
    [attaStr appendAttributedString:linkStr];*/
    //图片
    /*
    NSTextAttachment *imgAttach =  [[NSTextAttachment alloc] init];
    imgAttach.image = [UIImage imageNamed:@"dribbble64_imageio"];
    imgAttach.bounds = CGRectMake(0, 0, 30, 30);
    NSAttributedString *attachStr = [NSAttributedString attributedStringWithAttachment:imgAttach];
    [attaStr appendAttributedString:attachStr];*/
    
    //防止输入时在中文后输入英文过长直接中文和英文换行
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:16],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 ,NSForegroundColorAttributeName:model.direction == AgoraChatMessageDirectionReceive ? _viewModel.reveivedFontColor:_viewModel.sentFontColor };
   
    [attaStr addAttributes:attributes range:NSMakeRange(0, text.length)];
    self.textLabel.attributedText = attaStr;
    if (model.thread == nil && model.message.msgOverView) {
        self.threadBubble.model = model;
    } else self.threadBubble.model = nil;
    [self remakeLayout:self.threadBubble.model];
}

@end
