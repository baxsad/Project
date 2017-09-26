//
//  UIScene+UI.m
//  Project
//
//  Created by jearoc on 2017/9/25.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "UIScene+UI.h"
#import "UINavigationScene+UI.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation UIViewController (UI)

#pragma mark - Public

- (UIViewController *)previousViewController {
  if (self.navigationController.viewControllers &&
      self.navigationController.viewControllers.count > 1 &&
      self.navigationController.topViewController == self) {
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
  
  if ([self isViewLoadedAndVisible]) {
    return self;
  } else {
    NSLog(@"visibleViewControllerIfExist:，找不到可见的viewController。self = %@, window = %@", self,self.view.window);
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

@implementation UIScene (Hooks)
- (void)initSubviews {}
- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
  self.navigationItem.titleView = self.titleView;
}
- (void)setToolbarItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {}
- (void)contentSizeCategoryDidChanged:(NSNotification *)notification {}
@end

@implementation UIViewController (Handler)
- (BOOL)shouldHoldBackButtonEven{ return NO;}
- (BOOL)canPopViewController{ return YES;}
- (BOOL)forceEnableInteractivePopGestureRecognizer{ return NO;}
@end
