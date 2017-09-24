//
//  UINavigationScene.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "UINavigationScene.h"
#import "UIScene.h"
#import "UINavigationButton.h"
#import <objc/runtime.h>

CG_INLINE void
ReplaceMethod(Class _class, SEL _originSelector, SEL _newSelector) {
  Method oriMethod = class_getInstanceMethod(_class, _originSelector);
  Method newMethod = class_getInstanceMethod(_class, _newSelector);
  BOOL isAddedMethod = class_addMethod(_class, _originSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
  if (isAddedMethod) {
    class_replaceMethod(_class, _newSelector, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
  } else {
    method_exchangeImplementations(oriMethod, newMethod);
  }
}

@interface UINavigationController (BackButtonHandlerProtocol)
- (nullable UIViewController *)tmp_topViewController;
@end

@implementation UINavigationController (BackButtonHandlerProtocol)
- (UIViewController *)tmp_topViewController {
  return objc_getAssociatedObject(self, _cmd);
}
- (void)setTmp_topViewController:(UIViewController *)viewController {
  objc_setAssociatedObject(self, @selector(tmp_topViewController), viewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

@implementation UINavigationController (Hooks)
- (void)willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {}
- (void)didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {}
@end

@implementation UINavigationController (UI)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    ReplaceMethod([self class], @selector(viewDidLoad), @selector(ui_viewDidLoad));
    ReplaceMethod([self class], @selector(navigationBar:shouldPopItem:), @selector(ui_navigationBar:shouldPopItem:));
  });
}

- (nullable UIViewController *)rootViewController {
  return self.viewControllers.firstObject;
}

- (BOOL)canPopViewController:(UIViewController *)viewController {
  BOOL canPopViewController = YES;
  
  if ([viewController respondsToSelector:@selector(shouldHoldBackButtonEvent)] &&
      [viewController shouldHoldBackButtonEvent] &&
      [viewController respondsToSelector:@selector(canPopViewController)] &&
      ![viewController canPopViewController]) {
    canPopViewController = NO;
  }
  
  return canPopViewController;
}

- (BOOL)ui_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
  
  BOOL isPopedByCoding = item != [self topViewController].navigationItem;
  BOOL canPopViewController = !isPopedByCoding && [self canPopViewController:self.tmp_topViewController ?: [self topViewController]];
  
  if (canPopViewController || isPopedByCoding) {
    self.tmp_topViewController = nil;
    return [self ui_navigationBar:navigationBar shouldPopItem:item];
  } else {
    [self resetSubviewsInNavBar:navigationBar];
    self.tmp_topViewController = nil;
  }
  
  return NO;
}

- (void)resetSubviewsInNavBar:(UINavigationBar *)navBar {
  // Workaround for >= iOS7.1. Thanks to @boliva - http://stackoverflow.com/posts/comments/34452906
  for(UIView *subview in [navBar subviews]) {
    if(subview.alpha < 1.0) {
      [UIView animateWithDuration:.25 animations:^{
        subview.alpha = 1.0;
      }];
    }
  }
}

@end

@implementation UIViewController (BackBarButtonSupport)
@end

@interface UIViewController (UINavigationScene)
@property(nonatomic, assign) BOOL isViewWillAppear;
@end

@implementation UIViewController (UINavigationScene)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class cls = [self class];
    ReplaceMethod(cls, @selector(viewWillAppear:), @selector(observe_viewWillAppear:));
    ReplaceMethod(cls, @selector(viewDidDisappear:), @selector(observe_viewDidDisappear:));
  });
}

- (void)observe_viewWillAppear:(BOOL)animated {
  [self observe_viewWillAppear:animated];
  self.isViewWillAppear = YES;
}

- (void)observe_viewDidDisappear:(BOOL)animated {
  [self observe_viewDidDisappear:animated];
  self.isViewWillAppear = NO;
}

- (BOOL)isViewWillAppear {
  return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsViewWillAppear:(BOOL)isViewWillAppear {
  [self willChangeValueForKey:@"isViewWillAppear"];
  objc_setAssociatedObject(self, @selector(isViewWillAppear), [[NSNumber alloc] initWithBool:isViewWillAppear], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  [self didChangeValueForKey:@"isViewWillAppear"];
}

@end

@interface UINavigationScene ()
@property(nonatomic, assign) BOOL isViewControllerTransiting;
@property(nonatomic, weak) UIViewController *viewControllerPopping;
@property(nonatomic, weak) id <UINavigationControllerDelegate> delegateProxy;
@end

@implementation UINavigationScene

#pragma mark - 生命周期函数 && 基类方法重写

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    [self didInitialized];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    [self didInitialized];
  }
  return self;
}

- (void)didInitialized {
  self.navigationBar.tintColor = NavBarTintColor;
  self.toolbar.tintColor = ToolBarTintColor;
}

- (void)dealloc {
  self.delegate = nil;
}
  
- (void)viewDidLoad {
  [super viewDidLoad];
  if (!self.delegate) {
    self.delegate = self;
  }
  [self.interactivePopGestureRecognizer addTarget:self action:@selector(handleInteractivePopGestureRecognizer:)];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self willShowViewController:self.topViewController animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self didShowViewController:self.topViewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
  if (self.viewControllers.count < 2) {
    return [super popViewControllerAnimated:animated];
  }
  
  if (animated) {
    self.isViewControllerTransiting = YES;
  }
  
  UIViewController *viewController = [self topViewController];
  self.viewControllerPopping = viewController;
  if ([viewController respondsToSelector:@selector(willPopInNavigationControllerWithAnimated:)]) {
    [((UIViewController<UINavigationSceneDelegate> *)viewController) willPopInNavigationControllerWithAnimated:animated];
  }
  viewController = [super popViewControllerAnimated:animated];
  if ([viewController respondsToSelector:@selector(didPopInNavigationControllerWithAnimated:)]) {
    [((UIViewController<UINavigationSceneDelegate> *)viewController) didPopInNavigationControllerWithAnimated:animated];
  }
  return viewController;
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
  // 从横屏界面pop 到竖屏界面，系统会调用两次 popViewController，如果这里加这个 if 判断，会误拦第二次 pop，导致错误
  if (!viewController || self.topViewController == viewController) {
    return [super popToViewController:viewController animated:animated];
  }
  
  if (animated) {
    self.isViewControllerTransiting = YES;
  }
  
  self.viewControllerPopping = self.topViewController;
  
  // will pop
  for (NSInteger i = self.viewControllers.count - 1; i > 0; i--) {
    UIViewController *viewControllerPopping = self.viewControllers[i];
    if (viewControllerPopping == viewController) {
      break;
    }
    
    if ([viewControllerPopping respondsToSelector:@selector(willPopInNavigationControllerWithAnimated:)]) {
      BOOL animatedArgument = i == self.viewControllers.count - 1 ? animated : NO;// 只有当前可视的那个 viewController 的 animated 是跟随参数走的，其他 viewController 由于不可视，不管参数的值为多少，都认为是无动画地 pop
      [((UIViewController<UINavigationSceneDelegate> *)viewControllerPopping) willPopInNavigationControllerWithAnimated:animatedArgument];
    }
  }
  
  NSArray<UIViewController *> *poppedViewControllers = [super popToViewController:viewController animated:animated];
  
  // did pop
  for (NSInteger i = poppedViewControllers.count - 1; i >= 0; i--) {
    UIViewController *viewControllerPopped = poppedViewControllers[i];
    if ([viewControllerPopped respondsToSelector:@selector(didPopInNavigationControllerWithAnimated:)]) {
      BOOL animatedArgument = i == poppedViewControllers.count - 1 ? animated : NO;// 只有当前可视的那个 viewController 的 animated 是跟随参数走的，其他 viewController 由于不可视，不管参数的值为多少，都认为是无动画地 pop
      [((UIViewController<UINavigationSceneDelegate> *)viewControllerPopped) didPopInNavigationControllerWithAnimated:animatedArgument];
    }
  }
  
  return poppedViewControllers;
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
  // 从横屏界面pop 到竖屏界面，系统会调用两次 popViewController，如果这里加这个 if 判断，会误拦第二次 pop，导致错误
  // 在配合 tabBarItem 使用的情况下，快速重复点击相同 item 可能会重复调用 popToRootViewControllerAnimated:，而此时其实已经处于 rootViewController 了，就没必要继续走后续的流程，否则一些变量会得不到重置。
  if (self.topViewController == self.viewControllers.firstObject) {
    return nil;
  }
  
  if (animated) {
    self.isViewControllerTransiting = YES;
  }
  
  self.viewControllerPopping = self.topViewController;
  
  // will pop
  for (NSInteger i = self.viewControllers.count - 1; i > 0; i--) {
    UIViewController *viewControllerPopping = self.viewControllers[i];
    if ([viewControllerPopping respondsToSelector:@selector(willPopInNavigationControllerWithAnimated:)]) {
      BOOL animatedArgument = i == self.viewControllers.count - 1 ? animated : NO;// 只有当前可视的那个 viewController 的 animated 是跟随参数走的，其他 viewController 由于不可视，不管参数的值为多少，都认为是无动画地 pop
      [((UIViewController<UINavigationSceneDelegate> *)viewControllerPopping) willPopInNavigationControllerWithAnimated:animatedArgument];
    }
  }
  
  NSArray<UIViewController *> * poppedViewControllers = [super popToRootViewControllerAnimated:animated];
  
  // did pop
  for (NSInteger i = poppedViewControllers.count - 1; i >= 0; i--) {
    UIViewController *viewControllerPopped = poppedViewControllers[i];
    if ([viewControllerPopped respondsToSelector:@selector(didPopInNavigationControllerWithAnimated:)]) {
      BOOL animatedArgument = i == poppedViewControllers.count - 1 ? animated : NO;// 只有当前可视的那个 viewController 的 animated 是跟随参数走的，其他 viewController 由于不可视，不管参数的值为多少，都认为是无动画地 pop
      [((UIViewController<UINavigationSceneDelegate> *)viewControllerPopped) didPopInNavigationControllerWithAnimated:animatedArgument];
    }
  }
  return poppedViewControllers;
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
  UIViewController *topViewController = self.topViewController;
  
  // will pop
  NSMutableArray<UIViewController *> *viewControllersPopping = self.viewControllers.mutableCopy;
  [viewControllersPopping removeObjectsInArray:viewControllers];
  [viewControllersPopping enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([obj respondsToSelector:@selector(willPopInNavigationControllerWithAnimated:)]) {
      BOOL animatedArgument = obj == topViewController ? animated : NO;// 只有当前可视的那个 viewController 的 animated 是跟随参数走的，其他 viewController 由于不可视，不管参数的值为多少，都认为是无动画地 pop
      [((UIViewController<UINavigationSceneDelegate> *)obj) willPopInNavigationControllerWithAnimated:animatedArgument];
    }
  }];
  
  [super setViewControllers:viewControllers animated:animated];
  
  // did pop
  [viewControllersPopping enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([obj respondsToSelector:@selector(didPopInNavigationControllerWithAnimated:)]) {
      BOOL animatedArgument = obj == topViewController ? animated : NO;// 只有当前可视的那个 viewController 的 animated 是跟随参数走的，其他 viewController 由于不可视，不管参数的值为多少，都认为是无动画地 pop
      [((UIViewController<UINavigationSceneDelegate> *)obj) didPopInNavigationControllerWithAnimated:animatedArgument];
    }
  }];
  
  // 操作前后如果 topViewController 没发生变化，则为它调用一个特殊的时机
  if (topViewController == viewControllers.lastObject) {
    if ([topViewController respondsToSelector:@selector(viewControllerKeepingAppearWhenSetViewControllersWithAnimated:)]) {
      [((UIViewController<UINavigationSceneDelegate> *)topViewController) viewControllerKeepingAppearWhenSetViewControllersWithAnimated:animated];
    }
  }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
  if (self.isViewControllerTransiting || !viewController) {
    NSLog(@"%@, 上一次界面切换的动画尚未结束就试图进行新的 push 操作，为了避免产生 bug，拦截了这次 push。\n%s, isViewControllerTransiting = %@, viewController = %@, self.viewControllers = %@", NSStringFromClass(self.class),  __func__, @(self.isViewControllerTransiting), viewController, self.viewControllers);
    return;
  }
  
  if (animated) {
    self.isViewControllerTransiting = YES;
  }
  
  UIViewController *currentViewController = self.topViewController;
  if (currentViewController) {
    if (!NeedsBackBarButtonItemTitle) {
      currentViewController.navigationItem.backBarButtonItem = [UINavigationButton barButtonItemWithType:UINavigationButtonTypeNormal title:@"" position:UINavigationButtonPositionLeft target:nil action:NULL];
    } else {
      UIViewController<UINavigationSceneDelegate> *vc = (UIViewController<UINavigationSceneDelegate> *)viewController;
      if ([vc respondsToSelector:@selector(backBarButtonItemTitleWithPreviousViewController:)]) {
        NSString *title = [vc backBarButtonItemTitleWithPreviousViewController:currentViewController];
        currentViewController.navigationItem.backBarButtonItem = [UINavigationButton barButtonItemWithType:UINavigationButtonTypeNormal title:title position:UINavigationButtonPositionLeft target:nil action:NULL];
      }
    }
  }
  [super pushViewController:viewController animated:animated];
}

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
  self.delegateProxy = delegate != self ? delegate : nil;
  [super setDelegate:delegate ? self : nil];
}

// 重写这个方法才能让 viewControllers 对 statusBar 的控制生效
- (UIViewController *)childViewControllerForStatusBarStyle {
  return self.topViewController;
}

#pragma mark - 自定义方法

// 接管系统手势返回的回调
- (void)handleInteractivePopGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
  UIGestureRecognizerState state = gestureRecognizer.state;
  if (state == UIGestureRecognizerStateBegan) {
    [self.viewControllerPopping addObserver:self forKeyPath:@"isViewWillAppear" options:NSKeyValueObservingOptionNew context:nil];
  } else if (state == UIGestureRecognizerStateEnded) {
    if (CGRectGetMinX(self.topViewController.view.superview.frame) < 0) {
      // by molice:只是碰巧发现如果是手势返回取消时，不管在哪个位置取消，self.topViewController.view.superview.frame.orgin.x必定是-124，所以用这个<0的条件来判断
      NSLog(@"手势返回放弃了");
    } else {
      NSLog(@"执行手势返回");
    }
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
  if ([keyPath isEqualToString:@"isViewWillAppear"]) {
    [self.viewControllerPopping removeObserver:self forKeyPath:@"isViewWillAppear"];
    NSNumber *newValue = change[NSKeyValueChangeNewKey];
    if (newValue.boolValue) {
      [self navigationController:self willShowViewController:self.viewControllerPopping animated:YES];
      self.viewControllerPopping = nil;
      self.isViewControllerTransiting = NO;
    }
  }
}

#pragma mark - <UINavigationControllerDelegate>

// 注意如果实现了某一个navigationController的delegate方法，必须同时检查并且调用delegateProxy相对应的方法

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
  [self willShowViewController:viewController animated:animated];
  if ([self.delegateProxy respondsToSelector:_cmd]) {
    [self.delegateProxy navigationController:navigationController willShowViewController:viewController animated:animated];
  }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
  self.viewControllerPopping = nil;
  self.isViewControllerTransiting = NO;
  [self didShowViewController:viewController animated:animated];
  if ([self.delegateProxy respondsToSelector:_cmd]) {
    [self.delegateProxy navigationController:navigationController didShowViewController:viewController animated:animated];
  }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
  return [super methodSignatureForSelector:aSelector] ?: [(id)self.delegateProxy methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
  if ([(id)self.delegateProxy respondsToSelector:anInvocation.selector]) {
    [anInvocation invokeWithTarget:(id)self.delegateProxy];
  }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
  return [super respondsToSelector:aSelector] || ([self shouldRespondDelegeateProxyWithSelector:aSelector] && [self.delegateProxy respondsToSelector:aSelector]);
}

- (BOOL)shouldRespondDelegeateProxyWithSelector:(SEL)aSelctor {
  // 目前仅支持下面两个delegate方法，如果需要增加全局的自定义转场动画，可以额外增加多上面注释的两个方法。
  return [NSStringFromSelector(aSelctor) isEqualToString:@"navigationController:willShowViewController:animated:"] ||
  [NSStringFromSelector(aSelctor) isEqualToString:@"navigationController:didShowViewController:animated:"];
}

#pragma mark - 屏幕旋转

- (BOOL)shouldAutorotate {
  return [self.topViewController hasOverrideUIKitMethod:_cmd] ? [self.topViewController shouldAutorotate] : YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return [self.topViewController hasOverrideUIKitMethod:_cmd] ? [self.topViewController supportedInterfaceOrientations] : UIInterfaceOrientationMaskPortrait;
}

  
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end

