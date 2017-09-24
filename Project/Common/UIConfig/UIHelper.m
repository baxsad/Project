//
//  UIHelper.m
//  Project
//
//  Created by pmo on 2017/9/24.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "UIHelper.h"
#import "UIScene.h"
#import "UIColor+UIConfig.h"
#import <objc/runtime.h>

@implementation UIHelper (Theme)

+ (UIImage *)navigationBarBackgroundImageWithThemeColor:(UIColor *)color {
  CGSize size = CGSizeMake(4, 88);// 适配 iPhone X
  UIImage *resultImage = nil;
  color = color ? color : UIColorClear;
  
  UIGraphicsBeginImageContextWithOptions(size, YES, 0);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGGradientRef gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), (CFArrayRef)@[(id)color.CGColor, (id)[color ui_colorWithAlphaAddedToWhite:.86].CGColor], NULL);
  CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(0, size.height), kCGGradientDrawsBeforeStartLocation);
  
  resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  CGGradientRelease(gradient);
  return [resultImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)];
}

@end

@implementation UIHelper (ViewController)
+ (nullable UIViewController *)visibleViewController {
  UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  UIViewController *visibleViewController = [rootViewController visibleViewControllerIfExist];
  return visibleViewController;
}
@end

@implementation UIHelper (UIApplication)
+ (void)renderStatusBarStyleDark {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
#pragma clang diagnostic pop
}

+ (void)renderStatusBarStyleLight {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
#pragma clang diagnostic pop
}

+ (void)dimmedApplicationWindow {
  UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
  window.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
  [window tintColorDidChange];
}

+ (void)resetDimmedApplicationWindow {
  UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
  window.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
  [window tintColorDidChange];
}
@end

@implementation UIHelper (Keyboard)

- (void)handleKeyboardWillShow:(NSNotification *)notification {
  self.keyboardVisible = YES;
  self.lastKeyboardHeight = [UIHelper keyboardHeightWithNotification:notification];
}

- (void)handleKeyboardWillHide:(NSNotification *)notification {
  self.keyboardVisible = NO;
}

static char kAssociatedObjectKey_KeyboardVisible;
- (void)setKeyboardVisible:(BOOL)argv {
  objc_setAssociatedObject(self, &kAssociatedObjectKey_KeyboardVisible, @(argv), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isKeyboardVisible {
  return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_KeyboardVisible)) boolValue];
}

+ (BOOL)isKeyboardVisible {
  BOOL visible = [[UIHelper sharedInstance] isKeyboardVisible];
  return visible;
}

static char kAssociatedObjectKey_LastKeyboardHeight;
- (void)setLastKeyboardHeight:(CGFloat)argv {
  objc_setAssociatedObject(self, &kAssociatedObjectKey_LastKeyboardHeight, @(argv), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)lastKeyboardHeight {
  return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_LastKeyboardHeight)) floatValue];
}

+ (CGFloat)lastKeyboardHeightInApplicationWindowWhenVisible {
  return [[UIHelper sharedInstance] lastKeyboardHeight];
}

+ (CGRect)keyboardRectWithNotification:(NSNotification *)notification {
  NSDictionary *userInfo = [notification userInfo];
  CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  return keyboardRect;
}

+ (CGFloat)keyboardHeightWithNotification:(NSNotification *)notification {
  return [UIHelper keyboardHeightWithNotification:notification inView:nil];
}

+ (CGFloat)keyboardHeightWithNotification:(nullable NSNotification *)notification inView:(nullable UIView *)view {
  CGRect keyboardRect = [self keyboardRectWithNotification:notification];
  if (!view) {
    return CGRectGetHeight(keyboardRect);
  }
  CGRect keyboardRectInView = [view convertRect:keyboardRect fromView:view.window];
  CGRect keyboardVisibleRectInView = CGRectIntersection(view.bounds, keyboardRectInView);
  CGFloat resultHeight = CGRectIsNull(keyboardVisibleRectInView) ? 0.0f : CGRectGetHeight(keyboardVisibleRectInView);
  return resultHeight;
}

+ (NSTimeInterval)keyboardAnimationDurationWithNotification:(NSNotification *)notification {
  NSDictionary *userInfo = [notification userInfo];
  NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  return animationDuration;
}

+ (UIViewAnimationCurve)keyboardAnimationCurveWithNotification:(NSNotification *)notification {
  NSDictionary *userInfo = [notification userInfo];
  UIViewAnimationCurve curve = (UIViewAnimationCurve)[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
  return curve;
}

+ (UIViewAnimationOptions)keyboardAnimationOptionsWithNotification:(NSNotification *)notification {
  UIViewAnimationOptions options = [UIHelper keyboardAnimationCurveWithNotification:notification]<<16;
  return options;
}

@end

@implementation UIHelper
+ (instancetype)sharedInstance {
  static dispatch_once_t onceToken;
  static UIHelper *instance = nil;
  dispatch_once(&onceToken,^{
    instance = [[super allocWithZone:NULL] init];
    [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  });
  return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
  return [self sharedInstance];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
