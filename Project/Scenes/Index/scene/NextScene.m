//
//  NextScene.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "NextScene.h"

@interface NextScene ()

@end

@implementation NextScene

- (void)viewDidLoad {
  [super viewDidLoad];
  self.titleView.title = @"搜索";
}
  
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (BOOL)shouldCustomNavigationBarTransitionWhenPopAppearing
{
  return YES;
}

- (BOOL)shouldCustomNavigationBarTransitionWhenPushAppearing
{
  return YES;
}

- (BOOL)shouldCustomNavigationBarTransitionWhenPopDisappearing
{
  return YES;
}

- (BOOL)shouldCustomNavigationBarTransitionWhenPushDisappearing
{
  return YES;
}

- (UIImage *)navigationBarBackgroundImage
{
  return [UIImage ui_imageWithColor:UIColorGreen];
}
@end
