//
//  HHTabBar+Item.h
//  HHTabBarController
//
//  Created by 崔辉辉 on 2020/8/26.
//

#import <HHTabBarController/HHTabBarController.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHTabBar (Item)
/// 标题颜色
@property (nonatomic, strong)UIColor *itemTitleColor;
/// 选中时标题的颜色
@property (nonatomic, strong)UIColor *itemTitleSelectedColor;
/// 标题字体
@property (nonatomic, strong)UIFont *itemTitleFont;
/// 选中时标题的字体
@property (nonatomic, strong)UIFont *itemTitleSelectedFont;

/// item是否匹配title的文字宽度
@property (nonatomic, assign)BOOL itemFitTextWidth;

@end

NS_ASSUME_NONNULL_END
