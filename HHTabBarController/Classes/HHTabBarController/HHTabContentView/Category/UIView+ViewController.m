//
//  UIView+ViewController.m
//  yyt-teacher
//
//  Created by apple on 2017/1/11.
//  Copyright © 2017年 ebsinori. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)
- (UIViewController *)viewController {
    UIResponder *responder = self.nextResponder;
    do {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
    } while (responder);
    return nil;
}
@end
