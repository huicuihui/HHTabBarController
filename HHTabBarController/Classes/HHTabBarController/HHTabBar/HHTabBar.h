//
//  HHTabBar.h
//  HHTabBarController
//
//  Created by 崔辉辉 on 2019/11/15.
//  Copyright © 2019 huihui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHTabItem.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, HHTabBarIndicatorAnimationStyle) {
    HHTabBarIndicatorAnimationStyleDefault = 0,
};

@class HHTabBar;
@protocol HHTabBarDelegate <NSObject>

@optional

/// 是否能切换到指定index
/// @param tabBar tabBar
/// @param index index
- (BOOL)hh_tabBar:(HHTabBar *)tabBar shouldSelectItemAtIndex:(NSUInteger)index;

/// 将要切换到指定index
/// @param tabBar tabBar
/// @param index index
- (void)hh_tabBar:(HHTabBar *)tabBar willSelectItemAtIndex:(NSUInteger)index;

/// 已经切换到指定index
/// @param tabBar tabBar
/// @param index index
- (void)hh_tabBar:(HHTabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index;

@end

@interface HHTabBar : UIView

@property (nonatomic, copy)NSArray <HHTabItem *>*items;

/// 指示器动画
@property (nonatomic, assign)HHTabBarIndicatorAnimationStyle indicatorAnimationStyle;

/// 第一个item与左边或者上边的距离
@property (nonatomic, assign)CGFloat leadingSpace;
/// 最后一个item与右边或者下边的距离
@property (nonatomic, assign)CGFloat trailingSpace;

/// 选中某一个item
@property (nonatomic, assign)NSUInteger selectedItemIndex;


/// 拖动内容视图时，item的颜色是否根据拖动位置显示渐变效果，默认为YES
@property (nonatomic, assign, getter=isItemColorChangeFollowContentScroll)BOOL itemColorChangeFollowContentScroll;
/// 拖动内容视图时，item的字体是否根据拖动位置显示渐变效果，默认为NO
@property (nonatomic, assign, getter=isItemFontChangeFollowContentScroll)BOOL itemFontChangeFollowContentScroll;
/// TabItem的选中背景是否随contentView滑动而移动
@property (nonatomic, assign, getter=isIndicatorScrollFollowContent)BOOL indicatorScrollFollowContent;


/// TabBar选中切换时，指示器是否有动画
@property (nonatomic, assign)BOOL indicatorSwitchAnimated;

@property (nonatomic, weak)id<HHTabBarDelegate> delegate;

/// 返回已选中的item
- (HHTabItem *)selectedItem;

/// 根据titles创建item
/// @param titles titles
- (void)setTitles:(NSArray <NSString *> *)titles;

/// 设置tabBar可以左右滑动
/// @param width 每个item的宽度
- (void)setScrollEnabledAndItemWidth:(CGFloat)width;
- (void)setScrollEnabledAndItemFitTextWidthWithSpacing:(CGFloat)spacing;
- (void)setScrollEnabledAndItemFitTextWidthWithSpacing:(CGFloat)spacing
                                              minWidth:(CGFloat)minWidth;

/// 当HHTabBar所属的HHTabbarController内容视图支持拖动切换时，此方法用于同步内容视图scrollView拖动的偏移量，以此来改变HHTabBar内控件的状态
/// @param scrollView <#scrollView description#>
- (void)updateSubViewsWhenParentScrollViewScroll:(UIScrollView *)scrollView;


- (void)updateItemsFrame;
- (void)updateItemsScaleIfNeeded;
@end

NS_ASSUME_NONNULL_END
