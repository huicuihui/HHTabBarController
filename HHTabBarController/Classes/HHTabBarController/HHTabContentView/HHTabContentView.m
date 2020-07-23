//
//  HHTabContentView.m
//  HHTabBarController
//
//  Created by 崔辉辉 on 2019/11/21.
//  Copyright © 2019 huihui. All rights reserved.
//

#import "HHTabContentView.h"
#import "HHTabContentScrollView.h"
#import "UIView+ViewController.h"
@interface HHTabContentView()<HHTabBarDelegate,UIScrollViewDelegate,HHTabContentScrollViewDelegate>
@property (nonatomic, strong)HHTabContentScrollView *contentScrollView;

@property (nonatomic, assign)BOOL contentScrollEnabled;

@end
@implementation HHTabContentView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}
- (void)_setup
{
    self.contentScrollEnabled = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
//    _tabBar = [[HHTabBar alloc]init];
//    _tabBar.delegate = self;
    
    _contentScrollView = [[HHTabContentScrollView alloc]initWithFrame:self.bounds];
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.scrollEnabled = YES;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.scrollsToTop = NO;
    _contentScrollView.delegate = self;
    _contentScrollView.hh_delegete = self;
    _contentScrollView.backgroundColor = [UIColor redColor];
    [self addSubview:_contentScrollView];
    
    _defaultSelectedTabIndex = 0;
}

- (void)setTabBar:(HHTabBar *)tabBar
{
    _tabBar = tabBar;
    _tabBar.delegate = self;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectEqualToRect(frame, CGRectZero)) {
        return;
    }
    if (!self.headerView) {
        self.contentScrollView.frame = self.bounds;
    }
    [self updateContentViewsFrame];
}
- (void)setSubViews:(NSArray *)subViews
{
    NSMutableArray *tempViews = [NSMutableArray arrayWithCapacity:0];
    for (int index = 0; index < subViews.count; index++) {
        UIView *subV = subViews[index];
        subV.frame = [self frameAtIndex:index];
        [self.contentScrollView addSubview:subV];
        [tempViews addObject:subV];
    }
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.bounds.size.width * subViews.count, 0);
    _subViews = tempViews;
}
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers
{
    for (UIViewController *vc in viewControllers) {
        [vc removeFromParentViewController];
        if (vc.isViewLoaded) {
            [vc.view removeFromSuperview];
        }
    }
    
    _viewControllers = [viewControllers copy];
    
    UIViewController *containerVC = [self viewController];
    for (UIViewController *vc in _viewControllers) {
        if (containerVC) {
            [containerVC addChildViewController:vc];
        }
    }
    
    //更新scrollView的contentSize
    if (self.contentScrollEnabled) {
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.bounds.size.width * _viewControllers.count, self.contentScrollView.bounds.size.height);
    }
}
- (void)updateContentViewsFrame
{
//    if (self.contentScrollEnabled) {
//        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.bounds.size.width * self.viewControllers.count, self.contentScrollView.bounds
//                                                        .size.height);
//        [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (obj.isViewLoaded) {
//                obj.view.frame = [self frameAtIndex:idx];
//            }
//        }];
//        [self.contentScrollView scrollRectToVisible:<#(CGRect)#> animated:<#(BOOL)#>]
//    } else {
//        <#statements#>
//    }
}

- (CGRect)frameAtIndex:(NSUInteger)index
{
    return CGRectMake(index * self.contentScrollView.bounds.size.width, 0, self.contentScrollView.bounds.size.width, self.contentScrollView.bounds.size.height);
}

- (void)setSelectedTabIndex:(NSUInteger)selectedTabIndex
{
    self.tabBar.selectedItemIndex = selectedTabIndex;
}

#pragma mark - HHTabBarDelegate
- (BOOL)hh_tabBar:(HHTabBar *)tabBar shouldSelectItemAtIndex:(NSUInteger)index
{
    return [self shouldSelectItemAtIndex:index];
}
- (void)hh_tabBar:(HHTabBar *)tabBar willSelectItemAtIndex:(NSUInteger)index
{
}
- (void)hh_tabBar:(HHTabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index
{
//    [self.contentScrollView scrollRectToVisible:[self frameAtIndex:index] animated:YES];
    [self.contentScrollView setContentOffset:CGPointMake(self.contentScrollView.bounds.size.width * index, 0) animated:YES];
}

#pragma mark - HHTabContentScrollViewDelegate
- (BOOL)scrollView:(HHTabContentScrollView *)scrollView shouldScrollToPageIndex:(NSUInteger)index
{
    return [self shouldSelectItemAtIndex:index];
}
- (BOOL)shouldSelectItemAtIndex:(NSUInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabContentView:shouldSelectTabAtIndex:)]) {
        return [self.delegate tabContentView:self shouldSelectTabAtIndex:index];
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.contentScrollView) {
        NSUInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
        self.tabBar.selectedItemIndex = page;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //滑动越界不处理
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat scrollViewWidth = scrollView.frame.size.width;
    if (offsetX < 0) {
        return;
    }
    if (offsetX > scrollView.contentSize.width - scrollViewWidth) {
        return;
    }
    
    NSUInteger leftIndex = offsetX / scrollViewWidth;
    NSUInteger rightIndex = leftIndex + 1;
    
    //处理shouldSelectItemAtIndex方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabContentView:shouldSelectTabAtIndex:)] && !scrollView.isDecelerating) {
        NSUInteger targetIndex;
        
    }
    // 同步修改tabBar的子视图状态
    [self.tabBar updateSubViewsWhenParentScrollViewScroll:self.contentScrollView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
