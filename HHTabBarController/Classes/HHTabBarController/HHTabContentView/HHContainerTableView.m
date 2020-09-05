//
//  HHContainerTableView.m
//  HHTabBarController
//
//  Created by 崔辉辉 on 2020/9/3.
//

#import "HHContainerTableView.h"

@implementation HHContainerTableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
