//
//  HHTabViewController.m
//  HHTabBarController_Example
//
//  Created by 崔辉辉 on 2020/8/25.
//  Copyright © 2020 805988356@qq.com. All rights reserved.
//

#import "HHTabViewController.h"
#import <HHTabBarHeader.h>
@interface HHTabViewController ()

@end

@implementation HHTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
    CGFloat barHeight = 40, buttonWidth = 40;;
    [self setTabBarFrame:CGRectMake(0, 88, [UIScreen mainScreen].bounds.size.width - buttonWidth, barHeight)
        contentViewFrame:CGRectMake(0, 88 + barHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 88 - barHeight - 49)];
    
    self.tabBar.itemTitleColor = [UIColor redColor];
    self.tabBar.itemTitleSelectedColor = [UIColor blueColor];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:15];
    self.tabBar.itemTitleSelectedFont = [UIFont boldSystemFontOfSize:15];

    self.tabBar.backgroundColor = [UIColor whiteColor];
//    self.loadViewOfChildContollerWhileAppear = YES;
//    [self setContentScrollEnabled:YES tapSwitchAnimated:YES];
    
    self.tabBar.indicatorScrollFollowContent = YES;
    self.tabBar.indicatorColor = [UIColor orangeColor];
//    self.tabBar.indicatorAnimationStyle = YPTabBarIndicatorAnimationStyle2;
    self.tabBar.indicatorCornerRadius = 2.0;
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:30];
    
    [self initViewControllers];
//    [self.tabContentView setSelectedTabIndex:1];
    [self setBadge];
}
- (void)initViewControllers
{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:0];
    for (int i  = 0; i < 7; i++) {
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = [UIColor orangeColor];
        [viewControllers addObject:vc];
        vc.tabItemTitle = [NSString stringWithFormat:@"栏目%d",i];
    }
    self.viewControllers = viewControllers;
}

- (void)setBadge
{
    for (UIViewController *vc in self.viewControllers) {
        //badge
        HHBadgeButton *badgeButton = vc.tabItem.badgeButton;
        badgeButton.badgeStyle = HHTabItemBadgeStyleNumber;
        badgeButton.badgeTitleFont = [UIFont boldSystemFontOfSize:11];
        badgeButton.badge = 35;
        badgeButton.badgeBackgroundColor = [UIColor cyanColor];
        badgeButton.badgeTitleColor = [UIColor blueColor];
        [badgeButton setNumberBadgeMarginTop:0 centerMarginRight:0 titleHorizonalSpace:5 titleVerticalSpace:0];
    }
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
