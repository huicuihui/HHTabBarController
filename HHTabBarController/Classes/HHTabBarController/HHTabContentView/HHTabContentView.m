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
{
    CGFloat _lastContentScrollViewOffsetX;
}
@property (nonatomic, strong)HHTabContentScrollView *contentScrollView;

@property (nonatomic, assign)BOOL isDefaultSelectedTabIndexSetuped;

@property (nonatomic, assign)BOOL contentScrollEnabled;
@property (nonatomic, assign)BOOL contentSwitchAnimated;
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
    self.contentSwitchAnimated = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    _tabBar = [[HHTabBar alloc]init];
    _tabBar.delegate = self;
    
    _contentScrollView = [[HHTabContentScrollView alloc]initWithFrame:self.bounds];
    _contentScrollView.delegate = self;
    _contentScrollView.hh_delegete = self;
    _contentScrollView.interceptRightSlideGuetureInFirstPage = self.interceptRightSlideGuetureInFirstPage;
    _contentScrollView.interceptLeftSlideGuetureInLastPage = self.interceptLeftSlideGuetureInLastPage;
    [self addSubview:_contentScrollView];
    
    //设置_selectedTabIndex为NSNotFound，否则在tabBar代理方法didSelectedItemAtIndex里，会不显示默认的第一个view。
    _selectedTabIndex = NSNotFound;
    _defaultSelectedTabIndex = 0;
    _isDefaultSelectedTabIndexSetuped = NO;
}

- (void)setTabBar:(HHTabBar *)tabBar
{
    _tabBar = tabBar;
    _tabBar.delegate = self;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectEqualToRect(frame, CGRectZero)) return;
    if (!self.headerView) {
        self.contentScrollView.frame = self.bounds;
    }
    [self updateContentViewsFrame];
}
- (void)setViews:(NSArray *)views
{
    NSMutableArray *tempViews = [NSMutableArray arrayWithCapacity:0];
    for (int index = 0; index < views.count; index++) {
        UIView *subV = views[index];
        subV.frame = [self frameAtIndex:index];
        [self.contentScrollView addSubview:subV];
        [tempViews addObject:subV];
    }
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.bounds.size.width * views.count, 0);
    _views = tempViews;
}
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers
{
    for (UIViewController *vc in viewControllers) {
        [vc removeFromParentViewController];
        if (vc.isViewLoaded) [vc.view removeFromSuperview];
    }
    
    _viewControllers = [viewControllers copy];
    
    UIViewController *containerVC = [self viewController];
    NSMutableArray *items = [NSMutableArray array];
    for (UIViewController *vc in _viewControllers) {
        if (containerVC) {
            [containerVC addChildViewController:vc];
        }
        
        HHTabItemBadge *item = [HHTabItemBadge buttonWithType:UIButtonTypeCustom];
        item.title = vc.tabItemTitle;
        [items addObject:item];
    }
    self.tabBar.items = items;
    
    //更新scrollView的contentSize
    if (self.contentScrollEnabled) {
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.bounds.size.width * _viewControllers.count, self.contentScrollView.bounds.size.height);
    }
    if (self.isDefaultSelectedTabIndexSetuped) {
        _selectedTabIndex = NSNotFound;
        self.tabBar.selectedItemIndex = 0;
    }
}

- (void)setContentScrollEnabled:(BOOL)enabled tapSwitchAnimated:(BOOL)animated {
    if (!self.contentScrollEnabled && enabled) {
        self.contentScrollEnabled = enabled;
        [self updateContentViewsFrame];
    }
    self.contentScrollView.scrollEnabled = enabled;
    self.contentSwitchAnimated = animated;
}

- (void)updateContentViewsFrame
{
    if (self.contentScrollEnabled) {
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.bounds.size.width * self.viewControllers.count, self.contentScrollView.bounds
                                                        .size.height);
        [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isViewLoaded) obj.view.frame = [self frameAtIndex:idx];
        }];
        [self.contentScrollView scrollRectToVisible:self.selectedController.view.frame animated:YES];
    } else {
        self.contentScrollView.contentSize = self.contentScrollView.bounds.size;
        self.selectedController.view.frame = self.contentScrollView.bounds;
    }
}

- (CGRect)frameAtIndex:(NSUInteger)index
{
    return CGRectMake(index * self.contentScrollView.bounds.size.width, 0, self.contentScrollView.bounds.size.width, self.contentScrollView.bounds.size.height);
}

- (void)setInterceptRightSlideGuetureInFirstPage:(BOOL)interceptRightSlideGuetureInFirstPage {
    _interceptRightSlideGuetureInFirstPage = interceptRightSlideGuetureInFirstPage;
    self.contentScrollView.interceptRightSlideGuetureInFirstPage = interceptRightSlideGuetureInFirstPage;
}
- (void)setInterceptLeftSlideGuetureInLastPage:(BOOL)interceptLeftSlideGuetureInLastPage {
    _interceptLeftSlideGuetureInLastPage = interceptLeftSlideGuetureInLastPage;
    self.contentScrollView.interceptLeftSlideGuetureInLastPage = interceptLeftSlideGuetureInLastPage;
}

- (void)setSelectedTabIndex:(NSUInteger)selectedTabIndex
{
    self.tabBar.selectedItemIndex = selectedTabIndex;
}
- (UIViewController *)selectedController
{
    if (self.selectedTabIndex != NSNotFound) return self.viewControllers[self.selectedTabIndex];
    return nil;
}
#pragma mark - HHTabBarDelegate
- (BOOL)hh_tabBar:(HHTabBar *)tabBar shouldSelectItemAtIndex:(NSUInteger)index
{
    return [self shouldSelectItemAtIndex:index];
}
- (void)hh_tabBar:(HHTabBar *)tabBar willSelectItemAtIndex:(NSUInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabContentView:willSelectTabAtIndex:)]) {
        [self.delegate tabContentView:self willSelectTabAtIndex:index];
    }
}
- (void)hh_tabBar:(HHTabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index
{
    if (index == self.selectedTabIndex) return;
    UIViewController *oldController = nil;
    if (self.selectedTabIndex != NSNotFound) {
        oldController = self.viewControllers[self.selectedTabIndex];
        [oldController hh_tabItemDidDeselected];
        if ([oldController respondsToSelector:@selector(tabItemDidDeselected)]) {
            [oldController performSelector:@selector(tabItemDidDeselected)];
        }
        if (!self.contentScrollEnabled ||
            (self.contentScrollEnabled && self.removeViewOfChildContollerWhileDeselected)) {
            [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *_Nonnull controller, NSUInteger idx, BOOL *_Nonnull stop) {
                if (idx != index && controller.isViewLoaded && controller.view.superview) {
                    [controller.view removeFromSuperview];
                }
            }];
        }
    }
    UIViewController *curController = self.viewControllers[index];
    if (self.contentScrollEnabled) {
        // contentView支持滚动
        curController.view.frame = [self frameAtIndex:index];
        [self.contentScrollView addSubview:curController.view];
        // 切换到curController
        [self.contentScrollView scrollRectToVisible:curController.view.frame animated:self.contentSwitchAnimated];
    } else {
        // contentView不支持滚动
        // 设置curController.view的frame
        curController.view.frame = self.contentScrollView.bounds;
        [self.contentScrollView addSubview:curController.view];
    }
    
//    if (self.headerView && !curController.yp_scrollView.yp_didScrollHandler) {
//        __weak YPTabContentView *weakSelf = self;
//        curController.yp_scrollView.yp_didScrollHandler = ^(UIScrollView *scrollView) {
//            __strong YPTabContentView *strongSelf = weakSelf;
//            [strongSelf childScrollViewDidScroll:scrollView];
//        };
//    }

//    // 获取是否是第一次被选中的标识
//
//    if (curController.yp_hasBeenDisplayed) {
//        [curController yp_tabItemDidSelected:NO];
//    } else {
//        [curController yp_tabItemDidSelected:YES];
//        curController.yp_hasBeenDisplayed = YES;
//    }

    if ([curController respondsToSelector:@selector(tabItemDidSelected)]) {
        [curController performSelector:@selector(tabItemDidSelected)];
    }

    // 当contentView为scrollView及其子类时，设置它支持点击状态栏回到顶部
    if (oldController && [oldController.view isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView *) oldController.view setScrollsToTop:NO];
    }
    if ([curController.view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *curScrollView = (UIScrollView *) curController.view;
        [curScrollView setScrollsToTop:YES];
    }

    _selectedTabIndex = index;

    if (self.delegate && [self.delegate respondsToSelector:@selector(tabContentView:didSelectedTabAtIndex:)]) {
        [self.delegate tabContentView:self didSelectedTabAtIndex:index];
    }
}
//{
////    [self.contentScrollView scrollRectToVisible:[self frameAtIndex:index] animated:YES];
//    [self.contentScrollView setContentOffset:CGPointMake(self.contentScrollView.bounds.size.width * index, 0) animated:YES];
//}

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
    if (offsetX < 0) return;
    if (offsetX > scrollView.contentSize.width - scrollViewWidth) return;
    
    NSUInteger leftIndex = offsetX / scrollViewWidth;
    NSUInteger rightIndex = leftIndex + 1;
    
    // 处理shouldSelectItemAtIndex方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabContentView:shouldSelectTabAtIndex:)] && !scrollView.isDecelerating) {
        NSUInteger targetIndex;
        if (_lastContentScrollViewOffsetX < (CGFloat)offsetX) {
            // 向左
            targetIndex = rightIndex;
        } else {
            // 向右
            targetIndex = leftIndex;
        }
        if (targetIndex != self.selectedTabIndex) {
            if (![self shouldSelectItemAtIndex:targetIndex]) {
                [scrollView setContentOffset:CGPointMake(self.selectedTabIndex * scrollViewWidth, 0) animated:NO];
            }
        }
    }
    _lastContentScrollViewOffsetX = offsetX;

    // 刚好处于能完整显示一个child view的位置
    if (leftIndex == offsetX / scrollViewWidth) {
        rightIndex = leftIndex;
    }
    // 将需要显示的child view放到scrollView上
    for (NSUInteger index = leftIndex; index <= rightIndex; index++) {
        UIViewController *controller = self.viewControllers[index];
        if (!controller.isViewLoaded && self.loadViewOfChildControllerWhileAppear) {
            CGRect frame = [self frameAtIndex:index];
            controller.view.frame = frame;
        }
        if (controller.isViewLoaded && !controller.view.superview) {
            [self.contentScrollView addSubview:controller.view];
        }
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
