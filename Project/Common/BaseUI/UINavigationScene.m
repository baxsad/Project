//
//  UINavigationScene.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "UINavigationScene.h"
#import "UIScene.h"
#import <objc/runtime.h>

@interface UINavigationScene ()
@end

@implementation UINavigationScene
  
- (void)viewDidLoad {
  [super viewDidLoad];
}
  
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  if (self.viewControllers.count > 0) {
    viewController.hidesBottomBarWhenPushed = YES;
  }
  [super pushViewController:viewController animated:animated];
}

#pragma mark - getter
  
- (UIScene *)topScene
{
  return (UIScene *)self.topViewController;
}
  
- (UIScene *)visibleScene
{
  return (UIScene *)self.visibleViewController;
}
  
@end

