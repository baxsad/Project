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

#define IOS10 [[[UIDevice currentDevice]systemVersion] floatValue] >= 10.0

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

static char kDefaultNavBarShadowImageColorKey;
static char kDefaultNavBarBarTintColorKey;
static char kDefaultNavBarTintColorKey;
static char kDefaultNavBarBackgroundAlpha;
static char kDefaultStatusBarStyle;
static char kBarColorLayer;

+ (void)load {
  if (self == [UINavigationBar self]) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      _SwizzleMethod([self class],
                     @selector(layoutSubviews),
                     @selector(pr_layoutSubviews));
    });
  }
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

///< colorLayer
- (UIView *)colorLayer
{
  id layer = objc_getAssociatedObject(self, &kBarColorLayer);
  return layer;
}
- (void)setColorLayer:(UIView *)layer
{
  objc_setAssociatedObject(self,
                           &kBarColorLayer,
                           layer,
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
  UIView *barBackgroundView = [[self subviews] objectAtIndex:0];
  if (self.colorLayer == nil) {
    self.colorLayer = [UIView new];
    [barBackgroundView addSubview:self.colorLayer];
    @weakify(barBackgroundView);
    [self.colorLayer mas_makeConstraints:^(MASConstraintMaker *make) {
      @strongify(barBackgroundView);
      make.left.right.top.bottom.equalTo(barBackgroundView).offset(0);
    }];
  }
  self.colorLayer.backgroundColor = color;
  barBackgroundView.backgroundColor = [UIColor clearColor];
  [self setBarTintColor:[UIColor clearColor]];
  
  if (!self.isTranslucent) {
    return;
  }
  
  if (IOS10) {
    UIView *backgroundEffectView = [barBackgroundView valueForKey:@"_backgroundEffectView"];
    if (backgroundEffectView != nil && [self backgroundImageForBarMetrics:UIBarMetricsDefault] == nil) {
      backgroundEffectView.alpha = 0;
      backgroundEffectView.hidden = YES;
    }
  }
  else{
    UIView *daptiveBackdrop = [barBackgroundView valueForKey:@"_adaptiveBackdrop"];
    UIView *backdropEffectView = [daptiveBackdrop valueForKey:@"_backdropEffectView"];
    if (daptiveBackdrop != nil && backdropEffectView != nil ) {
      backdropEffectView.alpha = 0;
      backdropEffectView.hidden = YES;
    }
    for (UIView *view in barBackgroundView.subviews) {
      if ([view isKindOfClass:NSClassFromString(@"_UIBackdropView")]) {
        view.hidden = YES;
      }
    }
  }
  
}


- (void)pr_setBackgroundAlpha:(CGFloat)alpha
{
  UIView *barBackgroundView = [[self subviews] objectAtIndex:0];
  UIView *shadowView = [barBackgroundView valueForKey:@"_shadowView"];
  if (shadowView) {
    shadowView.alpha = alpha;
    shadowView.hidden = alpha == 0;
  }
  if (self.colorLayer) {
    self.colorLayer.alpha = alpha;
  }
  
  if (!self.isTranslucent) {
    barBackgroundView.alpha = alpha;
    return;
  }
  
  if (IOS10) {
    UIView *backgroundEffectView = [barBackgroundView valueForKey:@"_backgroundEffectView"];
    if (backgroundEffectView != nil && [self backgroundImageForBarMetrics:UIBarMetricsDefault] == nil) {
      backgroundEffectView.alpha = 0;
      backgroundEffectView.hidden = YES;
    }
  }
  else{
    UIView *daptiveBackdrop = [barBackgroundView valueForKey:@"_adaptiveBackdrop"];
    UIView *backdropEffectView = [daptiveBackdrop valueForKey:@"_backdropEffectView"];
    if (daptiveBackdrop != nil && backdropEffectView != nil ) {
      backdropEffectView.alpha = 0;
      backdropEffectView.hidden = YES;
    }
    for (UIView *view in barBackgroundView.subviews) {
      if ([view isKindOfClass:NSClassFromString(@"_UIBackdropView")]) {
        view.hidden = YES;
      }
    }
  }
  
}

- (void)pr_layoutSubviews
{
  if (!self.isTranslucent || self.subviews.count == 0) {
    return;
  }
  
  UIView *barBackgroundView = [[self subviews] objectAtIndex:0];
  if (IOS10) {
    UIView *backgroundEffectView = [barBackgroundView valueForKey:@"_backgroundEffectView"];
    if (backgroundEffectView != nil && [self backgroundImageForBarMetrics:UIBarMetricsDefault] == nil) {
      backgroundEffectView.alpha = 0;
      backgroundEffectView.hidden = YES;
    }
  }
  else{
    UIView *daptiveBackdrop = [barBackgroundView valueForKey:@"_adaptiveBackdrop"];
    UIView *backdropEffectView = [daptiveBackdrop valueForKey:@"_backdropEffectView"];
    if (daptiveBackdrop != nil && backdropEffectView != nil ) {
      backdropEffectView.alpha = 0;
      backdropEffectView.hidden = YES;
    }
    for (UIView *view in barBackgroundView.subviews) {
      if ([view isKindOfClass:NSClassFromString(@"_UIBackdropView")]) {
        view.hidden = YES;
      }
    }
  }
  [self pr_layoutSubviews];
}

@end

@implementation UINavigationController (Transition)

UIColor *averageColor(UIColor *fromColor,UIColor *toColor,CGFloat percent)
{
  CGFloat fromRed = 0;
  CGFloat fromGreen = 0;
  CGFloat fromBlue = 0;
  CGFloat fromAlpha = 0;
  [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
  
  CGFloat toRed = 0;
  CGFloat toGreen = 0;
  CGFloat toBlue = 0;
  CGFloat toAlpha = 0;
  [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
  
  CGFloat nowRed = fromRed + (toRed - fromRed) * percent;
  CGFloat nowGreen = fromGreen + (toGreen - fromGreen) * percent;
  CGFloat nowBlue = fromBlue + (toBlue - fromBlue) * percent;
  CGFloat nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percent;
  
  return [UIColor colorWithRed:nowRed green:nowGreen blue:nowBlue alpha:nowAlpha];
}

+ (void)load {
  if (self == [UINavigationController self]) {
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
                     NSSelectorFromString(@"_updateInteractiveTransition:"),
                     @selector(pr__updateInteractiveTransition:));
      
    });
  }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return [self.topViewController statusBarStyle];
}

- (void)pr__updateInteractiveTransition:(CGFloat)percentComplete
{
  UIViewController *topVC = self.topViewController;
  id<UIViewControllerTransitionCoordinator> coor = topVC.transitionCoordinator;
  
  if (topVC && coor) {
    UIViewController *fromeVC = [coor viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [coor viewControllerForKey:UITransitionContextToViewControllerKey];
    CGFloat fromAlpha = fromeVC.navBarBackgroundAlpha;
    CGFloat toAlpha = topVC.navBarBackgroundAlpha;
    CGFloat newAlpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete;
    
    [self setNeedsStatusBarUpdateForStyle:toVC.statusBarStyle];
    [self setNeedsNavigationBarUpdateForTintColor:averageColor(fromeVC.navBarTintColor,topVC.navBarTintColor,percentComplete)];
    [self setNeedsNavigationBarUpdateForBarTintColor:averageColor(fromeVC.navBarBarTintColor,topVC.navBarBarTintColor,percentComplete)];
    [self setNeedsNavigationBarUpdateForBarBackgroundAlpha:newAlpha];
    [self setNeedsNavigationBarUpdateForShadowImageColor:toVC.navBarShadowImageColor];
  }
  [self pr__updateInteractiveTransition:percentComplete];
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
    [self pr_pushViewController:viewController animated:animated];
    return;
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

  [self pr_pushViewController:viewController animated:animated];
}

- (UIViewController *)pr_popViewControllerAnimated:(BOOL)animated
{
  return [self pr_popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)pr_popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  if (![self.viewControllers containsObject:viewController] || self.viewControllers.count < 2) {
    return [self pr_popToViewController:viewController animated:animated];
  }
  
  [self setNeedsStatusBarUpdateForStyle:viewController.statusBarStyle];
  [self setNeedsNavigationBarUpdateForTintColor:viewController.navBarTintColor];
  [self setNeedsNavigationBarUpdateForBarTintColor:viewController.navBarBarTintColor];
  [self setNeedsNavigationBarUpdateForBarBackgroundAlpha:viewController.navBarBackgroundAlpha];
  [self setNeedsNavigationBarUpdateForShadowImageColor:viewController.navBarShadowImageColor];
  
  return [self pr_popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)pr_popToRootViewControllerAnimated:(BOOL)animated
{
  if (self.viewControllers.count < 2) {
    return [self pr_popToRootViewControllerAnimated:animated];
  }
  UIViewController *rootVC = self.viewControllers.firstObject;
  
  [self setNeedsStatusBarUpdateForStyle:rootVC.statusBarStyle];
  [self setNeedsNavigationBarUpdateForTintColor:rootVC.navBarTintColor];
  [self setNeedsNavigationBarUpdateForBarTintColor:rootVC.navBarBarTintColor];
  [self setNeedsNavigationBarUpdateForBarBackgroundAlpha:rootVC.navBarBackgroundAlpha];
  [self setNeedsNavigationBarUpdateForShadowImageColor:rootVC.navBarShadowImageColor];
  
  return [self pr_popToRootViewControllerAnimated:animated];
}

- (void)pr_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated
{
  [self pr_setViewControllers:viewControllers animated:animated];
}

#pragma mark - UINavigationBar Delegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
  UIViewController *topVC = self.topViewController;
  id <UIViewControllerTransitionCoordinator>coor = topVC.transitionCoordinator;
  if (topVC && coor && coor.initiallyInteractive) {
    __weak typeof(self) weakSelf = self;
    if ([[UIDevice currentDevice].systemName integerValue] >= 10.0) {
      [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf dealInteractionChanges:context];
      }];
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
      [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf dealInteractionChanges:context];
      }];
#pragma clang diagnostic pop
      return YES;
    }
  }
  
  NSInteger itemCount = navigationBar.items.count;
  NSInteger n = self.viewControllers.count >= itemCount ? 2 : 1;
  UIViewController *popToVC = self.viewControllers[self.viewControllers.count - n];
  
  [self popToViewController:popToVC animated:YES];
  return YES;
}

#pragma mark - dealInteractionChanges

- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
  
  __weak typeof(self) weakSelf = self;
  void(^animation)(BOOL from,id<UIViewControllerTransitionCoordinatorContext> ctx) = ^(BOOL from,id<UIViewControllerTransitionCoordinatorContext> ctx){
    NSTimeInterval duration = 0;
    UIViewController *showVC = nil;
    if (from) {
      duration = [ctx transitionDuration] * (double)[ctx percentComplete];
      showVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    }else{
      duration = [ctx transitionDuration] * (double)(1 - [ctx percentComplete]);
      showVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    
    [UIView animateWithDuration:duration animations:^{
      __strong typeof(self) strongSelf = weakSelf;
      [strongSelf setNeedsStatusBarUpdateForStyle:showVC.statusBarStyle];
      [strongSelf setNeedsNavigationBarUpdateForTintColor:showVC.navBarTintColor];
      [strongSelf setNeedsNavigationBarUpdateForBarTintColor:showVC.navBarBarTintColor];
      [strongSelf setNeedsNavigationBarUpdateForBarBackgroundAlpha:showVC.navBarBackgroundAlpha];
      [strongSelf setNeedsNavigationBarUpdateForShadowImageColor:showVC.navBarShadowImageColor];
    }];
  };
  
  if ([context isCancelled]) {
    animation(YES,context);
  } else {
    animation(NO,context);
  }
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
{
  return YES;
}

#pragma mark -

- (void)setNeedsNavigationBarUpdateForShadowImageColor:(UIColor *)color
{
  [self.navigationBar pr_setShadowImageColor:color];
}
- (void)setNeedsNavigationBarUpdateForBarTintColor:(UIColor *)color
{
  [self.navigationBar pr_setBackgroundColor:color];
}
- (void)setNeedsNavigationBarUpdateForBarBackgroundAlpha:(CGFloat)alpha
{
  [self.navigationBar pr_setBackgroundAlpha:alpha];
}
- (void)setNeedsNavigationBarUpdateForTintColor:(UIColor *)color
{
  [self.navigationBar setTintColor:color];
}
- (void)setNeedsStatusBarUpdateForStyle:(UIStatusBarStyle)style{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
  [[UIApplication sharedApplication] setStatusBarStyle:style animated:YES];
#pragma clang diagnostic pop
}

@end
  
@implementation UIViewController (Transition)

static char kNavBarShadowImageColorKey;
static char kNavBarBarTintColorKey;
static char kNavBarBackgroundAlphaKey;
static char kNavBarTintColorKey;
static char kStatusBarStyleKey;

- (UIColor *)navBarShadowImageColor
{
  UIColor *shadowImageColor = (UIColor *)objc_getAssociatedObject(self, &kNavBarShadowImageColorKey);
  return (shadowImageColor != nil) ? shadowImageColor : [UINavigationBar defaultNavBarShadowImageColor];
}
- (void)setNavBarShadowImageColor:(UIColor *)color
{
  [self setNavBarShadowImageColor:color needUpdate:YES];
}
- (void)setNavBarShadowImageColor:(UIColor *)color needUpdate:(BOOL)need
{
  objc_setAssociatedObject(self, &kNavBarShadowImageColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  if (need) {
    [self.navigationController setNeedsNavigationBarUpdateForShadowImageColor:color];
  }
}

- (UIColor *)navBarBarTintColor
{
  UIColor *barTintColor = (UIColor *)objc_getAssociatedObject(self, &kNavBarBarTintColorKey);
  return (barTintColor != nil) ? barTintColor : [UINavigationBar defaultNavBarBarTintColor];
}
- (void)setNavBarBarTintColor:(UIColor *)color
{
  [self setNavBarBarTintColor:color needUpdate:YES];
}
- (void)setNavBarBarTintColor:(UIColor *)color needUpdate:(BOOL)need
{
  objc_setAssociatedObject(self, &kNavBarBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  if (need) {
    [self.navigationController setNeedsNavigationBarUpdateForBarTintColor:color];
  }
}

- (CGFloat)navBarBackgroundAlpha
{
  id barBackgroundAlpha = objc_getAssociatedObject(self, &kNavBarBackgroundAlphaKey);
  return (barBackgroundAlpha != nil) ? [barBackgroundAlpha floatValue] : [UINavigationBar defaultNavBarBackgroundAlpha];
}
- (void)setNavBarBackgroundAlpha:(CGFloat)alpha
{
  [self setNavBarBackgroundAlpha:alpha needUpdate:YES];
}
- (void)setNavBarBackgroundAlpha:(CGFloat)alpha needUpdate:(BOOL)need
{
  objc_setAssociatedObject(self, &kNavBarBackgroundAlphaKey, @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  if (need) {
    [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundAlpha:alpha];
  }
}
  
- (UIColor *)navBarTintColor
{
  UIColor *tintColor = (UIColor *)objc_getAssociatedObject(self, &kNavBarTintColorKey);
  return (tintColor != nil) ? tintColor : [UINavigationBar defaultNavBarTintColor];
}
- (void)setNavBarTintColor:(UIColor *)color
{
  [self setNavBarTintColor:color needUpdate:YES];
}
- (void)setNavBarTintColor:(UIColor *)color needUpdate:(BOOL)need
{
  objc_setAssociatedObject(self, &kNavBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  if (need) {
    [self.navigationController setNeedsNavigationBarUpdateForTintColor:color];
  }
}
  
- (void)setStatusBarStyle:(UIStatusBarStyle)style
{
  objc_setAssociatedObject(self, &kStatusBarStyleKey, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  [self.navigationController setNeedsStatusBarUpdateForStyle:style];
}
- (UIStatusBarStyle)statusBarStyle
{
  id style = objc_getAssociatedObject(self, &kStatusBarStyleKey);
  return (style != nil) ? [style integerValue] : [UINavigationBar defaultStatusBarStyle];
}

#pragma mark -

+ (void)load
{
  if (self == [UIViewController self]) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      _SwizzleMethod([self class],
                     @selector(viewWillAppear:),
                     @selector(pr_viewWillAppear:));
      _SwizzleMethod([self class],
                     @selector(viewDidLoad),
                     @selector(pr_viewDidLoad));
      _SwizzleMethod([self class],
                     @selector(viewDidDisappear:),
                     @selector(pr_viewDidDisappear:));
      _SwizzleMethod([self class],
                     @selector(viewDidAppear:),
                     @selector(pr_viewDidAppear:));
    });
  }
}

- (void)pr_viewDidLoad
{
  [self.navigationController setNeedsNavigationBarUpdateForShadowImageColor:self.navBarShadowImageColor];
  [self.navigationController setNeedsNavigationBarUpdateForBarTintColor:self.navBarBarTintColor];
  [self.navigationController setNeedsNavigationBarUpdateForTintColor:self.navBarTintColor];
  [self.navigationController setNeedsStatusBarUpdateForStyle:self.statusBarStyle];
  [self pr_viewDidLoad];
}

- (void)pr_viewWillAppear:(BOOL)animated
{
  __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:.250
                        delay:.125
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     __strong typeof(self) strongSelf = weakSelf;
                     [strongSelf.navigationController setNeedsNavigationBarUpdateForBarBackgroundAlpha:self.navBarBackgroundAlpha];
                   }
                   completion:^(BOOL finished) {
                     
                   }];
  [self pr_viewWillAppear:animated];
}

- (void)pr_viewDidAppear:(BOOL)animated
{
  
  [self pr_viewDidAppear:animated];
}

- (void)pr_viewDidDisappear:(BOOL)animated
{
  [self pr_viewDidDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return [self statusBarStyle];
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

@end
