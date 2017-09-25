//
//  MineScene.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "MineScene.h"
@interface MineScene ()

@end

@implementation MineScene

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
  [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
  self.title = @"實驗室";
  self.navigationItem.rightBarButtonItem = [UINavigationButton barButtonItemWithImage:UIImageMake(@"icon_nav_about")
                                                                             position:UINavigationButtonPositionRight
                                                                               target:self
                                                                               action:@selector(handleAboutItemEvent)];
}

- (void)handleAboutItemEvent
{
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
