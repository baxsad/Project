//
//  IndexScene.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "IndexScene.h"
#import "NextScene.h"
#import "TestView.h"

@interface IndexScene ()

@end

@implementation IndexScene

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 100, 50)];
  btn.backgroundColor = UIColorRed;
  [btn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:btn];
  
  UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, 100, 50)];
  btn2.backgroundColor = UIColorBlue;
  [btn2 addTarget:self action:@selector(action2) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:btn2];
  
  TestView *test = [[TestView alloc] initWithFrame:CGRectMake(20, 300, 100, 50)];
  test.backgroundColor = UIColorGreen;
  [self.view addSubview:test];
  [[test rac_signalForSelector:@selector(buttonClick)] subscribeNext:^(id x) {
    NSLog(@"ddd");
  }];
  
  self.navBarBarTintColor = UIColorRed;
  self.navBarBackgroundAlpha = 1.0;
  self.statusBarStyle = UIStatusBarStyleDefault;
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}
  
- (void)action
{
  NextScene *next = NextScene.alloc.init;
  [self.navigationController pushViewController:next animated:YES];
}
  
- (void)action2
{
  [self setNavBarHidden:!self.navBarHidden animation:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
