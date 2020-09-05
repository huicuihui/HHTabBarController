//
//  HHTabContentWithHeaderView.m
//  HHTabBarController
//
//  Created by 崔辉辉 on 2020/9/2.
//

#import "HHTabContentWithHeaderView.h"

@interface HHTabContentWithHeaderView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) CGFloat headerViewDefaultHeight;
@property (nonatomic, assign) CGFloat tabBarStopOnTopHeight;

@property (nonatomic, strong, readwrite) UIView *headerView;
@property (nonatomic, strong) UITableViewCell *containerTableViewCell;
@property (nonatomic, assign) BOOL canChildScroll;
@property (nonatomic, assign) BOOL canContentScroll;
@property (nonatomic, assign) HHTabHeaderStyle headerStyle;
@property (nonatomic, strong) UIView *tabBarContainerView;
@end
@implementation HHTabContentWithHeaderView

#pragma mark - HeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectEqualToRect(frame, CGRectZero)) return;
    if (!self.headerView) {
        self.contentScrollView.frame = self.bounds;
    }
}
- (void)setHeaderView:(UIView *)headerView
                style:(HHTabHeaderStyle)style
         headerHeight:(CGFloat)headerHeight
         tabBarHeight:(CGFloat)tabBarHeight
tabBarStopOnTopHeight:(CGFloat)tabBarStopOnTopHeight
                frame:(CGRect)frame {
    if (!headerView) {
        return;
    }
    self.containHeader = YES;
    self.frame = frame;
    self.headerView = headerView;
    
    self.headerView.frame = CGRectMake(0, 0, self.bounds.size.width, headerHeight);
    
    self.headerStyle = style;
    self.headerViewDefaultHeight = headerHeight;
    self.tabBarStopOnTopHeight = tabBarStopOnTopHeight;
    
    [self.contentScrollView removeFromSuperview];
    
    self.containerTableView = [[HHContainerTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.containerTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.containerTableView.delegate = self;
    self.containerTableView.dataSource = self;
    
    if (style == HHTabHeaderStyleStretch) {
        UIView *view = [[UIView alloc] initWithFrame:self.headerView.bounds];
        self.containerTableView.tableHeaderView = view;
        [self.containerTableView addSubview:self.headerView];
    } else {
        self.containerTableView.tableHeaderView = self.headerView;
    }
    
    if (@available(iOS 11.0, *)) {
        self.containerTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self addSubview:self.containerTableView];
    
    self.contentScrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - tabBarHeight - self.tabBarStopOnTopHeight);
    self.containerTableViewCell = [[UITableViewCell alloc] init];
    [self.containerTableViewCell.contentView addSubview:self.contentScrollView];
    
    self.tabBarContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, tabBarHeight)];
    self.tabBar.frame = self.tabBarContainerView.bounds;
    [self.tabBar removeFromSuperview];
    [self.tabBarContainerView addSubview:self.tabBar];
    
    self.canContentScroll = YES;
    self.canChildScroll = NO;
}

- (void)containerTableViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.containerTableView) {
        return;
    }
    if (self.headerStyle == HHTabHeaderStyleNone) {
        self.containerTableView.contentOffset = CGPointZero;
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat stopY = self.headerViewDefaultHeight - self.tabBarStopOnTopHeight;
    if (!self.canContentScroll) {
        // 这里通过固定contentOffset的值，来实现不滚动
        self.containerTableView.contentOffset = CGPointMake(0, stopY);
    } else if (self.containerTableView.contentOffset.y >= stopY) {
        self.containerTableView.contentOffset = CGPointMake(0, stopY);
        self.canContentScroll = NO;
        self.canChildScroll = YES;
    }
    
    scrollView.showsVerticalScrollIndicator = !_canChildScroll;
    
    if (self.headerStyle == HHTabHeaderStyleStretch) {
        if (offsetY <= 0) {
            self.headerView.frame = CGRectMake(0,
                                               offsetY,
                                               self.headerView.frame.size.width,
                                               self.headerViewDefaultHeight - offsetY);
        }
    }
    if (self.headerDelegate && [self.headerDelegate respondsToSelector:@selector(tabContentView:didChangedContentOffsetY:)]) {
        [self.headerDelegate tabContentView:self didChangedContentOffsetY:scrollView.contentOffset.y];
    }
}

- (void)childScrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.headerStyle == HHTabHeaderStyleNone) {
        self.containerTableView.contentOffset = CGPointZero;
        return;
    }
    if (!self.canChildScroll) {
        self.selectedController.hh_scrollView.contentOffset = CGPointZero;
    } else if (self.selectedController.hh_scrollView.contentOffset.y <= 0) {
        self.selectedController.hh_scrollView.contentOffset = CGPointZero;
        self.canChildScroll = NO;
        self.canContentScroll = YES;
        for (UIViewController *vc in self.viewControllers) {
            if (vc.isViewLoaded) {
                vc.hh_scrollView.contentOffset = CGPointZero;
            }
        }
    }
    scrollView.showsVerticalScrollIndicator = _canChildScroll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.containerTableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.contentScrollView.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.tabBarContainerView.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.tabBarContainerView;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
