//
//  EaseConversationCell.m
//  EaseChatKit
//
//  Update © 2020 zhangchong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseConversationCell.h"
#import "EaseDateHelper.h"
#import "EaseBadgeView.h"
#import "Easeonry.h"
#import "UIImageView+EaseWebCache.h"
#import "UIImage+EaseUI.h"

@interface EaseConversationCell()

@property (nonatomic, strong) EaseConversationViewModel *viewModel;

@end

@implementation EaseConversationCell

+ (EaseConversationCell *)tableView:(UITableView *)tableView identifier:(NSString *)cellIdentifier {
    EaseConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell;
}

- (instancetype)initWithConversationsViewModel:(EaseConversationViewModel*)viewModel
                                    identifier:(NSString *)identifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]){
        _viewModel = viewModel;
        [self _addSubViews];
        [self _setupSubViewsConstraints];
        [self _setupViewsProperty];
    }
    return self;
}

#pragma mark - private layout subviews

- (void)_addSubViews {
    _avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _badgeLabel = [[EaseBadgeView alloc] initWithFrame:CGRectZero];
    _noDisturbView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _topView = [[UIImageView alloc]initWithFrame:CGRectZero];

    [self.contentView addSubview:_avatarView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_detailLabel];
    [self.contentView addSubview:_badgeLabel];
    [self.contentView addSubview:_topView];
    [self.contentView addSubview:_noDisturbView];
    
}

- (void)_setupViewsProperty {
    
    self.backgroundColor = _viewModel.cellBgColor;
    
    _avatarView.backgroundColor = [UIColor clearColor];
    _avatarView.contentMode = UIViewContentModeScaleAspectFit;
    
    _nameLabel.font = _viewModel.nameLabelFont;
    _nameLabel.textColor = _viewModel.nameLabelColor;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _nameLabel.backgroundColor = [UIColor clearColor];
    
    _topView.backgroundColor = [UIColor clearColor];
    _topView.contentMode = UIViewContentModeScaleAspectFit;
    _topView.image = _viewModel.conversationTopIcon;
    
    _noDisturbView.backgroundColor = [UIColor clearColor];
    _noDisturbView.contentMode = UIViewContentModeScaleAspectFit;
    _noDisturbView.image = _viewModel.noDisturbImg;
    
    _detailLabel.font = _viewModel.detailLabelFont;
    _detailLabel.textColor = _viewModel.detailLabelColor;
    _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.textAlignment = NSTextAlignmentLeft;
    
    _timeLabel.font = _viewModel.timeLabelFont;
    _timeLabel.textColor = _viewModel.timeLabelColor;
    _timeLabel.backgroundColor = [UIColor clearColor];
    [_timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    _badgeLabel.font = _viewModel.badgeLabelFont;
    _badgeLabel.backgroundColor = _viewModel.badgeLabelBgColor;
    _badgeLabel.badgeColor = _viewModel.badgeLabelTitleColor;
    _badgeLabel.maxNum = _viewModel.badgeMaxNum;
    if (!_viewModel.needsDisplayBadge) {
        self.badgeLabel.hidden = YES;
    } else {
        self.badgeLabel.hidden = NO;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleGray;
}

- (void)_setupSubViewsConstraints
{
    __weak typeof(self) weakSelf = self;

    [_avatarView Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.ease_top).offset(weakSelf.viewModel.avatarEdgeInsets.top);
        make.bottom.equalTo(weakSelf.contentView.ease_bottom).offset(weakSelf.viewModel.avatarEdgeInsets.bottom);
        make.left.equalTo(weakSelf.contentView.ease_left).offset(weakSelf.viewModel.avatarEdgeInsets.left);
        make.width.offset(weakSelf.viewModel.avatarSize.width);
        make.height.offset(weakSelf.viewModel.avatarSize.height).priority(750);
    }];
    
    [_nameLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.ease_top).offset(weakSelf.viewModel.nameLabelEdgeInsets.top);
        make.left.equalTo(weakSelf.avatarView.ease_right).offset(weakSelf.viewModel.avatarEdgeInsets.right + weakSelf.viewModel.nameLabelEdgeInsets.left);
    }];
    
    [_noDisturbView Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.ease_top).offset(weakSelf.viewModel.noDisturbImgInsets.top);
        make.left.equalTo(weakSelf.nameLabel.ease_right).offset(weakSelf.viewModel.nameLabelEdgeInsets.right + weakSelf.viewModel.noDisturbImgInsets.left);
        make.width.offset(weakSelf.viewModel.noDisturbImgSize.width);
        make.height.offset(weakSelf.viewModel.noDisturbImgSize.height);
    }];

    [_detailLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLabel.ease_bottom).offset(weakSelf.viewModel.nameLabelEdgeInsets.bottom + weakSelf.viewModel.detailLabelEdgeInsets.top);
        make.left.equalTo(weakSelf.avatarView.ease_right).offset(weakSelf.viewModel.avatarEdgeInsets.right + weakSelf.viewModel.detailLabelEdgeInsets.left);
        make.right.equalTo(weakSelf.contentView).offset(weakSelf.viewModel.detailLabelEdgeInsets.right);
        make.bottom.equalTo(weakSelf.contentView.ease_bottom).offset(weakSelf.viewModel.detailLabelEdgeInsets.bottom);
    }];
    
    [_timeLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.ease_top).offset(weakSelf.viewModel.timeLabelEdgeInsets.top);
        make.right.equalTo(weakSelf.contentView.ease_right).offset(weakSelf.viewModel.timeLabelEdgeInsets.right);
        make.left.greaterThanOrEqualTo(weakSelf.noDisturbView.ease_right).offset(weakSelf.viewModel.noDisturbImgInsets.right + weakSelf.viewModel.timeLabelEdgeInsets.left);
    }];
    
    [_topView Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.ease_top).offset(weakSelf.viewModel.conversationTopIconInsets.top);
        make.right.equalTo(weakSelf.contentView.ease_right).offset(weakSelf.viewModel.conversationTopIconInsets.right);
        make.width.offset(weakSelf.viewModel.conversationTopIconSize.width);
        make.height.offset(weakSelf.viewModel.conversationTopIconSize.height);
    }];

  
    if (_viewModel.badgeLabelPosition == EaseAvatarTopRight) {
        [_badgeLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            make.height.offset(_viewModel.badgeLabelHeight);
            make.width.Ease_greaterThanOrEqualTo(weakSelf.viewModel.badgeLabelHeight).priority(1000);
            if (_viewModel.badgeViewStyle == EaseUnreadBadgeViewRedDot) {
                make.height.offset(_viewModel.badgeLabelRedDotHeight);
                make.width.offset(_viewModel.badgeLabelRedDotHeight);
            }
            make.centerY.equalTo(weakSelf.avatarView.ease_top).offset(weakSelf.viewModel.badgeLabelCenterVector.dy);
            make.centerX.equalTo(weakSelf.avatarView.ease_right).offset(weakSelf.viewModel.badgeLabelCenterVector.dx);
        }];
    }else {
        [_badgeLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            make.height.offset(_viewModel.badgeLabelHeight);
            make.width.Ease_greaterThanOrEqualTo(weakSelf.viewModel.badgeLabelHeight).priority(1000);
            if (_viewModel.badgeViewStyle == EaseUnreadBadgeViewRedDot) {
                make.height.offset(_viewModel.badgeLabelRedDotHeight);
                make.width.offset(_viewModel.badgeLabelRedDotHeight);
            }
            make.centerY.equalTo(weakSelf.detailLabel.ease_centerY).offset(weakSelf.viewModel.badgeLabelCenterVector.dy);
            make.right.equalTo(weakSelf.contentView).offset(weakSelf.viewModel.badgeLabelCenterVector.dx);
            make.left.greaterThanOrEqualTo(weakSelf.detailLabel.ease_right).offset(weakSelf.viewModel.detailLabelEdgeInsets.right);
        }];
    }
}

- (void)setModel:(EaseConversationModel *)model
{
    _model = model;
    
    if (model.type == AgoraChatConversationTypeGroupChat) {
        [self setAvatarCornerStyle:_viewModel.groupAvatarStyle];
    }
    if (model.type == AgoraChatConversationTypeChat) {
        [self setAvatarCornerStyle:_viewModel.chatAvatarStyle];
    }
    if (model.type == AgoraChatConversationTypeChatRoom) {
        [self setAvatarCornerStyle:_viewModel.chatroomAvatarStyle];
    }
    
    UIImage *img = nil;
    if ([_model respondsToSelector:@selector(defaultAvatar)]) {
        img = _model.defaultAvatar;
    }
    
    if ([_model respondsToSelector:@selector(avatarURL)]) {
        [self.avatarView Ease_setImageWithURL:[NSURL URLWithString:_model.avatarURL]
                           placeholderImage:img];
    }else {
        self.avatarView.image = img;
    }
    
    if ([_model respondsToSelector:@selector(showName)]) {
        self.nameLabel.text = _model.showName;
    }
    
    if (_model.isTop) {
        if (_viewModel.conversationTopStyle == EaseConversationTopBgColorStyle) {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            self.backgroundColor = _viewModel.conversationTopBgColor;
            self.topView.hidden = YES;
        } else {
            self.topView.hidden = NO;
        }
    } else {
        self.backgroundColor = _viewModel.cellBgColor;
        self.topView.hidden = YES;
    }
    
    self.noDisturbView.hidden = !_model.isNoDistrub;
    if ([_model respondsToSelector:@selector(showInfo)]) {
        self.detailLabel.attributedText = _model.showInfo;
    }
    if ([_model respondsToSelector:@selector(lastestUpdateTime)]) {
        self.timeLabel.text = [EaseDateHelper formattedTimeFromTimeInterval:_model.lastestUpdateTime dateType:EaseDateTypeConversastion];
    }
    if (_viewModel.needsDisplayBadge) {
        [self.badgeLabel setBagde:_model.unreadMessagesCount badgeStyle:_viewModel.badgeViewStyle];
    }
}

- (void)setAvatarCornerStyle:(EaseConversationAvatarParam *)avatarParam
{
    if (avatarParam.avatarType != Rectangular) {
        _avatarView.clipsToBounds = YES;
        if (avatarParam.avatarType == RoundedCorner) {
            _avatarView.layer.cornerRadius = avatarParam.avatarCornerRadius;
        }
        else if(avatarParam.avatarType == Circular) {
            _avatarView.layer.cornerRadius = _viewModel.avatarSize.width / 2;
        }
        
    } else {
        _avatarView.clipsToBounds = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.badgeLabel.backgroundColor = _viewModel.badgeLabelBgColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    self.badgeLabel.backgroundColor = _viewModel.badgeLabelBgColor;
}

@end
