//
//  HHTabBarControllerProtocol.h
//  HHTabBarController
//
//  Created by 崔辉辉 on 2020/8/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HHTabBar;
@class HHTabContentWithHeaderView;

@protocol HHTabBarControllerProtocol <NSObject>

@property (nonatomic, strong, readonly)HHTabBar *tabBar;
@property (nonatomic, strong, readonly)HHTabContentWithHeaderView *tabContentView;

@property (nonatomic, copy)NSArray <UIViewController *> *viewControllers;


@end

NS_ASSUME_NONNULL_END
