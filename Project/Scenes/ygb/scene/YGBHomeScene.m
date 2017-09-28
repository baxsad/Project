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
@property (nonatomic, strong) UICustomLable *timeTitleLable;
@property (nonatomic, strong) UICustomLable *descSubTitleLable;
@property (nonatomic, strong) UIView *exhibitionContentView;
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
  
  self.exhibitionContentView = [UIView new];
  self.exhibitionContentView.backgroundColor = UIColorLink;
  UIImage *icon = [UIImage imageNamed:@"huaji"];
  self.exhibitionContentView.layer.contents = (__bridge id _Nullable)(icon.CGImage);
  [self.view addSubview:self.exhibitionContentView];
  
  self.descSubTitleLable = [[UICustomLable alloc] init];
  self.descSubTitleLable.font = UIFontMake(17);
  self.descSubTitleLable.textColor = UIColorWhite;
  self.descSubTitleLable.textAlignment = NSTextAlignmentCenter;
  self.descSubTitleLable.numberOfLines = 0;
  self.descSubTitleLable.text = @"もしあなたは YGB、どうぞここでそれをあなたとの APP マッチング";
  [self.view addSubview:self.descSubTitleLable];
  
  self.timeTitleLable = [[UICustomLable alloc] init];
  self.timeTitleLable.font = UIFontBoldMake(25);
  self.timeTitleLable.textColor = UIColorWhite;
  self.timeTitleLable.textAlignment = NSTextAlignmentCenter;
  self.timeTitleLable.numberOfLines = 1;
  self.timeTitleLable.text = @"こんにちは";
  [self.view addSubview:self.timeTitleLable];
  
  self.scanButton = [[UICustomButton alloc] init];
  self.scanButton.backgroundColor = UIColorMake(66, 68, 77);
  self.scanButton.layer.cornerRadius = 3;
  self.scanButton.layer.masksToBounds = YES;
  [self.scanButton setTitle:@"始めマッチング" forState:UIControlStateNormal];
  [self.scanButton.titleLabel setFont:UIFontBoldMake(16)];
  self.scanButton.tintColorAdjustsTitleAndImage =UIColorMake(255, 255, 255);
  [self.scanButton addTarget:self action:@selector(scanButtonTouchAction:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.scanButton];
  
  self.learnMoreButton = [[UICustomButton alloc] init];
  self.learnMoreButton.backgroundColor = UIColorClear;
  [self.learnMoreButton setTitle:@"さらに理解する" forState:UIControlStateNormal];
  [self.learnMoreButton.titleLabel setFont:UIFontMake(15)];
  self.learnMoreButton.tintColorAdjustsTitleAndImage =UIColorMake(204, 130, 70);
  [self.view addSubview:self.learnMoreButton];
  
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  self.exhibitionContentView.size = CGSizeMake(SCREEN_WIDTH-120, SCREEN_WIDTH-120);
  self.exhibitionContentView.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0);
  
  CGSize descSizeFit = [self.descSubTitleLable sizeThatFits:CGSizeMake(self.exhibitionContentView.width, CGFLOAT_MAX)];
  self.descSubTitleLable.size = descSizeFit;
  self.descSubTitleLable.bottom = self.exhibitionContentView.top - 15;
  self.descSubTitleLable.centerX = self.exhibitionContentView.centerX;
  
  CGSize timeTitleSizeFit = [self.timeTitleLable sizeThatFits:CGSizeMake(self.exhibitionContentView.width, CGFLOAT_MAX)];
  self.timeTitleLable.size = timeTitleSizeFit;
  self.timeTitleLable.bottom = self.descSubTitleLable.top - 15;
  self.timeTitleLable.centerX = self.exhibitionContentView.centerX;
  
  self.scanButton.left = 30;
  self.scanButton.width = SCREEN_WIDTH - 60;
  self.scanButton.height = 50;
  self.scanButton.top = self.exhibitionContentView.bottom + 30;
  
  self.learnMoreButton.left = 50;
  self.learnMoreButton.width = SCREEN_WIDTH - 100;
  self.learnMoreButton.height = 35;
  self.learnMoreButton.top = self.scanButton.bottom + 10;
}

- (void)scanButtonTouchAction:(id)sender
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
  return [UIImage imageWithColor:UIColorClear];
}

@end
