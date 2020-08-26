//
//  HHTabBar+Indicator.h
//  HHTabBarController
//
//  Created by 崔辉辉 on 2020/8/26.
//

#import <HHTabBarController/HHTabBarController.h>
#import "HHTabBar+IndicatorExt.h"
NS_ASSUME_NONNULL_BEGIN

@interface HHTabBar (Indicator)

/// item指示器颜色
@property (nonatomic, strong)UIColor *indicatorColor;
/// item指示器图像
@property (nonatomic, strong)UIImage *indicatorImage;
/// item指示器圆角
@property (nonatomic, assign)CGFloat indicatorCornerRadius;

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

- (void)updateItemIndicatorInsets;

/// 更新选中背景的frame
/// @param index <#index description#>
- (void)updateIndicatorFrameWithIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
