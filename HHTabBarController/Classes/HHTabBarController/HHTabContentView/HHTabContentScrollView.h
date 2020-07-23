//
//  HHTabContentScrollView.h
//  HHTabBarController
//
//  Created by 崔辉辉 on 2019/12/23.
//  Copyright © 2019 huihui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HHTabContentScrollView;
@protocol HHTabContentScrollViewDelegate <NSObject>

@optional

- (BOOL)scrollView:(HHTabContentScrollView *)scrollView
shouldScrollToPageIndex:(NSUInteger)index;

@end

@interface HHTabContentScrollView : UIScrollView
@property (nonatomic, weak) id <HHTabContentScrollViewDelegate> hh_delegete;

@property (nonatomic, assign)BOOL interceptLeftSlideGuetureInLastPage;
@property (nonatomic, assign)BOOL interceptRightSlideGuetureInFirstPage;

@end

NS_ASSUME_NONNULL_END
