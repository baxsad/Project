//
//  UIConfigurationManager.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "UIConfigurationManager.h"
#import "UICommonDefines.h"
#import "UIConfiguration.h"
#import "UIImage+UIConfig.h"

#define _UIColorMake(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define _UIFontMake(size) [UIFont systemFontOfSize:size]
#define _UIFontMediumMake(fontSize) [UIFont fontWithName:[[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? @"PingFangSC-Medium" : @"HelveticaNeue-Medium" size:fontSize]

@implementation UIConfigurationManager

+ (UIConfigurationManager *)sharedInstance
{
  static UIConfigurationManager *shareInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    shareInstance = [[UIConfigurationManager alloc] init];
  });
  return shareInstance;
}

- (void)initDefaultConfiguration
{
  self.clearColor = _UIColorMake(255.0,255.0,255.0,0.0);
  self.whiteColor = _UIColorMake(255.0,255.0,255.0,1.0);
  self.blackColor = _UIColorMake(0.0,0.0,0.0,1.0);
  self.grayColor  = _UIColorMake(179.0,179.0,179.0,1.0);
  self.grayDarkenColor  = _UIColorMake(163.0,163.0,163.0,1.0);
  self.grayLightenColor  = _UIColorMake(198.0,198.0,198.0,1.0);
  self.redColor  = _UIColorMake(227.0,40.0,40.0,1.0);
  self.greenColor  = _UIColorMake(79.0,214.0,79.0,1.0);
  self.blueColor  = _UIColorMake(43.0,133.0,208.0,1.0);
  self.yellowColor  = _UIColorMake(255.0,252.0,233.0,1.0);
  
  self.appMainColor = _UIColorMake(0xFF, 0xE4, 0X01, 1.0);
  self.textPlaceholderColor = _UIColorMake(187.0,187.0,187.0,1.0);
  self.imagePlaceholderColor = _UIColorMake(238.0,238.0,238.0,1.0);
  
  self.sceneBackgroundColor = _UIColorMake(255.0,255.0,255.0,1.0);
  
  self.tableViewBackgroundColor = _UIColorMake(255.0,255.0,255.0,1.0);
  self.tableViewSeparatorColor = _UIColorMake(0XEF,0XEF,0XF4,1.0);
  self.tableViewCellBackgroundColor = _UIColorMake(255.0,255.0,255.0,1.0);
  self.tableViewCellSelectedBackgroundColor = _UIColorMake(232.0,232.0,232.0,1.0);
  
  self.buttonHighlightedAlpha = 0.5f;
  self.buttonDisabledAlpha = 0.5f;
  
  self.toolBarTintColor = _UIColorMake(244,244,244,1.0);
  
  self.navBarHighlightedAlpha = 0.2f;
  self.navBarDisabledAlpha = 0.2f;
  self.navBarButtonFont = _UIFontMake(15);
  self.navBarButtonFontBold = _UIFontMediumMake(15);
  self.navBarBackgroundImage = [UIImage ui_imageWithColor:_UIColorMake(0xFF, 0xE4, 0X01, 1.0)
                                                     size:CGSizeMake(1, 1)
                                             cornerRadius:0];
  self.navBarShadowImageColor = _UIColorMake(255.0,255.0,255.0,0.0);
  self.navBarBarTintColor = _UIColorMake(40,43,53,1.0);
  self.navBarTintColor = _UIColorMake(244,244,244,1.0);
  self.navBarTitleColor = _UIColorMake(0xff,0xff,0xff,1.0);
  self.navBarTitleFont = _UIFontMediumMake(18);
  self.navBarSubTitleColor = _UIColorMake(0x97,0x97,0x97,1.0);
  self.navBarSubTitleFont = _UIFontMake(12);
  self.navBarBackButtonTitlePositionAdjustment = UIOffsetZero;
  self.navBarBackButtonMarginLeft = 10;
  self.navBarBackIndicatorImage = [UIImage ui_imageWithShape:UIImageShapeNavBack
                                                        size:CGSizeMake(9, 16)
                                                   tintColor:self.navBarTintColor];
  self.navBarCloseButtonImage = [UIImage ui_imageWithShape:UIImageShapeNavClose
                                                      size:CGSizeMake(14, 14)
                                                 tintColor:self.navBarTintColor];
  self.navBarAddButtonImage = [UIImage ui_imageWithShape:UIImageShapeNavAdd
                                                    size:CGSizeMake(14, 14)
                                               tintColor:self.navBarTintColor];
  self.navBarButtonItemNormallColor = _UIColorMake(255.0,255.0,255.0,0.0);
  self.navBarButtonItemHighlightedColor = _UIColorMake(255.0,255.0,255.0,0.0);
  self.navBarButtonItemDisabledColor = _UIColorMake(255.0,255.0,255.0,0.0);
  self.navBarButtonItemTitleFont = _UIFontMake(17);
  self.needsBackBarButtonItemTitle = NO;
  self.navigationBarHiddenInitially = NO;
  self.hidesBottomBarWhenPushedInitially = YES;
  
  self.statusbarStyleLightInitially = YES;
  
  self.tabBarBarTintColor = _UIColorMake(40,43,53,1.0);
  self.tabBarBackgroundImage = [UIImage ui_imageWithColor:self.tabBarBarTintColor
                                                     size:CGSizeMake(1, 1)
                                             cornerRadius:0];
  self.tabBarShadowImageColor = _UIColorMake(255.0,255.0,255.0,0.0);
  self.tabBarTintColor = _UIColorMake(0xFF,0xE4,0x01,1.0);
  self.tabBarItemTitleColor = _UIColorMake(0x27,0x27,0x27,1.0);
  self.tabBarItemTitleColorSelected = _UIColorMake(0x27,0x27,0x27,1.0);
}

@end

@implementation UIConfigurationManager (UIAppearance)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
  
- (void)renderGlobalAppearances
{
  // 设置统一返回按钮
  [self renderNavigationButtonAppearanceStyle];
  
  // UINavigationBar buttonItem
  UIBarButtonItem *barButtonItemAppearance = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationController class], nil];;
  [barButtonItemAppearance setTitleTextAttributes:@{NSForegroundColorAttributeName: NavBarButtonItemNormallColor}
                                         forState:UIControlStateNormal];
  [barButtonItemAppearance setTitleTextAttributes:@{NSForegroundColorAttributeName: NavBarButtonItemHighlightedColor}
                                         forState:UIControlStateHighlighted];
  [barButtonItemAppearance setTitleTextAttributes:@{NSForegroundColorAttributeName: NavBarButtonItemDisabledColor}
                                         forState:UIControlStateDisabled];
  
  // UINavigationBar
  UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
  navigationBarAppearance.translucent = YES;
  [navigationBarAppearance setBarTintColor:NavBarBarTintColor];
  [navigationBarAppearance setShadowImage:[UIImage ui_imageWithColor:NavBarShadowImageColor size:CGSizeMake(1, PixelOne()) cornerRadius:0]];
  [navigationBarAppearance setTitleTextAttributes:@{NSFontAttributeName:NavBarTitleFont,NSForegroundColorAttributeName:NavBarTitleColor}];
  [navigationBarAppearance setTintColor:NavBarTintColor];
  
  // UITabBar
  UITabBar *tabBarAppearance = [UITabBar appearance];
  [tabBarAppearance setBarTintColor:TabBarBarTintColor];
  [tabBarAppearance setBackgroundImage:TabBarBackgroundImage];
  [tabBarAppearance setShadowImage:[UIImage ui_imageWithColor:TabBarShadowImageColor size:CGSizeMake(1, PixelOne()) cornerRadius:0]];
  
  // UITabBarItem
  UITabBarItem *tabBarItemAppearance = [UITabBarItem appearanceWhenContainedIn:[UITabBarController class], nil];
  [tabBarItemAppearance setTitleTextAttributes:@{NSForegroundColorAttributeName:TabBarItemTitleColor} forState:UIControlStateNormal];
  [tabBarItemAppearance setTitleTextAttributes:@{NSForegroundColorAttributeName:TabBarItemTitleColorSelected} forState:UIControlStateSelected];
}
  
- (void)renderNavigationButtonAppearanceStyle
{
  // 更改全局的返回按钮图片
  UIImage *customBackIndicatorImage = NavBarBackIndicatorImage;
  if (customBackIndicatorImage && [UINavigationBar instancesRespondToSelector:@selector(setBackIndicatorImage:)]) {
    UINavigationBar *navBarAppearance = [UINavigationBar appearanceWhenContainedIn:[UINavigationController class], nil];

    // 返回按钮的图片frame是和系统默认的返回图片的大小一致的（13, 21），所以用自定义返回箭头时要保证图片大小与系统的箭头大小一样，否则无法对齐
    CGSize systemBackIndicatorImageSize = CGSizeMake(13, 21); // 在iOS9上实际测量得到
    CGSize customBackIndicatorImageSize = customBackIndicatorImage.size;
    if (!CGSizeEqualToSize(customBackIndicatorImageSize, systemBackIndicatorImageSize)) {
      CGFloat imageExtensionVerticalFloat = CGFloatGetCenter(systemBackIndicatorImageSize.height, customBackIndicatorImageSize.height);
      customBackIndicatorImage = [customBackIndicatorImage ui_imageWithSpacingExtensionInsets:UIEdgeInsetsMake(imageExtensionVerticalFloat,
                                                                                                               NavBarBackButtonMarginLeft,
                                                                                                               imageExtensionVerticalFloat,
                                                                                                               systemBackIndicatorImageSize.width - customBackIndicatorImageSize.width)];
    }

    navBarAppearance.backIndicatorImage = [customBackIndicatorImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navBarAppearance.backIndicatorTransitionMaskImage = navBarAppearance.backIndicatorImage;
  }
  
  // 更改全局返回按钮的文字间距
//  UIBarButtonItem *backBarButtonItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationController class], nil];
//  [backBarButtonItem setBackButtonTitlePositionAdjustment:NavBarBackButtonTitlePositionAdjustment
//                                            forBarMetrics:UIBarMetricsDefault];
}
  
#pragma clang diagnostic pop

@end
