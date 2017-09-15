//
//  ViewController.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "UINavigationScene.h"
#import "UITabBarScene.h"
#import "IndexScene.h"
#import "MineScene.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  IndexScene *index = IndexScene.alloc.init;
  UINavigationScene *indexNavigation = [UINavigationScene.alloc initWithRootViewController:index];
  
  IndexScene *mine = IndexScene.alloc.init;
  UINavigationScene *mineNavigation = [UINavigationScene.alloc initWithRootViewController:mine];
  
  UITabBarScene *tab = UITabBarScene.alloc.init;
  tab.viewControllers = @[indexNavigation,mineNavigation];
  
  [((AppDelegate *)[UIApplication sharedApplication].delegate).window setRootViewController:tab];
  [((AppDelegate *)[UIApplication sharedApplication].delegate).window makeKeyAndVisible];
  
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


@end
