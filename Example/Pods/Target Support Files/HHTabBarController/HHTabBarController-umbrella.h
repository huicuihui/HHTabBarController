#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "HHTabBar.h"
#import "HHTabItem.h"
#import "UIView+ViewController.h"
#import "UIViewController+HHTab.h"
#import "HHTabContentScrollView.h"
#import "HHTabContentView.h"

FOUNDATION_EXPORT double HHTabBarControllerVersionNumber;
FOUNDATION_EXPORT const unsigned char HHTabBarControllerVersionString[];

