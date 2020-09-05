//
//  HHTabContentView.h
//  HHTabBarController
//
//  Created by 崔辉辉 on 2019/11/21.
//  Copyright © 2019 huihui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHTabBar.h"
#import "UIViewController+HHTab.h"
#import "HHTabContentScrollView.h"

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
 didSelectedTabAtIndex:(NSUInteger)index;

@end

@interface HHTabContentView : UIView
@property (nonatomic, strong)HHTabContentScrollView *contentScrollView;

@property (nonatomic, strong)HHTabBar *tabBar;
@property (nonatomic, strong)NSArray *views;
@property (nonatomic, copy)NSArray <UIViewController *>*viewControllers;

@property (nonatomic, weak)id <HHTabContentViewDelegate> delegate;

/// 是否有header
@property (nonatomic, assign)BOOL containHeader;


/// 设置内容视图支持滑动切换，以及点击item切换时是否有动画
/// @param enabled 是否支持滑动切换
/// @param animated 点击切换时是否支持动画
- (void)setContentScrollEnabled:(BOOL)enabled tapSwitchAnimated:(BOOL)animated;

/// 第一次显示时，默认被选中的Tab的Index，在viewWillAppear方法被调用前设置有效
@property (nonatomic, assign)NSUInteger defaultSelectedTabIndex;

/// 设置被选中的Tab的Index，界面会自动切换
@property (nonatomic, assign)NSUInteger selectedTabIndex;

/**
 *  此属性仅在内容视图支持滑动时有效，它控制child view controller调用viewDidLoad方法的时机
 *  1. 值为YES时，拖动内容视图，一旦拖动到该child view controller所在的位置，立即加载其view
 *  2. 值为NO时，拖动内容视图，拖动到该child view controller所在的位置，不会立即展示其view，而是要等到手势结束，scrollView停止滚动后，再加载其view
 *  3. 默认值为NO
 */
@property (nonatomic, assign)BOOL loadViewOfChildControllerWhileAppear;

/**
 *  在此属性仅在内容视图支持滑动时有效，它控制chile view controller未选中时，是否将其从父view上面移除
 *  默认为YES
 */
@property (nonatomic, assign)BOOL removeViewOfChildContollerWhileDeselected;

/**
 鉴于有些项目集成了左侧或者右侧侧边栏，当内容视图支持滑动切换时，不能实现在第一页向右滑动和最后一页向左滑动呼出侧边栏的功能，
 此2个属性则可以拦截第一页向右滑动和最后一页向左滑动的手势，实现呼出侧边栏的功能
 */
@property (nonatomic, assign)BOOL interceptRightSlideGuetureInFirstPage;
@property (nonatomic, assign)BOOL interceptLeftSlideGuetureInLastPage;

/// 获取被选中的Controller
- (UIViewController *)selectedController;

/// header子类调用
/// @param scrollView <#scrollView description#>
- (void)containerTableViewDidScroll:(UIScrollView *)scrollView;
- (void)childScrollViewDidScroll:(UIScrollView *)scrollView;
@end

NS_ASSUME_NONNULL_END
