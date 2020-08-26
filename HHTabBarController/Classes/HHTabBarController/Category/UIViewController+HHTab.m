//
//  UIViewController+HHTab.m
//  HHTabBarController
//
//  Created by 崔辉辉 on 2020/4/14.
//  Copyright © 2020 huihui. All rights reserved.
//

#import "UIViewController+HHTab.h"
#import <objc/runtime.h>
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

- (void)hh_tabItemDidDeselected{}
@end
