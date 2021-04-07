//
//  HHTabBar+Item.m
//  HHTabBarController
//
//  Created by 崔辉辉 on 2020/8/26.
//

#import "HHTabBar+Item.h"
#import <objc/runtime.h>
#import "HHTabBar+Indicator.h"
@implementation HHTabBar (Item)

#pragma mark - ItemTitle
- (UIColor *)itemTitleColor
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setItemTitleColor:(UIColor *)itemTitleColor
{
    objc_setAssociatedObject(self, @selector(itemTitleColor), itemTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.items makeObjectsPerformSelector:@selector(setTitleColor:) withObject:itemTitleColor];
}
- (UIColor *)itemTitleSelectedColor
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setItemTitleSelectedColor:(UIColor *)itemTitleSelectedColor
{
    objc_setAssociatedObject(self, @selector(itemTitleSelectedColor), itemTitleSelectedColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.items makeObjectsPerformSelector:@selector(setTitleSelectedColor:) withObject:itemTitleSelectedColor];
}
- (UIFont *)itemTitleFont
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setItemTitleFont:(UIFont *)itemTitleFont
{
    objc_setAssociatedObject(self, @selector(itemTitleFont), itemTitleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.itemFontChangeFollowContentScroll) {
        // item字体支持平滑切换，更新每个item的scale
        [self updateItemsScaleIfNeeded];
    } else {
        // item字体不支持平滑切换，更新item的字体
        if (self.itemTitleSelectedFont) {
            // 设置了选中字体，则只要更新未选中的item
            for (HHTabItem *item in self.items) {
                if (!item.selected) {
                    item.titleFont = itemTitleFont;
                }
            }
        } else {
            // 未设置选中字体， 更新所有item
            [self.items makeObjectsPerformSelector:@selector(setTitleFont:) withObject:itemTitleFont];
        }
    }
    if (self.itemFitTextWidth) {
        // 如果item的宽度是匹配文字的，更新item的位置
        [self updateItemsFrame];
    }
    [self updateIndicatorFrameWithIndex:self.selectedItemIndex];
}
- (UIFont *)itemTitleSelectedFont
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setItemTitleSelectedFont:(UIFont *)itemTitleSelectedFont
{
    objc_setAssociatedObject(self, @selector(itemTitleSelectedFont), itemTitleSelectedFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.selectedItem.titleFont = itemTitleSelectedFont;
    [self updateItemsScaleIfNeeded];
}

- (BOOL)itemFitTextWidth
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setItemFitTextWidth:(BOOL)itemFitTextWidth
{
    objc_setAssociatedObject(self, @selector(itemFitTextWidth), @(itemFitTextWidth), OBJC_ASSOCIATION_ASSIGN);
}

@end
