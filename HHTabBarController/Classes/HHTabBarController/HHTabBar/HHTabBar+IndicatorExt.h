//
//  HHTabBar+IndicatorExt.h
//  HHTabBarController
//
//  Created by 崔辉辉 on 2020/8/26.
//

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, HHTabBarIndicatorStyle) {
    HHTabBarIndicatorStyleFitItem,
    HHTabBarIndicatorStyleFitTitle,
    HHTabBarIndicatorStyleFixedWidth,
};
typedef NS_ENUM(NSInteger, HHTabBarIndicatorAnimationStyle) {
    HHTabBarIndicatorAnimationStyleDefault = 0,
};
@interface HHTabBar ()
/// 选中背景
@property (nonatomic, strong)UIImageView *indicatorImageView;
@property (nonatomic, assign)HHTabBarIndicatorStyle indicatorStyle;
/// 指示器动画
@property (nonatomic, assign)HHTabBarIndicatorAnimationStyle indicatorAnimationStyle;
@property (nonatomic, assign)UIEdgeInsets indicatorInsets;
@property (nonatomic, assign)CGFloat indicatorWidth;
@property (nonatomic, assign)CGFloat indicatorWidthFixTitleAdditional;
@end

NS_ASSUME_NONNULL_END
