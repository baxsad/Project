//
//  NextScene.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "NextScene.h"
#import "UIImage+UIConfig.h"

@interface NextScene ()

@end

@implementation NextScene

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navBarBarTintColor = UIColorBlue;
  self.navBarBackgroundAlpha = 1.0;
  self.statusBarStyle = UIStatusBarStyleLightContent;
  
  UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 100, 50)];
  btn.backgroundColor = UIColorRed;
  [btn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:btn];
  
}

- (void)action
{
  //[self setNavBarHidden:!self.navBarHidden animation:YES];
}
  
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
