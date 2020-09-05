//
//  HHTabContentWithHeaderView.h
//  HHTabBarController
//
//  Created by 崔辉辉 on 2020/9/2.
//

#import "HHTabContentView.h"
#import "HHContainerTableView.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, HHTabHeaderStyle) {
    HHTabHeaderStyleStretch,
    HHTabHeaderStyleFollow,
    HHTabHeaderStyleNone//header固定
};

@class HHTabContentWithHeaderView;

@protocol HHTabContentHeaderViewDelegate <NSObject>
@optional
/// 内容视图竖向滚动时的y坐标偏移量
/// @param tabContentWithHeaderView <#tabContentWithHeaderView description#>
/// @param offsetY <#offsetY description#>
- (void)tabContentView:(HHTabContentWithHeaderView *)tabContentWithHeaderView didChangedContentOffsetY:(CGFloat)offsetY;
@end

@interface HHTabContentWithHeaderView : HHTabContentView
@property (nonatomic, strong, readonly) UIView *headerView;
@property (nonatomic, strong) HHContainerTableView *containerTableView;

@property (nonatomic, weak)id <HHTabContentHeaderViewDelegate> headerDelegate;

/**
 *  设置HeaderView
 *  @param headerView UIView
 *  @param style 头部拉伸样式
 *  @param headerHeight headerView的默认高度
 *  @param tabBarHeight tabBar的高度
 *  @param tabBarStopOnTopHeight 当内容视图向上滚动时，TabBar停止移动的位置
 *  @param frame 整个界面的frame，一般来说是[UIScreen mainScreen].bounds
 */
- (void)setHeaderView:(UIView *)headerView
                style:(HHTabHeaderStyle)style
         headerHeight:(CGFloat)headerHeight
         tabBarHeight:(CGFloat)tabBarHeight
tabBarStopOnTopHeight:(CGFloat)tabBarStopOnTopHeight
                frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
