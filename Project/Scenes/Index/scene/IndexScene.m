//
//  IndexScene.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "IndexScene.h"
#import "NextScene.h"
#import "YGBHomeScene.h"
#import "TestView.h"

@interface IndexScene ()
@property(nonatomic,strong) TestView *test;
@end

@implementation IndexScene

- (void)viewDidLoad {
  [super viewDidLoad];
  self.titleView.needsLoadingView = YES;
  
  UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 100, 50)];
  btn.backgroundColor = UIColorRed;
  [btn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:btn];
  
  TestView *test = [[TestView alloc] initWithFrame:CGRectMake(20, 200, 100, 50)];
  test.backgroundColor = UIColorGreen;
  [self.view addSubview:test];
  self.test = test;
  
  UITextView *btn3 = [[UITextView alloc] initWithFrame:CGRectMake(20, 300, 100, 50)];
  btn3.backgroundColor = UIColorGrayLighten;
  [self.view addSubview:btn3];
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
  [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
  self.title = @"熒光棒";
}
  
- (void)action
{
  NextScene *next = NextScene.alloc.init;
  [self.navigationController pushViewController:next animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view
{
  if ([view isEqual:self.test]) {
    return YES;
  }
  return NO;
}

@end
