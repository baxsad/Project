//
//  YGBHomeScene.m
//  Project
//
//  Created by jearoc on 2017/9/19.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "YGBHomeScene.h"
#import "UITableScene.h"
#import "YGBQRCodeScanScene.h"

@interface YGBHomeScene ()
@property (nonatomic, strong) UICustomButton *scanButton;
@property (nonatomic, strong) UICustomButton *learnMoreButton;
@end

@implementation YGBHomeScene

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = UIColorMake(36, 38, 47);
}

- (void)initSubviews
{
  [super initSubviews];
  self.learnMoreButton = [[UICustomButton alloc] init];
  self.learnMoreButton.left = 50;
  self.learnMoreButton.width = SCREEN_WIDTH - 100;
  self.learnMoreButton.height = 50;
  self.learnMoreButton.bottom = SCREEN_HEIGHT - self.learnMoreButton.height - 30;
  self.learnMoreButton.backgroundColor = UIColorClear;
  [self.learnMoreButton setTitle:@"进一步了解 Ying Guangbang" forState:UIControlStateNormal];
  [self.learnMoreButton.titleLabel setFont:UIFontMake(15)];
  self.learnMoreButton.tintColorAdjustsTitleAndImage =UIColorMake(204, 130, 70);
  [self.view addSubview:self.learnMoreButton];
  
}

- (void)action
{
  YGBQRCodeScanScene *qr = YGBQRCodeScanScene.alloc.init;
  [self.navigationController pushViewController:qr animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
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
  return [UIImage imageWithColor:UIColorMake(36, 38, 47)];
}

@end
