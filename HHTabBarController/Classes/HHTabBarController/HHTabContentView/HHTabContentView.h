//
//  HHTabContentView.h
//  HHTabBarController
//
//  Created by 崔辉辉 on 2019/11/21.
//  Copyright © 2019 huihui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHTabBar.h"
NS_ASSUME_NONNULL_BEGIN

@class HHTabContentView;
@protocol HHTabContentViewDelegate <NSObject>

@optional

/// 是否能切换到指定index
/// @param tabContentView <#tabContentView description#>
/// @param index <#index description#>
- (BOOL)tabContentView:(HHTabContentView *)tabContentView
shouldSelectTabAtIndex:(NSUInteger)index;

/// 将要切换到指定index
/// @param tabContentView <#tabContentView description#>
/// @param index <#index description#>
- (void)tabContentView:(HHTabContentView *)tabContentView
  willSelectTabAtIndex:(NSUInteger)index;

/// 已经切换到指定index
/// @param tabContentView <#tabContentView description#>
/// @param index <#index description#>
- (void)tabContentView:(HHTabContentView *)tabContentView
   didSelectTabAtIndex:(NSUInteger)index;

@end

@interface HHTabContentView : UIView
@property (nonatomic, strong)HHTabBar *tabBar;
@property (nonatomic, strong)NSArray *subViews;

@property (nonatomic, copy)NSArray <UIViewController *>*viewControllers;

@property (nonatomic, weak)id <HHTabContentViewDelegate> delegate;

@property (nonatomic, strong, readonly)UIView *headerView;

/// 第一次显示时，默认被选中的Tab的Index，在viewWillAppear方法被调用前设置有效
@property (nonatomic, assign)NSUInteger defaultSelectedTabIndex;

/// 设置被选中的Tab的Index，界面会自动切换
@property (nonatomic, assign)NSUInteger selectedTabIndex;

@end

NS_ASSUME_NONNULL_END
