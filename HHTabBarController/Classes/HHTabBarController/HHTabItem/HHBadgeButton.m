//
//  HHBadgeButton.m
//  HHTabBarController
//
//  Created by 崔辉辉 on 2021/4/7.
//

#import "HHBadgeButton.h"

@interface HHBadgeButton()
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

@implementation HHBadgeButton
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
    HHBadgeButton *badgeButton = [super buttonWithType:buttonType];
    [badgeButton setup];
    return badgeButton;
}
- (void)setup
{
    self.userInteractionEnabled = NO;
    self.clipsToBounds = YES;
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
            self.hidden = YES;
        } else {
            NSString *badgeStr = @(self.badge).stringValue;
            if (self.badge > 99) {
                badgeStr = @"99+";
            } else if (self.badge < -99) {
                badgeStr = @"-99+";
            }
            //计算badgeStr的size
            CGSize size = [badgeStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.titleLabel.font} context:nil].size;
            //计算badgeButton的宽度和高度
            CGFloat width = ceilf(size.width) + self.numberBadgeTitleHorizonalSpace;
            CGFloat height = ceilf(size.height) + self.numberBadgeTitleVerticalSpace;
            
            //宽度取width和height的较大值，使badge为个数时，badgeButton为圆形
            width = MAX(width, height);
            
            //设置badgedButton的frame
            self.frame = CGRectMake(self.superview.bounds.size.width - width / 2 - self.numberBadgeCenterMarginRight, self.numberBadgeMarginTop, width, height);
            self.layer.cornerRadius = self.bounds.size.height / 2.0;
            [self setTitle:badgeStr forState:UIControlStateNormal];
            self.hidden = NO;
        }
    }
    else if (self.badgeStyle == HHTabItemBadgeStyleDot)
    {
        [self setTitle:nil forState:UIControlStateNormal];
        self.frame = CGRectMake(self.superview.bounds.size.width - self.dotBadgeCenterMarginRight - self.dotBadgeSideLength, self.dotBadgeMarginTop, self.dotBadgeSideLength, self.dotBadgeSideLength);
        self.layer.cornerRadius = self.bounds.size.width / 2.0;
        self.hidden = NO;
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
    self.backgroundColor = badgeBackgroundColor;
}

- (void)setBadgeBackgroundImage:(UIImage *)badgeBackgroundImage
{
    _badgeBackgroundImage = badgeBackgroundImage;
    [self setBackgroundImage:badgeBackgroundImage forState:UIControlStateNormal];
}

- (void)setBadgeTitleColor:(UIColor *)badgeTitleColor
{
    _badgeTitleColor = badgeTitleColor;
    [self setTitleColor:badgeTitleColor forState:UIControlStateNormal];
}

- (void)setBadgeTitleFont:(UIFont *)badgeTitleFont
{
    _badgeTitleFont = badgeTitleFont;
    self.titleLabel.font = badgeTitleFont;
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
