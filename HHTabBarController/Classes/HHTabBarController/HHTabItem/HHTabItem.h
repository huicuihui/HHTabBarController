//
//  HHTabItem.h
//  HHTabBarController
//
//  Created by 崔辉辉 on 2019/11/15.
//  Copyright © 2019 huihui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHTabItem : UIButton

/// title
@property (nonatomic, copy)NSString *title;
@property (nonatomic, strong)UIColor *titleColor;
@property (nonatomic, strong)UIColor *titleSelectedColor;
@property (nonatomic, strong)UIFont *titleFont;

@property (nonatomic, assign, readonly)CGFloat titleWidth;


/// 用于记录tabItme在缩放前的frame 在TabBar的属性itemFontChangeFollowContentScroll == YES时会用到
@property (nonatomic, assign, readonly)CGRect frameWithOutTransform;

/// 指示器
@property (nonatomic, assign)UIEdgeInsets indicatorInsets;
/// 指示器frame
@property (nonatomic, assign, readonly)CGRect indicatorFrame;

@end

NS_ASSUME_NONNULL_END
