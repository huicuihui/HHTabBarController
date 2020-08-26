//
//  HHTabBar+Indicator.m
//  HHTabBarController
//
//  Created by 崔辉辉 on 2020/8/26.
//

#import "HHTabBar+Indicator.h"
#import <objc/runtime.h>
@implementation HHTabBar (Indicator)

- (void)setIndicatorInsets:(UIEdgeInsets)insets
         tapSwitchAnimated:(BOOL)animated
{
    self.indicatorStyle = HHTabBarIndicatorStyleFitItem;
    self.indicatorSwitchAnimated = animated;
    self.indicatorInsets = insets;
    
    [self updateItemIndicatorInsets];
    [self updateIndicatorFrameWithIndex:self.selectedItemIndex];
}

- (void)setIndicatorWidthFitTextAndMarginTop:(CGFloat)top
                                marginBottom:(CGFloat)bottom
                             widthAdditional:(CGFloat)additional
                           tapSwitchAnimated:(BOOL)animated
{
    self.indicatorStyle = HHTabBarIndicatorStyleFitTitle;
    self.indicatorSwitchAnimated = animated;
    self.indicatorInsets = UIEdgeInsetsMake(top, 0, bottom, 0);
    self.indicatorWidthFixTitleAdditional = additional;
    
    [self updateItemIndicatorInsets];
    [self updateIndicatorFrameWithIndex:self.selectedItemIndex];
}

- (void)setIndicatorWidth:(CGFloat)width
                marginTop:(CGFloat)top
             marginBottom:(CGFloat)bottom
        tapSwitchAnimated:(BOOL)animated
{
    self.indicatorStyle = HHTabBarIndicatorStyleFixedWidth;
    self.indicatorSwitchAnimated = animated;
    self.indicatorInsets = UIEdgeInsetsMake(top, 0, bottom, 0);
    self.indicatorWidth = width;
    
    [self updateItemIndicatorInsets];
    [self updateIndicatorFrameWithIndex:self.selectedItemIndex];
}

- (void)updateItemIndicatorInsets
{
    if (self.items.count == 0) return;
    if (self.indicatorStyle == HHTabBarIndicatorStyleFitTitle) {
        for (HHTabItem *item in self.items) {
            CGRect frame = item.frameWithOutTransform;
            CGFloat space = (frame.size.width - item.titleWidth - self.indicatorWidthFixTitleAdditional) / 2;
            item.indicatorInsets = UIEdgeInsetsMake(self.indicatorInsets.top, space, self.indicatorInsets.bottom, space);
        }
    }
    else if (self.indicatorStyle == HHTabBarIndicatorStyleFixedWidth) {
        for (HHTabItem *item in self.items) {
            CGRect frame = item.frameWithOutTransform;
            CGFloat space = (frame.size.width - self.indicatorWidth) / 2;
            item.indicatorInsets = UIEdgeInsetsMake(self.indicatorInsets.top, space, self.indicatorInsets.bottom, space);
        }
    }
    else if (self.indicatorStyle == HHTabBarIndicatorStyleFitItem) {
        for (HHTabItem *item in self.items) {
            item.indicatorInsets = self.indicatorInsets;
        }
    }
}

/// 更新选中背景的frame
/// @param index <#index description#>
- (void)updateIndicatorFrameWithIndex:(NSUInteger)index
{
    if (self.items.count == 0 || index == NSNotFound) {
        self.indicatorImageView.frame = CGRectZero;
        return;
    }
    HHTabItem *item = self.items[index];
    self.indicatorImageView.frame = item.indicatorFrame;
}

#pragma mark - indicator
- (UIColor *)indicatorColor
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    objc_setAssociatedObject(self, @selector(indicatorColor), indicatorColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.indicatorImageView.backgroundColor = indicatorColor;
}
- (UIImage *)indicatorImage
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setIndicatorImage:(UIImage *)indicatorImage
{
    objc_setAssociatedObject(self, @selector(indicatorImage), indicatorImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.indicatorImageView.image = indicatorImage;
}
- (CGFloat)indicatorCornerRadius
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}
- (void)setIndicatorCornerRadius:(CGFloat)indicatorCornerRadius
{
    objc_setAssociatedObject(self, @selector(indicatorCornerRadius), @(indicatorCornerRadius), OBJC_ASSOCIATION_ASSIGN);
    self.indicatorImageView.clipsToBounds = YES;
    self.indicatorImageView.layer.cornerRadius = indicatorCornerRadius;
}
@end
