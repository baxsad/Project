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
@property (nonatomic, strong) UIButton *scanButton;
@end

@implementation YGBHomeScene

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _scanButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 100, 50)];
  _scanButton.backgroundColor = UIColorGray;
  [_scanButton addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_scanButton];
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

@end
