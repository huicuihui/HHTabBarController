//
//  HHTabViewsController.m
//  HHTabBarController_Example
//
//  Created by 崔辉辉 on 2021/4/12.
//  Copyright © 2021 805988356@qq.com. All rights reserved.
//

#import "HHTabViewsController.h"
#import <HHTabBarHeader.h>

@interface HHTabViewsController ()<HHTabBarDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation HHTabViewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
    
    NSArray *array = @[@"带回家",@"反倒是",@"北方的",@"发的",@"更好",@"反倒是",@"北方的",@"发的",@"更好",@"反倒是",@"北方的",@"发的",@"更好"];
    HHTabBar *tabBar = [[HHTabBar alloc]initWithFrame:CGRectMake(20, 100, 300, 40)];
    tabBar.backgroundColor = [UIColor lightGrayColor];
    tabBar.indicatorColor = [UIColor purpleColor];
    tabBar.indicatorSwitchAnimated = YES;
    tabBar.indicatorCornerRadius = 20.0;
    tabBar.itemTitleColor = [UIColor cyanColor];
    tabBar.itemTitleSelectedColor = [UIColor blueColor];
    tabBar.itemTitleFont = [UIFont systemFontOfSize:14];
    tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:14];
    tabBar.layer.cornerRadius = 20.0;
    tabBar.delegate = self;
    //这个要在setTitles前面设置
    [tabBar setScrollEnabledAndItemWidth:110];
    [tabBar setTitles:array];
    //这个要在setTitles后面设置
//    tabBar.selectedItemIndex = 0;
    tabBar.itemFontChangeFollowContentScroll = YES;
    tabBar.indicatorScrollFollowContent = YES;
    tabBar.indicatorAnimationStyle = HHTabBarIndicatorAnimationStyleDefault;
    [self.view addSubview:tabBar];
    [tabBar setIndicatorInsets:UIEdgeInsetsMake(35, 0, 0, 0) tapSwitchAnimated:YES];

    
    HHTabContentView *cv = [[HHTabContentView alloc]initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, 300)];
    cv.backgroundColor = [UIColor cyanColor];
    cv.tabBar = tabBar;
    [self.view addSubview:cv];
    NSMutableArray *vs = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < array.count; i++) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.tag = i;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [vs addObject:tableView];
    }
    cv.views = vs;
    cv.selectedTabIndex = 1;//设置了这个 前面就不要设置tabBar.selectedItemIndex了。
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSArray *array = @[@"带回家",@"反倒是",@"北方的",@"发的",@"更好",@"反倒是",@"北方的",@"发的",@"更好",@"反倒是",@"北方的",@"发的",@"更好"];

    cell.textLabel.text = array[tableView.tag];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (BOOL)hh_tabBar:(HHTabBar *)tabBar shouldSelectItemAtIndex:(NSUInteger)index {
    return YES;
}
- (void)hh_tabBar:(HHTabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index {
    NSLog(@"\n选中下标：%ld",index);
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
