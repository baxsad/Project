//
//  UINavigationBarTransition.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "UINavigationBarTransition.h"
#import "UICommonDefines.h"
#import "UIImage+UIConfig.h"
#import "UIScene.h"
#import <objc/runtime.h>
#import <objc/message.h>

void objc_setAssociatedWeakObject(id container, void *key, id value);
id objc_getAssociatedWeakObject(id container, void *key);

@interface NSWeakObjectContainer : NSObject
@property (nonatomic, weak) id object;
@end

@implementation NSWeakObjectContainer

void objc_setAssociatedWeakObject(id container, void *key, id value)
{
  NSWeakObjectContainer *wrapper = [[NSWeakObjectContainer alloc] init];
  wrapper.object = value;
  objc_setAssociatedObject(container, key, wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

id objc_getAssociatedWeakObject(id container, void *key)
{
  return [(NSWeakObjectContainer *)objc_getAssociatedObject(container, key) object];
}

@end

void _SwizzleMethod(Class cls, SEL originalSelector, SEL swizzledSelector)
{
  Method originalMethod = class_getInstanceMethod(cls, originalSelector);
  Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
  
  BOOL didAddMethod =
  class_addMethod(cls,
                  originalSelector,
                  method_getImplementation(swizzledMethod),
                  method_getTypeEncoding(swizzledMethod));
  
  if (didAddMethod) {
    class_replaceMethod(cls,
                        swizzledSelector,
                        method_getImplementation(originalMethod),
                        method_getTypeEncoding(originalMethod));
  } else {
    method_exchangeImplementations(originalMethod, swizzledMethod);
  }
}

@interface _FullscreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>
@property (nonatomic, weak) UINavigationController *navigationController;
@end

@implementation _FullscreenPopGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
  if (self.navigationController.viewControllers.count <= 1) {
    return NO;
  }
  
  UIScene *topScene = self.navigationController.viewControllers.lastObject;
  if (topScene.interactivePopDisabled) {
    return NO;
  }
  
  if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
    return NO;
  }
  
  CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
  if (translation.x <= 0) {
    return NO;
  }
  
  return YES;
}

@end

@implementation UINavigationBar (Transition)

static char kDefaultNavBarHiddenKey;
static char kDefaultNavBarShadowImageColorKey;
static char kDefaultNavBarBarTintColorKey;
static char kDefaultNavBarTintColorKey;
static char kDefaultNavBarBackgroundAlpha;
static char kDefaultStatusBarStyle;

///< Default NavBarHodden
+ (BOOL)defaultNavBarHidden
{
  id hidden = objc_getAssociatedObject(self, &kDefaultNavBarHiddenKey);
  return (hidden != nil) ? [hidden boolValue] : NO;
}
+ (void)setDefaultNavBarHidden:(BOOL)hidden
{
  objc_setAssociatedObject(self,
                           &kDefaultNavBarHiddenKey,
                           @(hidden),
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

///< Default NavBarShadowImageColor
+ (UIColor *)defaultNavBarShadowImageColor
{
  UIColor *color = (UIColor *)objc_getAssociatedObject(self, &kDefaultNavBarShadowImageColorKey);
  return (color != nil) ? color : NavBarShadowImageColor;
}
+ (void)setDefaultNavBarShadowImageColor:(UIColor *)color
{
  objc_setAssociatedObject(self,
                           &kDefaultNavBarShadowImageColorKey,
                           color,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

///< Default NavBarBarTintColor
+ (UIColor *)defaultNavBarBarTintColor
{
  UIColor *color = (UIColor *)objc_getAssociatedObject(self, &kDefaultNavBarBarTintColorKey);
  return (color != nil) ? color : NavBarBarTintColor;
}
+ (void)setDefaultNavBarBarTintColor:(UIColor *)color
{
  objc_setAssociatedObject(self,
                           &kDefaultNavBarBarTintColorKey,
                           color,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

///< Default NavBarTintColor
+ (UIColor *)defaultNavBarTintColor
{
  UIColor *color = (UIColor *)objc_getAssociatedObject(self, &kDefaultNavBarTintColorKey);
  return (color != nil) ? color : NavBarTintColor;
}
+ (void)setDefaultNavBarTintColor:(UIColor *)color
{
  objc_setAssociatedObject(self,
                           &kDefaultNavBarTintColorKey,
                           color,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

///< Default NavBarBackgroundAlpha
+ (CGFloat)defaultNavBarBackgroundAlpha
{
  id alpha = objc_getAssociatedObject(self, &kDefaultNavBarBackgroundAlpha);
  return (alpha != nil) ? [alpha floatValue] : 1.0;
}
+ (void)setDefaultNavBarBackgroundAlpha:(CGFloat)alpha
{
  objc_setAssociatedObject(self,
                           &kDefaultNavBarBackgroundAlpha,
                           @(alpha),
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

///< Default StatusBarStyle
+ (CGFloat)defaultStatusBarStyle
{
  id style = objc_getAssociatedObject(self, &kDefaultStatusBarStyle);
  return (style != nil) ? [style integerValue] : UIStatusBarStyleLightContent;
}
+ (void)setDefaultStatusBarStyle:(UIStatusBarStyle)style
{
  objc_setAssociatedObject(self,
                           &kDefaultStatusBarStyle,
                           @(style),
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - setter

- (void)pr_setShadowImageColor:(UIColor *)color
{
  [self setShadowImage:[UIImage ui_imageWithColor:color
                                             size:CGSizeMake(1, 1)
                                     cornerRadius:0]];
}

- (void)pr_setBackgroundColor:(UIColor *)color
{
  [self setBackgroundImage:[UIImage ui_imageWithColor:color
                                                 size:CGSizeMake(1, 1)
                                         cornerRadius:0]
             forBarMetrics:UIBarMetricsDefault];
}

- (void)pr_setBackgroundAlpha:(CGFloat)alpha
{
  UIImage *image = [self backgroundImageForBarMetrics:UIBarMetricsDefault];
  if (image == nil) {
    image = [UIImage ui_imageWithColor:[UINavigationBar defaultNavBarBarTintColor]
                                  size:CGSizeMake(1, 1)
                          cornerRadius:0];
  }
  [self setBackgroundImage:[image ui_imageByApplyingAlpha:alpha]
             forBarMetrics:UIBarMetricsDefault];
}

@end

@implementation UINavigationController (Transition)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _SwizzleMethod([self class],
                   @selector(pushViewController:animated:),
                   @selector(pr_pushViewController:animated:));
    
    _SwizzleMethod([self class],
                   @selector(popViewControllerAnimated:),
                   @selector(pr_popViewControllerAnimated:));
    
    _SwizzleMethod([self class],
                   @selector(popToViewController:animated:),
                   @selector(pr_popToViewController:animated:));
    
    _SwizzleMethod([self class],
                   @selector(popToRootViewControllerAnimated:),
                   @selector(pr_popToRootViewControllerAnimated:));
    
    _SwizzleMethod([self class],
                   @selector(setViewControllers:animated:),
                   @selector(pr_setViewControllers:animated:));
    
    _SwizzleMethod([self class],
                   @selector(viewDidLayoutSubviews),
                   @selector(pr_nav_viewDidLayoutSubviews));
  });
}
  
- (void)pr_nav_viewDidLayoutSubviews
{
  UIViewController *fromVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
  
  if (fromVC == nil && toVC == nil) {
    [self pr_nav_viewDidLayoutSubviews];
    return;
  }
  
  UIView *disView = fromVC.view;
  UIView *disViewSuperView = disView.superview;
  
  UIView *appearView = toVC.view;
  UIView *appearViewSuperView = appearView.superview;
  
  ///< 如果隐藏导航栏滑动返回的时候的阴影效果不好，不能延伸到导航栏，这里暴力修改滑动返回时的边框阴影布局，以达到舒适的效果
  if ([disViewSuperView isKindOfClass:NSClassFromString(@"_UIParallaxDimmingView")]) {
    disViewSuperView.clipsToBounds = NO;
    [disViewSuperView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      if ([obj isKindOfClass:[UIImageView class]]) {
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGRect rect = obj.frame;
        if (rect.size.height < screenHeight) {
          rect.origin.y -= screenHeight - rect.size.height;
          rect.size.height = screenHeight;
        }
        obj.frame = rect;
        
      }
    }];
  }
  
  if ([appearViewSuperView isKindOfClass:NSClassFromString(@"_UIParallaxDimmingView")]) {
    appearViewSuperView.clipsToBounds = NO;
    [appearViewSuperView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      if ([obj isKindOfClass:[UIImageView class]]) {
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGRect rect = obj.frame;
        if (rect.size.height < screenHeight) {
          rect.origin.y -= screenHeight - rect.size.height;
          rect.size.height = screenHeight;
        }
        obj.frame = rect;
        
      }
    }];
  }
  
  [self pr_nav_viewDidLayoutSubviews];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return [self.topViewController statusBarStyle];
}

- (UIColor *)containerViewBackgroundColor {
  return SceneBackgroundColor;
}

- (_FullscreenPopGestureRecognizerDelegate *)popGestureRecognizerDelegate
{
  _FullscreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
  
  if (!delegate) {
    delegate = [[_FullscreenPopGestureRecognizerDelegate alloc] init];
    delegate.navigationController = self;
    
    objc_setAssociatedObject(self,
                             _cmd,
                             delegate,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return delegate;
}

- (UIPanGestureRecognizer *)fullscreenPopGestureRecognizer
{
  UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
  
  if (!panGestureRecognizer) {
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
    panGestureRecognizer.maximumNumberOfTouches = 1;
    
    objc_setAssociatedObject(self,
                             _cmd,
                             panGestureRecognizer,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return panGestureRecognizer;
}

- (void)pr_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  UIViewController *disappearingViewController = self.viewControllers.lastObject;
  if (!disappearingViewController) {
    return [self pr_pushViewController:viewController animated:animated];
  }
  if (!self.transitionContextToViewController || !disappearingViewController.transitionNavigationBar) {
    [disappearingViewController addTransitionNavigationBarIfNeeded];
  }
  if (animated) {
    self.transitionContextToViewController = viewController;
    if (disappearingViewController.transitionNavigationBar) {
      disappearingViewController.prefersNavigationBarBackgroundViewHidden = YES;
    }
  }
  
  if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.fullscreenPopGestureRecognizer]) {
    
    [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.fullscreenPopGestureRecognizer];
    
    NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
    id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
    SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
    self.fullscreenPopGestureRecognizer.delegate = self.popGestureRecognizerDelegate;
    [self.fullscreenPopGestureRecognizer addTarget:internalTarget action:internalAction];
    
    self.interactivePopGestureRecognizer.enabled = NO;
  }
  
  return [self pr_pushViewController:viewController animated:animated];
}

- (UIViewController *)pr_popViewControllerAnimated:(BOOL)animated
{
  if (self.viewControllers.count < 2) {
    return [self pr_popViewControllerAnimated:animated];
  }
  UIViewController *disappearingViewController = self.viewControllers.lastObject;
  [disappearingViewController addTransitionNavigationBarIfNeeded];
  UIViewController *appearingViewController = self.viewControllers[self.viewControllers.count - 2];
  
  if (appearingViewController.transitionNavigationBar) {
    
    [appearingViewController setNeedsNavigationBarUpdateForTintColor:appearingViewController.navBarTintColor real:YES];
    [appearingViewController setNeedsNavigationBarUpdateForBarTintColor:appearingViewController.navBarBarTintColor real:YES];
    [appearingViewController setNeedsNavigationBarUpdateForShadowImageColor:appearingViewController.navBarShadowImageColor real:YES];
    [appearingViewController setNeedsNavigationBarUpdateForBarBackgroundAlpha:appearingViewController.navBarBackgroundAlpha real:YES];
    
  }
  if (animated) {
    disappearingViewController.prefersNavigationBarBackgroundViewHidden = YES;
  }
  
  return [self pr_popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)pr_popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  if (![self.viewControllers containsObject:viewController] || self.viewControllers.count < 2) {
    return [self pr_popToViewController:viewController animated:animated];
  }
  UIViewController *disappearingViewController = self.viewControllers.lastObject;
  [disappearingViewController addTransitionNavigationBarIfNeeded];
  if (viewController.transitionNavigationBar) {
    
    [viewController setNeedsNavigationBarUpdateForTintColor:viewController.navBarTintColor real:YES];
    [viewController setNeedsNavigationBarUpdateForBarTintColor:viewController.navBarBarTintColor real:YES];
    [viewController setNeedsNavigationBarUpdateForShadowImageColor:viewController.navBarShadowImageColor real:YES];
    [viewController setNeedsNavigationBarUpdateForBarBackgroundAlpha:viewController.navBarBackgroundAlpha real:YES];
    
  }
  if (animated) {
    disappearingViewController.prefersNavigationBarBackgroundViewHidden = YES;
  }
  return [self pr_popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)pr_popToRootViewControllerAnimated:(BOOL)animated
{
  if (self.viewControllers.count < 2) {
    return [self pr_popToRootViewControllerAnimated:animated];
  }
  UIViewController *disappearingViewController = self.viewControllers.lastObject;
  [disappearingViewController addTransitionNavigationBarIfNeeded];
  UIViewController *rootViewController = self.viewControllers.firstObject;
  if (rootViewController.transitionNavigationBar) {
    
    [rootViewController setNeedsNavigationBarUpdateForTintColor:rootViewController.navBarTintColor real:YES];
    [rootViewController setNeedsNavigationBarUpdateForBarTintColor:rootViewController.navBarBarTintColor real:YES];
    [rootViewController setNeedsNavigationBarUpdateForShadowImageColor:rootViewController.navBarShadowImageColor real:YES];
    [rootViewController setNeedsNavigationBarUpdateForBarBackgroundAlpha:rootViewController.navBarBackgroundAlpha real:YES];
    
  }
  if (animated) {
    disappearingViewController.prefersNavigationBarBackgroundViewHidden = YES;
  }
  return [self pr_popToRootViewControllerAnimated:animated];
}

- (void)pr_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated
{
  UIViewController *disappearingViewController = self.viewControllers.lastObject;
  if (animated && disappearingViewController && ![disappearingViewController isEqual:viewControllers.lastObject]) {
    [disappearingViewController addTransitionNavigationBarIfNeeded];
    if (disappearingViewController.transitionNavigationBar) {
      disappearingViewController.prefersNavigationBarBackgroundViewHidden = YES;
    }
  }
  [self pr_setViewControllers:viewControllers animated:animated];
}

- (UIViewController *)transitionContextToViewController {
  return objc_getAssociatedWeakObject(self, _cmd);
}

- (void)setTransitionContextToViewController:(UIViewController *)viewController {
  objc_setAssociatedWeakObject(self, @selector(transitionContextToViewController), viewController);
}

@end
  
@implementation UIViewController (Transition)

static char kNavBaHiddenKey;
static char kNavBaHiddenAnimationKey;
static char kNavBarShadowImageColorKey;
static char kNavBarBarTintColorKey;
static char kNavBarBackgroundAlphaKey;
static char kNavBarTintColorKey;
static char kStatusBarStyleKey;
  
- (BOOL)navBarHidden
{
  id hidden = objc_getAssociatedObject(self, &kNavBaHiddenKey);
  return (hidden != nil) ? [hidden boolValue] : [UINavigationBar defaultNavBarHidden];
}
- (BOOL)navBarHiddenAnimation
{
  id animation = objc_getAssociatedObject(self, &kNavBaHiddenAnimationKey);
  return (animation != nil) ? [animation boolValue] : NO;
}
- (void)setNavBarHidden:(BOOL)hidden animation:(BOOL)animation
{
  objc_setAssociatedObject(self, &kNavBaHiddenKey, @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  objc_setAssociatedObject(self, &kNavBaHiddenAnimationKey, @(animation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  [self setNeedsNavigationBarUpdateForHidden:hidden animation:animation];
}

- (UIColor *)navBarShadowImageColor
{
  UIColor *shadowImageColor = (UIColor *)objc_getAssociatedObject(self, &kNavBarShadowImageColorKey);
  return (shadowImageColor != nil) ? shadowImageColor : [UINavigationBar defaultNavBarShadowImageColor];
}
- (void)setNavBarShadowImageColor:(UIColor *)color
{
  objc_setAssociatedObject(self, &kNavBarShadowImageColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  [self setNeedsNavigationBarUpdateForShadowImageColor:color real:YES];
}

- (UIColor *)navBarBarTintColor
{
  UIColor *barTintColor = (UIColor *)objc_getAssociatedObject(self, &kNavBarBarTintColorKey);
  return (barTintColor != nil) ? barTintColor : [UINavigationBar defaultNavBarBarTintColor];
}
- (void)setNavBarBarTintColor:(UIColor *)color
{
  objc_setAssociatedObject(self, &kNavBarBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  [self setNeedsNavigationBarUpdateForBarTintColor:color real:YES];
}

- (CGFloat)navBarBackgroundAlpha
{
  id barBackgroundAlpha = objc_getAssociatedObject(self, &kNavBarBackgroundAlphaKey);
  return (barBackgroundAlpha != nil) ? [barBackgroundAlpha floatValue] : [UINavigationBar defaultNavBarBackgroundAlpha];
  
}
- (void)setNavBarBackgroundAlpha:(CGFloat)alpha
{
  objc_setAssociatedObject(self, &kNavBarBackgroundAlphaKey, @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  [self setNeedsNavigationBarUpdateForBarBackgroundAlpha:alpha real:YES];
}
  
- (UIColor *)navBarTintColor
{
  UIColor *tintColor = (UIColor *)objc_getAssociatedObject(self, &kNavBarTintColorKey);
  return (tintColor != nil) ? tintColor : [UINavigationBar defaultNavBarTintColor];
}
- (void)setNavBarTintColor:(UIColor *)color
{
  objc_setAssociatedObject(self, &kNavBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  [self setNeedsNavigationBarUpdateForTintColor:color real:YES];
}
  
- (void)setStatusBarStyle:(UIStatusBarStyle)style
{
  objc_setAssociatedObject(self, &kStatusBarStyleKey, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  [self setNeedsStatusBarUpdateForStyle:style animation:YES];
}
- (UIStatusBarStyle)statusBarStyle
{
  id style = objc_getAssociatedObject(self, &kStatusBarStyleKey);
  return (style != nil) ? [style integerValue] : [UINavigationBar defaultStatusBarStyle];
}

#pragma mark - 

- (void)setNeedsNavigationBarUpdateForHidden:(BOOL)hidden animation:(BOOL)animation
{
  [self.navigationController setNavigationBarHidden:hidden animated:animation];
}

- (void)setNeedsNavigationBarUpdateForShadowImageColor:(UIColor *)color real:(BOOL)real
{
  if (real) {
    [self.navigationController.navigationBar pr_setShadowImageColor:color];
  }else{
    if (self.transitionNavigationBar) {
      [self.transitionNavigationBar pr_setShadowImageColor:color];
    }else{
      [self.navigationController.navigationBar pr_setShadowImageColor:color];
    }
  }
}
- (void)setNeedsNavigationBarUpdateForBarTintColor:(UIColor *)color real:(BOOL)real
{
  if (real) {
    [self.navigationController.navigationBar pr_setBackgroundColor:color];
  }else{
    if (self.transitionNavigationBar) {
      [self.transitionNavigationBar pr_setBackgroundColor:color];
    }else{
      [self.navigationController.navigationBar pr_setBackgroundColor:color];
    }
  }
}
- (void)setNeedsNavigationBarUpdateForBarBackgroundAlpha:(CGFloat)alpha real:(BOOL)real
{
  if (real) {
    [self.navigationController.navigationBar pr_setBackgroundAlpha:alpha];
  }else{
    if (self.transitionNavigationBar) {
      [self.transitionNavigationBar pr_setBackgroundAlpha:alpha];
    }else{
      [self.navigationController.navigationBar pr_setBackgroundAlpha:alpha];
    }
  }
}
- (void)setNeedsNavigationBarUpdateForTintColor:(UIColor *)color real:(BOOL)real
{
  if (real) {
    [self.navigationController.navigationBar setTintColor:color];
  }else{
    if (self.transitionNavigationBar) {
      [self.transitionNavigationBar setTintColor:color];
    }else{
      [self.navigationController.navigationBar setTintColor:color];
    }
  }
}
- (void)setNeedsStatusBarUpdateForStyle:(UIStatusBarStyle)style animation:(BOOL)animation{
  [[UIApplication sharedApplication] setStatusBarStyle:style animated:YES];
}

+ (void)load
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _SwizzleMethod([self class],
                    @selector(viewWillLayoutSubviews),
                    @selector(pr_controller_viewDidLayoutSubviews));
    
    _SwizzleMethod([self class],
                   @selector(viewDidAppear:),
                   @selector(pr_viewDidAppear:));
    
    _SwizzleMethod([self class],
                   @selector(viewWillAppear:),
                   @selector(pr_viewWillAppear));
    
  });
}
  
- (UIStatusBarStyle)preferredStatusBarStyle
{
  return [self statusBarStyle];
}

- (void)pr_controller_viewDidLayoutSubviews
{
  id<UIViewControllerTransitionCoordinator> tc = self.transitionCoordinator;
  UIViewController *fromViewController = [tc viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toViewController = [tc viewControllerForKey:UITransitionContextToViewControllerKey];
  UIViewController *lastViewController = self.navigationController.viewControllers.lastObject;
  
  if (toViewController && [toViewController isEqual:lastViewController] && toViewController.transitionNavigationBar) {
    [toViewController resizeTransitionNavigationBarFrame];
  }
  
  if ([self isEqual:self.navigationController.viewControllers.lastObject] && [toViewController isEqual:self] && self.navigationController.transitionContextToViewController) {
    if (self.navigationController.navigationBar.translucent) {
      [tc containerView].backgroundColor = [self.navigationController containerViewBackgroundColor];
    }
    fromViewController.view.clipsToBounds = NO;
    toViewController.view.clipsToBounds = NO;
    if (!self.transitionNavigationBar) {
      [self addTransitionNavigationBarIfNeeded];
      
      self.prefersNavigationBarBackgroundViewHidden = YES;
    }
    [self resizeTransitionNavigationBarFrame];
  }
  if (self.transitionNavigationBar) {
    [self.view bringSubviewToFront:self.transitionNavigationBar];
  }
  [self pr_controller_viewDidLayoutSubviews];
}

- (void)pr_viewDidAppear:(BOOL)animated
{
  if (self.transitionNavigationBar) {
    
    [self setNeedsNavigationBarUpdateForTintColor:self.navBarTintColor real:YES];
    [self setNeedsNavigationBarUpdateForBarTintColor:self.navBarBarTintColor real:YES];
    [self setNeedsNavigationBarUpdateForShadowImageColor:self.navBarShadowImageColor real:YES];
    [self setNeedsNavigationBarUpdateForBarBackgroundAlpha:self.navBarBackgroundAlpha real:YES];
    
    UIViewController *transitionViewController = self.navigationController.transitionContextToViewController;
    if (!transitionViewController || [transitionViewController isEqual:self]) {
      [self.transitionNavigationBar removeFromSuperview];
      self.transitionNavigationBar = nil;
      self.navigationController.transitionContextToViewController = nil;
    }
  }
  self.prefersNavigationBarBackgroundViewHidden = NO;
  [self pr_viewDidAppear:animated];
}

- (void)pr_viewWillAppear
{
  if (self.navigationController) {
    [self setNavBarHidden:self.navBarHidden animation:[self navBarHiddenAnimation]];
  }
  [self setNeedsStatusBarUpdateForStyle:self.statusBarStyle animation:YES];
  [self pr_viewWillAppear];
}

#pragma mark - 

- (void)resizeTransitionNavigationBarFrame {
  if (!self.view.window) {
    return;
  }
  UIView *backgroundView = [self.navigationController.navigationBar valueForKey:@"_backgroundView"];
  CGRect rect = [backgroundView.superview convertRect:backgroundView.frame toView:self.view];
  if (self.transitionNavigationBar &&
      (self.transitionNavigationBar.frame.size.width != rect.size.width ||
       self.transitionNavigationBar.frame.size.height != rect.size.height)) {
    self.transitionNavigationBar.frame = rect;
  }
  
}

- (void)addTransitionNavigationBarIfNeeded {
  if (!self.isViewLoaded || !self.view.window) {
    return;
  }
  if (!self.navigationController.navigationBar) {
    return;
  }
  [self adjustScrollViewContentOffsetIfNeeded];
  
  UINavigationBar *bar = [[UINavigationBar alloc] init];
  bar.barStyle = self.navigationController.navigationBar.barStyle;
  if (bar.translucent != self.navigationController.navigationBar.translucent) {
    bar.translucent = self.navigationController.navigationBar.translucent;
  }
  
  [self.transitionNavigationBar removeFromSuperview];
  self.transitionNavigationBar = bar;
  [self resizeTransitionNavigationBarFrame];
  if (!self.navigationController.navigationBarHidden && !self.navigationController.navigationBar.hidden && !self.navBarHidden) {
    [self.view addSubview:self.transitionNavigationBar];
    
    [self setNeedsNavigationBarUpdateForTintColor:self.navBarTintColor real:NO];
    [self setNeedsNavigationBarUpdateForBarTintColor:self.navBarBarTintColor real:NO];
    [self setNeedsNavigationBarUpdateForShadowImageColor:self.navBarShadowImageColor real:NO];
    [self setNeedsNavigationBarUpdateForBarBackgroundAlpha:self.navBarBackgroundAlpha real:NO];
    
  }
}

- (void)adjustScrollViewContentOffsetIfNeeded {
  if ([self.view isKindOfClass:[UIScrollView class]]) {
    UIScrollView *scrollView = (UIScrollView *)self.view;
    const CGFloat topContentOffsetY = -scrollView.contentInset.top;
    const CGFloat bottomContentOffsetY = scrollView.contentSize.height - (CGRectGetHeight(scrollView.bounds) - scrollView.contentInset.bottom);
    
    CGPoint adjustedContentOffset = scrollView.contentOffset;
    if (adjustedContentOffset.y > bottomContentOffsetY) {
      adjustedContentOffset.y = bottomContentOffsetY;
    }
    if (adjustedContentOffset.y < topContentOffsetY) {
      adjustedContentOffset.y = topContentOffsetY;
    }
    [scrollView setContentOffset:adjustedContentOffset animated:NO];
  }
}

#pragma mark - porperty

- (BOOL)interactivePopDisabled
{
  return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setInteractivePopDisabled:(BOOL)disabled
{
  objc_setAssociatedObject(self,
                           @selector(interactivePopDisabled),
                           @(disabled),
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationBar *)transitionNavigationBar {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setTransitionNavigationBar:(UINavigationBar *)navigationBar {
  objc_setAssociatedObject(self, @selector(transitionNavigationBar), navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)prefersNavigationBarBackgroundViewHidden {
  return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setPrefersNavigationBarBackgroundViewHidden:(BOOL)hidden {
  [[self.navigationController.navigationBar valueForKey:@"_backgroundView"]
   setHidden:hidden];
  objc_setAssociatedObject(self, @selector(prefersNavigationBarBackgroundViewHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
