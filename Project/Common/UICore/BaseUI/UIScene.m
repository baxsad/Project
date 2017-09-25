//
//  UIScene.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "UIScene.h"
#import "UIScene+UI.h"
#import "UINavigationScene.h"

@interface UIScene ()
@property(nonatomic,strong,readwrite) UINavigationTitleView *titleView;
@end

@implementation UIScene
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - 生命周期

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    [self didInitialized];
  }
  return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  if (self = [super initWithCoder:aDecoder]) {
    [self didInitialized];
  }
  return self;
}
- (void)didInitialized
{
  self.titleView = [[UINavigationTitleView alloc] init];
  self.titleView.title = self.title;
  
  self.hidesBottomBarWhenPushed = HidesBottomBarWhenPushedInitially;
  self.extendedLayoutIncludesOpaqueBars = YES;
  self.automaticallyAdjustsScrollViewInsets = NO;
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(contentSizeCategoryDidChanged:)
                                               name:UIContentSizeCategoryDidChangeNotification
                                             object:nil];
  self.autorotate = NO;
  self.supportedOrientationMask = UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setNavigationItemsIsInEditMode:NO animated:NO];
  [self setToolbarItemsIsInEditMode:NO animated:NO];
}

- (void)setTitle:(NSString *)title {
  [super setTitle:title];
  self.titleView.title = title;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = UIColorForBackground;
}

#pragma mark - 屏幕旋转

- (BOOL)shouldAutorotate {
  return self.autorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return self.supportedOrientationMask;
}

#pragma mark - <UINavigationControllerDelegate>

- (BOOL)shouldSetStatusBarStyleLight {
  return StatusbarStyleLightInitially;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return StatusbarStyleLightInitially ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (BOOL)preferredNavigationBarHidden {
  return NavigationBarHiddenInitially;
}

- (void)viewControllerKeepingAppearWhenSetViewControllersWithAnimated:(BOOL)animated {
  [self setNavigationItemsIsInEditMode:NO animated:NO];
  [self setToolbarItemsIsInEditMode:NO animated:NO];
}

#pragma clang diagnostic pop
@end
