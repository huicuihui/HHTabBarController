//
//  HHTabBarController.h
//  HHTabBarController
//
//  Created by 崔辉辉 on 2020/8/24.
//

#import <UIKit/UIKit.h>
#import <HHTabContentWithHeaderView.h>
#import <HHTabBarControllerProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHTabBarController : UIViewController<HHTabBarControllerProtocol,HHTabContentViewDelegate>

- (void)setTabBarFrame:(CGRect)tabBarFrame
      contentViewFrame:(CGRect)contentViewFrame;

@end

NS_ASSUME_NONNULL_END
