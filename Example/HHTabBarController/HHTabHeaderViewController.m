//
//  HHTabHeaderViewController.m
//  HHTabBarController_Example
//
//  Created by 崔辉辉 on 2020/9/2.
//  Copyright © 2020 805988356@qq.com. All rights reserved.
//

#import "HHTabHeaderViewController.h"
#import <HHTabBarHeader.h>
#import "HHTableViewController.h"
@interface HHTabHeaderViewController ()

@end

@implementation HHTabHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabContentView.interceptRightSlideGuetureInFirstPage = YES;
    
    self.tabBar.itemTitleColor = [UIColor lightGrayColor];
    self.tabBar.itemTitleSelectedColor = [UIColor redColor];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:17];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:22];
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    
    self.tabBar.indicatorScrollFollowContent = YES;
    self.tabBar.indicatorColor = [UIColor redColor];
    [self.tabBar setIndicatorInsets:UIEdgeInsetsMake(40, 10, 0, 10) tapSwitchAnimated:NO];
    
//    self.yp_tabItem.badgeStyle = YPTabItemBadgeStyleDot;
//
//    self.tabContentView.loadViewOfChildContollerWhileAppear = YES;
//
//    [self.tabContentView setContentScrollEnabledAndTapSwitchAnimated:NO];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"headerimg" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    
    CGFloat bottom = 0;
    if (screenSize.height == 812) {
        bottom += 34;
    }
//    if ([self.parentViewController isKindOfClass:[YPTabBarController class]]) {
//    }
    bottom += 50;
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= bottom;
    [self.tabContentView setHeaderView:imageView
                                 style:HHTabHeaderStyleNone
                          headerHeight:250
                          tabBarHeight:44
                 tabBarStopOnTopHeight:120
                                 frame:frame];
        
    [self initViewControllers];
    [self.tabContentView setSelectedTabIndex:0];
}
- (void)initViewControllers {
    HHTableViewController *controller1 = [[HHTableViewController alloc] init];
    controller1.tabItemTitle = @"第一个";
    
    HHTableViewController *controller2 = [[HHTableViewController alloc] init];
    controller2.tabItemTitle = @"第二";
    
    HHTableViewController *controller3 = [[HHTableViewController alloc] init];
    controller3.tabItemTitle = @"第三个";
//    controller3.numberOfRows = 5;
    
    HHTableViewController *controller4 = [[HHTableViewController alloc] init];
    controller4.tabItemTitle = @"第四";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, controller4, nil];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
