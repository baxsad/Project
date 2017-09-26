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
  index.hidesBottomBarWhenPushed = NO;
  UINavigationScene *indexNavigation = [UINavigationScene.alloc initWithRootViewController:index];
  indexNavigation.tabBarItem = [UIHelper tabBarItemWithTitle:@"Examples" image:UIImageMake(@"icon_tabbar_component") selectedImage:UIImageMake(@"icon_tabbar_component_selected") tag:0];
  
  MineScene *mine = MineScene.alloc.init;
  mine.hidesBottomBarWhenPushed = NO;
  UINavigationScene *mineNavigation = [UINavigationScene.alloc initWithRootViewController:mine];
  mineNavigation.tabBarItem = [UIHelper tabBarItemWithTitle:@"Laboratory" image:UIImageMake(@"icon_tabbar_lab") selectedImage:UIImageMake(@"icon_tabbar_lab_selected") tag:1];
  
  UITabBarScene *tab = UITabBarScene.alloc.init;
  tab.viewControllers = @[indexNavigation,mineNavigation];
  
  [((AppDelegate *)[UIApplication sharedApplication].delegate).window setRootViewController:tab];
  [((AppDelegate *)[UIApplication sharedApplication].delegate).window makeKeyAndVisible];
  
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


@end
