//
//  UIScene.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "UIScene.h"

@interface UIScene ()

@end

@implementation UIScene
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = SceneBackgroundColor;
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.edgesForExtendedLayout = UIRectEdgeAll;
}

#pragma mark - BarButtonItem

- (void)showBarButton:(NavBarItemPosition)position
                title:(NSString *)name
{
  [self showBarButton:position title:name color:NavBarTintColor];
}
- (void)showBarButton:(NavBarItemPosition)position
                title:(NSString *)name
                color:(UIColor *)color
{
  if (NavBarItemPositionLeft == position) {
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithTitle:name
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(leftButtonTouch)];
    [barbutton setTitleTextAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:NavBarButtonItemTitleFont}
                             forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = barbutton;
  }
  else if (NavBarItemPositionRight == position) {
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithTitle:name
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(rightButtonTouch)];
    [barbutton setTitleTextAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:NavBarButtonItemTitleFont}
                             forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem =barbutton;
  }
}
- (void)showBarButton:(NavBarItemPosition)position image:(UIImage *)image
{
  if (NavBarItemPositionLeft == position) {
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(leftButtonTouch)];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = barbutton;
  }
  else if (NavBarItemPositionRight == position) {
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(rightButtonTouch)];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = barbutton;
  }
}
- (void)showBarButton:(NavBarItemPosition)position button:(UIButton *)button
{
  if (NavBarItemPositionLeft == position) {
    [button addTarget:self
               action:@selector(leftButtonTouch)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithCustomView:button];
  }
  else if (NavBarItemPositionRight == position) {
    [button addTarget:self
               action:@selector(rightButtonTouch)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithCustomView:button];
  }
}

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}
- (void)leftButtonTouch{}
- (void)rightButtonTouch{}

#pragma clang diagnostic pop
@end
