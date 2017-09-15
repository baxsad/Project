//
//  UINavigationBarTransition.h
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Transition)

+ (void)setDefaultNavBarHidden:(BOOL)hidden;
+ (BOOL)defaultNavBarHidden;

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

@interface UINavigationController (Transition)

@property(nonatomic,strong,readonly) UIPanGestureRecognizer *fullscreenPopGestureRecognizer;
- (UIColor *)containerViewBackgroundColor;
@property (nonatomic, weak) UIViewController *transitionContextToViewController;

@end

@interface UIViewController (Transition)

@property (nonatomic, assign) BOOL interactivePopDisabled;
@property (nonatomic, strong) UINavigationBar *transitionNavigationBar;
@property (nonatomic, assign) BOOL prefersNavigationBarBackgroundViewHidden;
- (void)addTransitionNavigationBarIfNeeded;

- (void)setNavBarHidden:(BOOL)hidden animation:(BOOL)animation;
- (BOOL)navBarHidden;

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

- (void)setNeedsNavigationBarUpdateForShadowImageColor:(UIColor *)color real:(BOOL)real;
- (void)setNeedsNavigationBarUpdateForBarTintColor:(UIColor *)color real:(BOOL)real;
- (void)setNeedsNavigationBarUpdateForBarBackgroundAlpha:(CGFloat)alpha real:(BOOL)real;
- (void)setNeedsNavigationBarUpdateForTintColor:(UIColor *)color real:(BOOL)real;
- (void)setNeedsStatusBarUpdateForStyle:(UIStatusBarStyle)style animation:(BOOL)animation;

@end
