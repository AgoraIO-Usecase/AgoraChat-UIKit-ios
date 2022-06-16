//
//  EaseChatMessageBubbleView.m
//  EaseChat

#import "EaseChatMessageBubbleView.h"
#import "UIView+AgoraChatGradient.h"

@implementation EaseChatMessageBubbleView

- (instancetype)initWithDirection:(AgoraChatMessageDirection)aDirection
                             type:(AgoraChatMessageType)aType
                        viewModel:(EaseChatViewModel *)viewModel
{
    self = [super init];
    if (self) {
        _direction = aDirection;
        _type = aType;
        _viewModel = viewModel;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setupBubbleBackgroundImage
{
//    if (_direction == AgoraChatMessageDirectionSend) {
//        self.radiusCorner((UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft) | UIRectCornerBottomRight).radiusFloat(16 || 4).fillColor(nil).lineColor([UIColor blueColor]).lineWidth(0.5);
//        [self manualDrawing];
//    } else {
//        self.radiusCorner(UIRectCornerTopLeft | UIRectCornerTopLeft | UIRectCornerBottomLeft).radiusFloat(16).fillColor(nil).lineColor([UIColor blueColor]).lineWidth(0.5);
//        [self manualDrawing];
//    }
    
    //[self az_setGradientBackgroundWithColors:@[[UIColor redColor],[UIColor orangeColor]] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1)];
    if (self.unDrawCorner) {
        return;
    }
    UIEdgeInsets edge = UIEdgeInsetsMake(_viewModel.bubbleBgEdgeInsets.top, _viewModel.bubbleBgEdgeInsets.left, _viewModel.bubbleBgEdgeInsets.bottom, _viewModel.bubbleBgEdgeInsets.right);
    if (self.direction == AgoraChatMessageDirectionSend) {
        UIImage *image = [_viewModel.senderBubbleBgImage resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
        [self setImage:image];
    } else {
        UIImage *image = [_viewModel.receiverBubbleBgImage resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
        [self setImage:image];
    }
}

- (void)setupThreadBubbleBackgroundImage {
    UIEdgeInsets edge = UIEdgeInsetsMake(8, 8, 8, 8);
    UIImage *image = [_viewModel.threadBubbleBgImage resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    [self setImage:image];
}

- (void)setUnDrawCorner:(BOOL)unDrawCorner {
    _unDrawCorner = unDrawCorner;
    [self setImage:nil];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setCornerRadius:(CGRect)bounds
{
    if (_unDrawCorner == YES) {
        return;
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    CGPathRef path = [self CYPathCreateWithRoundedRect:bounds];
    shapeLayer.path = path;
    CGPathRelease(path);
    self.layer.mask = shapeLayer;
    self.clipsToBounds = NO;
}

//cornerRadius
- (CGPathRef)CYPathCreateWithRoundedRect:(CGRect)bounds
{
    BubbleCornerRadius cornerRadius = self.direction == AgoraChatMessageDirectionSend ? self.viewModel.rightAlignmentCornerRadius : self.viewModel.leftAlignmentCornerRadius;
    BOOL thread = (self.model.message.chatThread != nil);//self.model.message.isChatThreadMessage
    if (thread == YES) {
        cornerRadius = self.viewModel.threadCornerRadius;
    }
    const CGFloat minX = CGRectGetMinX(bounds);
    const CGFloat minY = CGRectGetMinY(bounds);
    const CGFloat maxX = CGRectGetMaxX(bounds);
    const CGFloat maxY = CGRectGetMaxY(bounds);
    
    const CGFloat topLeftCenterX = minX + cornerRadius.topLeft;
    const CGFloat topLeftCenterY = minY + cornerRadius.topLeft;
     
    const CGFloat bottomLeftCenterX = minX + cornerRadius.bottomLeft;
    const CGFloat bottomLeftCenterY = maxY - cornerRadius.bottomLeft;
    
    const CGFloat bottomRightCenterX = maxX - cornerRadius.bottomRight;
    const CGFloat bottomRightCenterY = maxY - cornerRadius.bottomRight;
    
    const CGFloat topRightCenterX = maxX - cornerRadius.topRight;
    const CGFloat topRightCenterY = minY + cornerRadius.topRight;
     
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddArc(path, NULL, topLeftCenterX, topLeftCenterY,cornerRadius.topLeft, M_PI, 3 * M_PI_2, NO);
 
    CGPathAddArc(path, NULL, topRightCenterX , topRightCenterY, cornerRadius.topRight, 3 * M_PI_2, 0, NO);
  
    CGPathAddArc(path, NULL, bottomRightCenterX, bottomRightCenterY, cornerRadius.bottomRight,0, M_PI_2, NO);
 
    CGPathAddArc(path, NULL, bottomLeftCenterX, bottomLeftCenterY, cornerRadius.bottomLeft, M_PI_2,M_PI, NO);
    CGPathCloseSubpath(path);
    return path;
}

- (void)setModel:(EaseMessageModel *)model {
    _model = model;
}

@end
