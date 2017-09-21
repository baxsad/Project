//
//  UIScene.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "UIScene.h"

@interface UIScene ()

@end

@implementation UIScene

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = SceneBackgroundColor;
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.edgesForExtendedLayout = UIRectEdgeAll;
  
//  if (self.navigationController) {
//    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    fixedSpace.width = -20;
//    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithImage:[NavBarBackIndicatorImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonTouch)];
//
//    self.navigationItem.leftBarButtonItem = nil;
//    self.navigationItem.leftBarButtonItems = @[fixedSpace,barbutton];
//    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] !=
//        NSOrderedAscending) {
//      self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    }
//  }
  
}

//- (void)leftButtonTouch
//{
//  [self.navigationController popViewControllerAnimated:YES];
//}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
