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

#import "UIView+ViewController.h"
#import "UIViewController+HHTab.h"
#import "HHTabBar+Indicator.h"
#import "HHTabBar+IndicatorExt.h"
#import "HHTabBar+Item.h"
#import "HHTabBar.h"
#import "HHTabBarController.h"
#import "HHTabBarControllerProtocol.h"
#import "HHTabBarHeader.h"
#import "HHTabContentScrollView.h"
#import "HHTabContentView.h"
#import "HHTabItem.h"
#import "HHTabItemBadge.h"

FOUNDATION_EXPORT double HHTabBarControllerVersionNumber;
FOUNDATION_EXPORT const unsigned char HHTabBarControllerVersionString[];

