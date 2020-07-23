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

/// item指示器颜色
@property (nonatomic, strong)UIColor *indicatorColor;
/// item指示器图像
@property (nonatomic, strong)UIImage *indicatorImage;
/// item指示器圆角
@property (nonatomic, assign)CGFloat indicatorCornerRadius;
/// 指示器动画
@property (nonatomic, assign)HHTabBarIndicatorAnimationStyle indicatorAnimationStyle;

/// 标题颜色
@property (nonatomic, strong)UIColor *itemTitleColor;
/// 选中时标题的颜色
@property (nonatomic, strong)UIColor *itemTitleSelectedColor;
/// 标题字体
@property (nonatomic, strong)UIFont *itemTitleFont;
/// 选中时标题的字体
@property (nonatomic, strong)UIFont *itemTitleSelectedFont;


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

/// 设置tabBat可以左右滑动
/// @param width 每个item的宽度
- (void)setScrollEnabledAndItemWidth:(CGFloat)width;
- (void)setScrollEnabledAndItemFitTextWidthWithSpacing:(CGFloat)spacing;
- (void)setScrollEnabledAndItemFitTextWidthWithSpacing:(CGFloat)spacing
                                              minWidth:(CGFloat)minWidth;


/// 设置tabItem的选中背景，这个背景可以是一个横条。
/// 此方法与setIndicatorWidthFixTextWithTop互斥，后调用着生效
/// @param insets 选中背景的insets
/// @param animated 点击item进行背景切换的时候，是否支持动画
- (void)setIndicatorInsets:(UIEdgeInsets)insets
         tapSwitchAnimated:(BOOL)animated;

/// 设置指示器的宽度根据title宽度来匹配
/// 此方法与setIndicatorInsets方法互斥，后调用者生效
/// @param top 指示器与tabItem顶部的距离
/// @param bottom 指示器与tabItem底部的距离
/// @param additional 指示器与文字宽度匹配后额外增加或减少的长度，0表示相等，正数表示较长，负数表示较短
/// @param animated 点击item进行背景切换的时候，是否支持动画
- (void)setIndicatorWidthFitTextAndMarginTop:(CGFloat)top
                                marginBottom:(CGFloat)bottom
                             widthAdditional:(CGFloat)additional
                           tapSwitchAnimated:(BOOL)animated;

/// 设置指示器固定宽度
/// @param width 指示器宽度
/// @param top 指示器与tabItem顶部的距离
/// @param bottom 指示器与tabItem底部的距离
/// @param animated 点击item进行背景切换的时候，是否支持动画
- (void)setIndicatorWidth:(CGFloat)width
                marginTop:(CGFloat)top
             marginBottom:(CGFloat)bottom
        tapSwitchAnimated:(BOOL)animated;

/// 当HHTabBar所属的HHTabbarController内容视图支持拖动切换时，此方法用于同步内容视图scrollView拖动的偏移量，以此来改变HHTabBar内控件的状态
/// @param scrollView <#scrollView description#>
- (void)updateSubViewsWhenParentScrollViewScroll:(UIScrollView *)scrollView;
@end

NS_ASSUME_NONNULL_END
