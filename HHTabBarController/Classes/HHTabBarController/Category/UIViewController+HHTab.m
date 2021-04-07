//
//  UIViewController+HHTab.m
//  HHTabBarController
//
//  Created by 崔辉辉 on 2020/4/14.
//  Copyright © 2020 huihui. All rights reserved.
//

#import "UIViewController+HHTab.h"
#import <objc/runtime.h>
#import "HHTabBar.h"
@implementation UIViewController (HHTab)

#pragma mark - 关联属性

- (NSString *)tabItemTitle
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setTabItemTitle:(NSString *)tabItemTitle
{
    objc_setAssociatedObject(self, @selector(tabItemTitle), tabItemTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (UIImage *)tabItemImage
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setTabItemImage:(UIImage *)tabItemImage
{
    objc_setAssociatedObject(self, @selector(tabItemImage), tabItemImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIImage *)tabItemSelectedImage
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setTabItemSelectedImage:(UIImage *)tabItemSelectedImage
{
    objc_setAssociatedObject(self, @selector(tabItemSelectedImage), tabItemSelectedImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HHTabItem *)tabItem
{
    HHTabBar *tabBar = self.hh_tabBarController.tabBar;
    if (!tabBar) {
        return nil;
    }
    if (![self.hh_tabBarController.viewControllers containsObject:self]) {
        return nil;
    }
    
    NSUInteger index = [self.hh_tabBarController.viewControllers indexOfObject:self];
    return tabBar.items[index];
}
- (id<HHTabBarControllerProtocol>)hh_tabBarController
{
    if ([self.parentViewController conformsToProtocol:@protocol(HHTabBarControllerProtocol)]) {
        return (id<HHTabBarControllerProtocol>)self.parentViewController;
    }
    return nil;
}

- (void)hh_tabItemDidDeselected{}

- (UIScrollView *)hh_scrollView
{
    return nil;
}
@end
