//
//  UIViewController+HHTab.h
//  HHTabBarController
//
//  Created by 崔辉辉 on 2020/4/14.
//  Copyright © 2020 huihui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHTabBarControllerProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@class HHTabItemBadge;

@interface UIViewController (HHTab)

@property (nonatomic, strong, readonly)HHTabItemBadge *tabItem;
@property (nonatomic, strong, readonly) id<HHTabBarControllerProtocol> hh_tabBarController;

@property (nonatomic, copy)NSString *tabItemTitle;
@property (nonatomic, strong)UIImage *tabItemImage;
@property (nonatomic, strong)UIImage *tabItemSelectedImage;

- (void)hh_tabItemDidDeselected;
@end

NS_ASSUME_NONNULL_END
