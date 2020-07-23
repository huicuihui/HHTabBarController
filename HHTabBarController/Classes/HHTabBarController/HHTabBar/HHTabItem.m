//
//  HHTabItem.m
//  HHTabBarController
//
//  Created by 崔辉辉 on 2019/11/15.
//  Copyright © 2019 huihui. All rights reserved.
//

#import "HHTabItem.h"

@interface HHTabItem ()
@property (nonatomic, strong)UIButton *badgeButton;

/// badgeButton与TabItem顶部的距离
@property (nonatomic, assign)CGFloat numberBadgeMarginTop;
/// badgeButton中心与TabItem右侧的距离
@property (nonatomic, assign)CGFloat numberBadgeCenterMarginRight;
@property (nonatomic, assign)CGFloat numberBadgeTitleHorizonalSpace;
@property (nonatomic, assign)CGFloat numberBadgeTitleVerticalSpace;

/// badgeButton与TabItem顶部的距离
@property (nonatomic, assign)CGFloat dotBadgeMarginTop;
@property (nonatomic, assign)CGFloat dotBadgeCenterMarginRight;
@property (nonatomic, assign)CGFloat dotBadgeSideLength;

@end

@implementation HHTabItem
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    HHTabItem *item = [super buttonWithType:buttonType];
    [item setup];
    return item;
}
- (void)setup
{
    self.badgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.badgeButton.userInteractionEnabled = NO;
    self.badgeButton.clipsToBounds = YES;
    [self addSubview:self.badgeButton];
    
    self.adjustsImageWhenHighlighted = NO;
    _indicatorInsets = UIEdgeInsetsZero;
}
#pragma mark - 覆盖父类的setHighlighted:方法，按下HHTabBar时，不高亮该item
- (void)setHighlighted:(BOOL)highlighted
{
    if (self.adjustsImageWhenHighlighted) {
        [super setHighlighted:highlighted];
    }
}
- (void)updateFrameOfSubviews
{
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.imageEdgeInsets = UIEdgeInsetsZero;
    self.titleEdgeInsets = UIEdgeInsetsZero;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _frameWithOutTransform = frame;
    [self updateBadge];
    [self calculateIndicatorFrame];
    [self updateFrameOfSubviews];
}
#pragma mark - Title and Image
- (void)setTitle:(NSString *)title
{
    _title = title;
    [self setTitle:title forState:UIControlStateNormal];
    [self calculateTitleWidth];
}
- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}
- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor
{
    _titleSelectedColor = titleSelectedColor;
    [self setTitleColor:titleSelectedColor forState:UIControlStateSelected];
}
- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    if ([UIDevice currentDevice].systemVersion.integerValue >= 8) {
        self.titleLabel.font = titleFont;
    }
    [self calculateTitleWidth];
}
#pragma mark 计算titleWidth
- (void)calculateTitleWidth
{
    if (self.title.length == 0 || !self.titleFont) {
        _titleWidth = 0;
        return;
    }
    CGSize size = [self.title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.titleFont} context:nil].size;
    _titleWidth = ceilf(size.width);
}
#pragma mark - indicator
- (void)setIndicatorInsets:(UIEdgeInsets)indicatorInsets
{
    _indicatorInsets = indicatorInsets;
    [self calculateIndicatorFrame];
}
- (void)calculateIndicatorFrame
{
    CGRect frame = self.frameWithOutTransform;
    UIEdgeInsets insets = self.indicatorInsets;
    _indicatorFrame = CGRectMake(frame.origin.x + insets.left,
                                 frame.origin.y + insets.top,
                                 frame.size.width - insets.left - insets.right,
                                 frame.size.height - insets.top - insets.bottom);
}

#pragma mark - Badge
- (void)setBadge:(NSInteger)badge
{
    _badge = badge;
    [self updateBadge];
}

- (void)updateBadge
{
    if (self.badgeStyle == HHTabItemBadgeStyleNumber) {
        if (self.badge == 0) {
            self.badgeButton.hidden = YES;
        } else {
            NSString *badgeStr = @(self.badge).stringValue;
            if (self.badge > 99) {
                badgeStr = @"99+";
            } else if (self.badge < -99) {
                badgeStr = @"-99+";
            }
            //计算badgeStr的size
            CGSize size = [badgeStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.badgeButton.titleLabel.font} context:nil].size;
            //计算badgeButton的宽度和高度
            CGFloat width = ceilf(size.width) + self.numberBadgeTitleHorizonalSpace;
            CGFloat height = ceilf(size.height) + self.numberBadgeTitleVerticalSpace;
            
            //宽度取width和height的较大值，使badge为个数时，badgeButton为圆形
            width = MAX(width, height);
            
            //设置badgedButton的frame
            self.badgeButton.frame = CGRectMake(self.bounds.size.width - width / 2 - self.numberBadgeCenterMarginRight, self.numberBadgeMarginTop, width, height);
            self.badgeButton.layer.cornerRadius = self.badgeButton.bounds.size.height / 2.0;
            [self.badgeButton setTitle:badgeStr forState:UIControlStateNormal];
            self.badgeButton.hidden = NO;
        }
    }
    else if (self.badgeStyle == HHTabItemBadgeStyleDot)
    {
        [self.badgeButton setTitle:nil forState:UIControlStateNormal];
        self.badgeButton.frame = CGRectMake(self.bounds.size.width - self.dotBadgeCenterMarginRight - self.dotBadgeSideLength, self.dotBadgeMarginTop, self.dotBadgeSideLength, self.dotBadgeSideLength);
        self.badgeButton.layer.cornerRadius = self.badgeButton.bounds.size.width / 2.0;
        self.badgeButton.hidden = NO;
    }
}

- (void)setNumberBadgeMarginTop:(CGFloat)marginTop
              centerMarginRight:(CGFloat)centerMarginRight
            titleHorizonalSpace:(CGFloat)titleHorizonalSpace
             titleVerticalSpace:(CGFloat)titleVerticalSpace
{
    self.numberBadgeMarginTop = marginTop;
    self.numberBadgeCenterMarginRight = centerMarginRight;
    self.numberBadgeTitleHorizonalSpace = titleHorizonalSpace;
    self.numberBadgeTitleVerticalSpace = titleVerticalSpace;
    [self updateBadge];
}

- (void)setDotBadgeMarginTop:(CGFloat)marginTop
           centerMarginRight:(CGFloat)centerMarginRight
                   sideLenth:(CGFloat)sideLength
{
    self.dotBadgeMarginTop = marginTop;
    self.dotBadgeCenterMarginRight = centerMarginRight;
    self.dotBadgeSideLength = sideLength;
    [self updateBadge];
}

- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor
{
    _badgeBackgroundColor = badgeBackgroundColor;
    self.badgeButton.backgroundColor = badgeBackgroundColor;
}

- (void)setBadgeBackgroundImage:(UIImage *)badgeBackgroundImage
{
    _badgeBackgroundImage = badgeBackgroundImage;
    [self.badgeButton setBackgroundImage:badgeBackgroundImage forState:UIControlStateNormal];
}

- (void)setBadgeTitleColor:(UIColor *)badgeTitleColor
{
    _badgeTitleColor = badgeTitleColor;
    [self.badgeButton setTitleColor:badgeTitleColor forState:UIControlStateNormal];
}

- (void)setBadgeTitleFont:(UIFont *)badgeTitleFont
{
    _badgeTitleFont = badgeTitleFont;
    self.badgeButton.titleLabel.font = badgeTitleFont;
    [self updateBadge];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
