//
//  HHTabItem.m
//  HHTabBarController
//
//  Created by 崔辉辉 on 2019/11/15.
//  Copyright © 2019 huihui. All rights reserved.
//

#import "HHTabItem.h"

@interface HHTabItem ()

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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
