//
//  HHTabItem.h
//  HHTabBarController
//
//  Created by 崔辉辉 on 2019/11/15.
//  Copyright © 2019 huihui. All rights reserved.
//

#import <UIKit/UIKit.h>

/// badge样式
typedef NS_ENUM(NSUInteger, HHTabItemBadgeStyle) {
    HHTabItemBadgeStyleNumber = 0, // 数字样式
    HHTabItemBadgeStyleDot = 1, // 小圆点
};

NS_ASSUME_NONNULL_BEGIN

@interface HHTabItem : UIButton

/// title
@property (nonatomic, copy)NSString *title;
@property (nonatomic, strong)UIColor *titleColor;
@property (nonatomic, strong)UIColor *titleSelectedColor;
@property (nonatomic, strong)UIFont *titleFont;

@property (nonatomic, assign, readonly)CGFloat titleWidth;


/// 用于记录tabItme在缩放前的frame 在TabBar的属性itemFontChangeFollowContentScroll == YES时会用到
@property (nonatomic, assign, readonly)CGRect frameWithOutTransform;

/// 指示器
@property (nonatomic, assign)UIEdgeInsets indicatorInsets;
/// 指示器frame
@property (nonatomic, assign, readonly)CGRect indicatorFrame;

/// 显示badge的数值
@property (nonatomic, assign)NSInteger badge;
/// badge的样式
@property (nonatomic, assign)HHTabItemBadgeStyle badgeStyle;
/// badge的背景颜色
@property (nonatomic, strong)UIColor *badgeBackgroundColor;
/// badge的背景图片
@property (nonatomic, strong)UIImage *badgeBackgroundImage;
/// badge的标题颜色
@property (nonatomic, strong)UIColor *badgeTitleColor;
/// badge的标题字体
@property (nonatomic, strong)UIFont *badgeTitleFont;

/// 设置数字badge的位置
/// @param marginTop 与TabItem顶部的距离
/// @param centerMarginRight 中心与TabItem右侧的距离
/// @param titleHorizonalSpace 标题水平方向的空间
/// @param titleVerticalSpace 标题竖直方向的空间
- (void)setNumberBadgeMarginTop:(CGFloat)marginTop
              centerMarginRight:(CGFloat)centerMarginRight
            titleHorizonalSpace:(CGFloat)titleHorizonalSpace
             titleVerticalSpace:(CGFloat)titleVerticalSpace;

/// 设置小圆点badge的位置
/// @param marginTop 与TabItem顶部的距离
/// @param centerMarginRight 中心与TabItem右侧的距离
/// @param sideLength 小圆点的边长
- (void)setDotBadgeMarginTop:(CGFloat)marginTop
           centerMarginRight:(CGFloat)centerMarginRight
                   sideLenth:(CGFloat)sideLength;
@end

NS_ASSUME_NONNULL_END
