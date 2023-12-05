//
//  EMMsgTextBubbleView.m
//  EaseChat
//
//  Created by XieYajie on 2019/2/14.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EMMsgTextBubbleView.h"
#import "EaseEmojiHelper.h"
#import "AgoraChatMessage+RemindMe.h"
#import "EMMsgThreadPreviewBubble.h"
#import "EaseUserUtils.h"
#import "EaseHeaders.h"
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
        self.threadBubble.tag = 777;
        [self addSubview:self.threadBubble];
        self.threadBubble.layer.cornerRadius = 8;
        self.threadBubble.clipsToBounds = YES;
        self.threadBubble.hidden = YES;
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
    if (model.message.chatThread != nil && model.isHeader == NO) {
        [self.textLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(self.ease_top).offset(kHorizontalPadding);
            make.bottom.equalTo(self.ease_bottom).offset(-(KEMThreadBubbleWidth*0.4+12+5));
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
        [self.textLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(self).offset(kVerticalPadding);
            make.bottom.equalTo(self).offset(-kVerticalPadding);
            make.left.equalTo(self).offset(kHorizontalPadding);
            make.right.equalTo(self).offset(-kHorizontalPadding);
        }];
        self.threadBubble.hidden = YES;
        [self.threadBubble Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            
        }];
    }
}

- (NSString*)showText
{
    AgoraChatTextMessageBody *body = (AgoraChatTextMessageBody *)self.model.message.body;
    return body.text;
}

#pragma mark - Setter

- (void)setModel:(EaseMessageModel *)model
{
    [super setModel:model];
    if (model.isHeader == NO) {
        if (model.message.chatThread) {
            self.threadBubble.model = model;
            self.threadBubble.hidden = !model.message.chatThread;
        }else {
            self.threadBubble.hidden = YES;
        }
    } else {
        self.threadBubble.hidden = YES;
    }
    
    
    NSString *text = [EaseEmojiHelper convertEmoji:[self showText]];
    NSMutableAttributedString *attaStr = [[NSMutableAttributedString alloc] initWithString:text];
    /*
    //glideline
    NSMutableAttributedString *underlineStr = [[NSMutableAttributedString alloc] initWithString:@"glideline"];
    [underlineStr addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                  NSUnderlineColorAttributeName: [UIColor redColor]
                                  } range:NSMakeRange(0, 3)];
    [attaStr appendAttributedString:underlineStr];
    //strikethrough
    NSMutableAttributedString *throughlineStr = [[NSMutableAttributedString alloc] initWithString:@"strikethrough"];
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
    //picture
    /*
    NSTextAttachment *imgAttach =  [[NSTextAttachment alloc] init];
    imgAttach.image = [UIImage imageNamed:@"dribbble64_imageio"];
    imgAttach.bounds = CGRectMake(0, 0, 30, 30);
    NSAttributedString *attachStr = [NSAttributedString attributedStringWithAttachment:imgAttach];
    [attaStr appendAttributedString:attachStr];*/
    
    //防止输入时在中文后输入英文过长直接中文和英文换行
    UIColor *color;
    if (model.isHeader == YES) {
        color = _viewModel.reveivedFontColor;
    } else {
        color = (model.direction == AgoraChatMessageDirectionReceive ? _viewModel.reveivedFontColor:_viewModel.sentFontColor);
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:16],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName: color};
   
    [attaStr addAttributes:attributes range:NSMakeRange(0, text.length)];
   
    //[attaStr addAttributes:attributes range:NSMakeRange(0, text.length)];
    
    if ([model.message remindMe]) {
        // @ALL
        NSString* strAt = @"@All";
        NSRange range = [text rangeOfString:strAt options:1];
        if (range.length == 0 && AgoraChatClient.sharedClient.currentUsername.length > 0) {
            id<EaseUserProfile> user = [EaseUserUtils.shared getUserInfo:AgoraChatClient.sharedClient.currentUsername moduleType:EaseUserModuleTypeGroupChat];
            strAt = [NSString stringWithFormat:@"@%@",user.showName];
            range = [text rangeOfString:strAt];
        }
        
        if (range.location >= 0 && range.length > 0) {
            //[attaStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"154de"]} range:range];
            [attaStr replaceCharactersInRange:range withAttributedString:[[NSAttributedString alloc] initWithString:strAt attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"154dfe"]}]];
        }
    }
    self.textLabel.attributedText = attaStr;
    if (model.isHeader == NO && model.message.chatThread) {
        self.threadBubble.model = model;
    }
    [self remakeLayout:model];
}

@end
