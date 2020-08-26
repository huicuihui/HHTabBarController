//
//  HHTabBarController.m
//  HHTabBarController
//
//  Created by 崔辉辉 on 2020/8/24.
//

#import "HHTabBarController.h"

@interface HHTabBarController ()
@property (nonatomic, strong)HHTabContentView *tabContentView;
@end

@implementation HHTabBarController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self _setup];
    }
    return self;
}
- (void)_setup
{
    _tabContentView = [[HHTabContentView alloc]init];
    _tabContentView.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tabContentView];
    [self.view addSubview:self.tabBar];
}

- (void)setTabBarFrame:(CGRect)tabBarFrame contentViewFrame:(CGRect)contentViewFrame
{
    if (self.tabContentView.headerView) return;
    self.tabBar.frame = tabBarFrame;
    self.tabContentView.frame = contentViewFrame;
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers
{
    self.tabContentView.viewControllers = viewControllers;
}

- (NSArray<UIViewController *> *)viewControllers
{
    return self.tabContentView.viewControllers;
}

- (HHTabBar *)tabBar
{
    return self.tabContentView.tabBar;
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
