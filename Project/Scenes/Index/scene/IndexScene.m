//
//  IndexScene.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "IndexScene.h"
#import "NextScene.h"

@interface IndexScene ()
@end

@implementation IndexScene

- (void)viewDidLoad {
  [super viewDidLoad];
  self.titleView.needsLoadingView = YES;
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
  [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
  self.title = @"Examples";
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
