//
//  UIScene.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "UIScene.h"
#import "UINavigationScene.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation UIViewController (UI)

#pragma mark - Public

- (UIViewController *)previousViewController {
  if (self.navigationController.viewControllers && self.navigationController.viewControllers.count > 1 && self.navigationController.topViewController == self) {
    NSUInteger count = self.navigationController.viewControllers.count;
    return (UIViewController *)[self.navigationController.viewControllers objectAtIndex:count - 2];
  }
  return nil;
}

- (NSString *)previousViewControllerTitle {
  UIViewController *previousViewController = [self previousViewController];
  if (previousViewController) {
    return previousViewController.title;
  }
  return nil;
}

- (BOOL)isPresented {
  UIViewController *viewController = self;
  if (self.navigationController) {
    if (self.navigationController.rootViewController != self) {
      return NO;
    }
    viewController = self.navigationController;
  }
  BOOL result = viewController.presentingViewController.presentedViewController == viewController;
  return result;
}

- (UIViewController *)visibleViewControllerIfExist {
  
  if (self.presentedViewController) {
    return [self.presentedViewController visibleViewControllerIfExist];
  }
  
  if ([self isKindOfClass:[UINavigationController class]]) {
    return [((UINavigationController *)self).visibleViewController visibleViewControllerIfExist];
  }
  
  if ([self isKindOfClass:[UITabBarController class]]) {
    return [((UITabBarController *)self).selectedViewController visibleViewControllerIfExist];
  }
  
  if ([self isViewLoaded] && self.view.window) {
    return self;
  } else {
    NSLog(@"visibleViewControllerIfExist:，找不到可见的viewController。self = %@, self.view.window = %@", self, self.view.window);
    return nil;
  }
}

- (BOOL)isViewLoadedAndVisible {
  return self.isViewLoaded && self.view.window;
}

@end

@implementation UIViewController (Runtime)

- (BOOL)hasOverrideUIKitMethod:(SEL)selector {
  NSMutableArray<Class> *viewControllerSuperclasses = [[NSMutableArray alloc] initWithObjects:
                                                       [UIImagePickerController class],
                                                       [UINavigationController class],
                                                       [UITableViewController class],
                                                       [UICollectionViewController class],
                                                       [UITabBarController class],
                                                       [UISplitViewController class],
                                                       [UIPageViewController class],
                                                       [UIViewController class],
                                                       nil];
  
  if (NSClassFromString(@"UIAlertController")) {
    [viewControllerSuperclasses addObject:[UIAlertController class]];
  }
  if (NSClassFromString(@"UISearchController")) {
    [viewControllerSuperclasses addObject:[UISearchController class]];
  }
  for (NSInteger i = 0, l = viewControllerSuperclasses.count; i < l; i++) {
    Class superclass = viewControllerSuperclasses[i];
    if ([self hasOverrideMethod:selector ofSuperclass:superclass]) {
      return YES;
    }
  }
  return NO;
}

- (BOOL)hasOverrideMethod:(SEL)selector ofSuperclass:(Class)superclass {
  if (![[self class] isSubclassOfClass:superclass]) {
    return NO;
  }
  
  if (![superclass instancesRespondToSelector:selector]) {
    return NO;
  }
  
  Method superclassMethod = class_getInstanceMethod(superclass, selector);
  Method instanceMethod = class_getInstanceMethod([self class], selector);
  if (!instanceMethod || instanceMethod == superclassMethod) {
    return NO;
  }
  return YES;
}

@end

@implementation UIViewController (Hooks)
- (void)initSubviews {}
- (void)contentSizeCategoryDidChanged:(NSNotification *)notification {}
@end

@interface UIScene ()
@end

@implementation UIScene
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - 生命周期

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    [self didInitialized];
  }
  return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  if (self = [super initWithCoder:aDecoder]) {
    [self didInitialized];
  }
  return self;
}
- (void)didInitialized
{
  self.hidesBottomBarWhenPushed = HidesBottomBarWhenPushedInitially;
  self.extendedLayoutIncludesOpaqueBars = YES;
  self.automaticallyAdjustsScrollViewInsets = NO;
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(contentSizeCategoryDidChanged:)
                                               name:UIContentSizeCategoryDidChangeNotification
                                             object:nil];
  self.autorotate = NO;
  self.supportedOrientationMask = UIInterfaceOrientationMaskPortrait;
}
- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = SceneBackgroundColor;
}

#pragma mark - 屏幕旋转

- (BOOL)shouldAutorotate {
  return self.autorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return self.supportedOrientationMask;
}

#pragma mark - <UINavigationControllerDelegate>

- (BOOL)shouldSetStatusBarStyleLight {
  return StatusbarStyleLightInitially;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return StatusbarStyleLightInitially ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (BOOL)preferredNavigationBarHidden {
  return NavigationBarHiddenInitially;
}

#pragma clang diagnostic pop
@end
