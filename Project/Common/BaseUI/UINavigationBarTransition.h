//
//  UINavigationBarTransition.h
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Transition)

+ (void)setDefaultNavBarShadowImageColor:(UIColor *)color;
+ (UIColor *)defaultNavBarShadowImageColor;
  
+ (void)setDefaultNavBarBarTintColor:(UIColor *)color;
+ (UIColor *)defaultNavBarBarTintColor;
  
+ (void)setDefaultNavBarTintColor:(UIColor *)color;
+ (UIColor *)defaultNavBarTintColor;
  
+ (void)setDefaultNavBarBackgroundAlpha:(CGFloat)alpha;
+ (CGFloat)defaultNavBarBackgroundAlpha;
  
+ (void)setDefaultStatusBarStyle:(UIStatusBarStyle)style;
+ (CGFloat)defaultStatusBarStyle;
  
@end

@interface UINavigationController (Transition)<UINavigationBarDelegate, UINavigationControllerDelegate>

@property(nonatomic,strong,readonly) UIPanGestureRecognizer *fullscreenPopGestureRecognizer;

- (void)setNeedsNavigationBarUpdateForShadowImageColor:(UIColor *)color;
- (void)setNeedsNavigationBarUpdateForBarTintColor:(UIColor *)color;
- (void)setNeedsNavigationBarUpdateForBarBackgroundAlpha:(CGFloat)alpha;
- (void)setNeedsNavigationBarUpdateForTintColor:(UIColor *)color;
- (void)setNeedsStatusBarUpdateForStyle:(UIStatusBarStyle)style;

@end

@interface UIViewController (Transition)

@property (nonatomic, assign) BOOL interactivePopDisabled;

- (void)setNavBarShadowImageColor:(UIColor *)color;
- (UIColor *)navBarShadowImageColor;
  
- (void)setNavBarBarTintColor:(UIColor *)color;
- (UIColor *)navBarBarTintColor;
  
- (void)setNavBarTintColor:(UIColor *)color;
- (UIColor *)navBarTintColor;
  
- (void)setNavBarBackgroundAlpha:(CGFloat)alpha;
- (CGFloat)navBarBackgroundAlpha;
  
- (void)setStatusBarStyle:(UIStatusBarStyle)style;
- (UIStatusBarStyle)statusBarStyle;

@end
