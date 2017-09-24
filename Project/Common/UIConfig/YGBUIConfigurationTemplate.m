//
//  YGBUIConfigurationTemplate.m
//  Project
//
//  Created by pmo on 2017/9/24.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "YGBUIConfigurationTemplate.h"
#import "UIConfigurationMacros.h"
#import "UICommonDefines.h"
#import "UIImage+UIConfig.h"
#import "UIHelper.h"

#define UIColorGray1 UIColorMake(53, 60, 70)
#define UIColorGray2 UIColorMake(73, 80, 90)
#define UIColorGray3 UIColorMake(93, 100, 110)
#define UIColorGray4 UIColorMake(113, 120, 130)
#define UIColorGray5 UIColorMake(133, 140, 150)
#define UIColorGray6 UIColorMake(153, 160, 170)
#define UIColorGray7 UIColorMake(173, 180, 190)
#define UIColorGray8 UIColorMake(196, 200, 208)
#define UIColorGray9 UIColorMake(216, 220, 228)

#define UIColorTheme1 UIColorMake(239, 83, 98) // Grapefruit
#define UIColorTheme2 UIColorMake(254, 109, 75) // Bittersweet
#define UIColorTheme3 UIColorMake(255, 207, 71) // Sunflower
#define UIColorTheme4 UIColorMake(159, 214, 97) // Grass
#define UIColorTheme5 UIColorMake(63, 208, 173) // Mint
#define UIColorTheme6 UIColorMake(49, 189, 243) // Aqua
#define UIColorTheme7 UIColorMake(90, 154, 239) // Blue Jeans
#define UIColorTheme8 UIColorMake(172, 143, 239) // Lavender
#define UIColorTheme9 UIColorMake(238, 133, 193) // Pink Rose

@implementation YGBUIConfigurationTemplate

- (void)setupConfigurationTemplate {
  
  // === 修改配置值 === //
  
#pragma mark - Global Color
  
  UICMI.clearColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
  UICMI.whiteColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
  UICMI.blackColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
  UICMI.grayColor = UIColorGray4;
  UICMI.grayDarkenColor = UIColorGray3;
  UICMI.grayLightenColor = UIColorGray7;
  UICMI.redColor = UIColorMake(250, 58, 58);
  UICMI.greenColor = UIColorTheme4;
  UICMI.blueColor = UIColorMake(49, 189, 243);
  UICMI.yellowColor = UIColorTheme3;
  
  UICMI.linkColor = UIColorMake(56, 116, 171);
  UICMI.disabledColor = UIColorGray;
  UICMI.backgroundColor = UIColorWhite;
  UICMI.maskDarkColor = UIColorMakeWithRGBA(0, 0, 0, .35f);
  UICMI.maskLightColor = UIColorMakeWithRGBA(255, 255, 255, .5f);
  UICMI.separatorColor = UIColorMake(222, 224, 226);
  UICMI.separatorDashedColor = UIColorMake(17, 17, 17);
  UICMI.placeholderColor = UIColorGray8;
  
  // 测试用的颜色
  UICMI.testColorRed = UIColorMakeWithRGBA(255, 0, 0, .3);
  UICMI.testColorGreen = UIColorMakeWithRGBA(0, 255, 0, .3);
  UICMI.testColorBlue = UIColorMakeWithRGBA(0, 0, 255, .3);
  
  
#pragma mark - UIControl
  
  UICMI.controlHighlightedAlpha = 0.5f;
  UICMI.controlDisabledAlpha = 0.5f;
  
#pragma mark - UIButton
  UICMI.buttonHighlightedAlpha = UIControlHighlightedAlpha;
  UICMI.buttonDisabledAlpha = UIControlDisabledAlpha;
  UICMI.buttonTintColor = self.themeTintColor;
  
  UICMI.ghostButtonColorBlue = UIColorBlue;
  UICMI.ghostButtonColorRed = UIColorRed;
  UICMI.ghostButtonColorGreen = UIColorGreen;
  UICMI.ghostButtonColorGray = UIColorGray;
  UICMI.ghostButtonColorWhite = UIColorWhite;
  
  UICMI.fillButtonColorBlue = UIColorBlue;
  UICMI.fillButtonColorRed = UIColorRed;
  UICMI.fillButtonColorGreen = UIColorGreen;
  UICMI.fillButtonColorGray = UIColorGray;
  UICMI.fillButtonColorWhite = UIColorWhite;
  
  
#pragma mark - TextField & TextView
  UICMI.textFieldTintColor = self.themeTintColor;
  UICMI.textFieldTextInsets = UIEdgeInsetsMake(0, 7, 0, 7);
  
#pragma mark - NavigationBar
  
  UICMI.navBarHighlightedAlpha = 0.2f;
  UICMI.navBarDisabledAlpha = 0.2f;
  UICMI.navBarButtonFont = UIFontMake(17);
  UICMI.navBarButtonFontBold = UIFontBoldMake(17);
  UICMI.navBarBackgroundImage = [UIHelper navigationBarBackgroundImageWithThemeColor:self.themeTintColor];
  UICMI.navBarShadowImage = [UIImage new];
  UICMI.navBarBarTintColor = nil;
  UICMI.navBarTintColor = UIColorWhite;
  UICMI.navBarTitleColor = NavBarTintColor;
  UICMI.navBarTitleFont = UIFontBoldMake(17);
  UICMI.navBarBackButtonTitlePositionAdjustment = UIOffsetZero;
  UICMI.navBarBackIndicatorImage = [UIImage ui_imageWithShape:UIImageShapeNavBack size:CGSizeMake(12, 20) tintColor:NavBarTintColor];
  UICMI.navBarCloseButtonImage = [UIImage ui_imageWithShape:UIImageShapeNavClose size:CGSizeMake(16, 16) tintColor:NavBarTintColor];
  
  UICMI.navBarLoadingMarginRight = 3;
  UICMI.navBarAccessoryViewMarginLeft = 5;
  UICMI.navBarActivityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
  UICMI.navBarAccessoryViewTypeDisclosureIndicatorImage = [UIImage ui_imageWithShape:UIImageShapeTriangle size:CGSizeMake(8, 5) tintColor:UIColorWhite];
  
#pragma mark - TabBar
  
  UICMI.tabBarBackgroundImage = [UIImage ui_imageWithColor:UIColorMake(249, 249, 249)];
  UICMI.tabBarBarTintColor = nil;
  UICMI.tabBarShadowImageColor = UIColorSeparator;
  UICMI.tabBarTintColor = self.themeTintColor;
  UICMI.tabBarItemTitleColor = UIColorGray6;
  UICMI.tabBarItemTitleColorSelected = TabBarTintColor;
  UICMI.tabBarItemTitleFont = nil;
  
#pragma mark - Toolbar
  
  UICMI.toolBarHighlightedAlpha = 0.4f;
  UICMI.toolBarDisabledAlpha = 0.4f;
  UICMI.toolBarTintColor = UIColorBlue;
  UICMI.toolBarTintColorHighlighted = [ToolBarTintColor colorWithAlphaComponent:ToolBarHighlightedAlpha];
  UICMI.toolBarTintColorDisabled = [ToolBarTintColor colorWithAlphaComponent:ToolBarDisabledAlpha];
  UICMI.toolBarBackgroundImage = nil;
  UICMI.toolBarBarTintColor = nil;
  UICMI.toolBarShadowImageColor = UIColorSeparator;
  UICMI.toolBarButtonFont = UIFontMake(17);
  
#pragma mark - SearchBar
  
  UICMI.searchBarTextFieldBackground = UIColorWhite;
  UICMI.searchBarTextFieldBorderColor = UIColorMake(205, 208, 210);
  UICMI.searchBarBottomBorderColor = UIColorMake(205, 208, 210);
  UICMI.searchBarBarTintColor = UIColorMake(247, 247, 247);
  UICMI.searchBarTintColor = self.themeTintColor;
  UICMI.searchBarTextColor = UIColorBlack;
  UICMI.searchBarPlaceholderColor = UIColorPlaceholder;
  UICMI.searchBarSearchIconImage = nil;
  UICMI.searchBarClearIconImage = nil;
  UICMI.searchBarTextFieldCornerRadius = 2.0;
  
#pragma mark - TableView / TableViewCell
  
  UICMI.tableViewBackgroundColor = nil;
  UICMI.tableViewGroupedBackgroundColor = UIColorMake(246, 246, 246);
  UICMI.tableSectionIndexColor = UIColorGrayDarken;
  UICMI.tableSectionIndexBackgroundColor = UIColorClear;
  UICMI.tableSectionIndexTrackingBackgroundColor = UIColorClear;
  UICMI.tableViewSeparatorColor = UIColorSeparator;
  
  UICMI.tableViewCellNormalHeight = 56;
  UICMI.tableViewCellTitleLabelColor = UIColorGray3;
  UICMI.tableViewCellDetailLabelColor = UIColorGray5;
  UICMI.tableViewCellBackgroundColor = UIColorWhite;
  UICMI.tableViewCellSelectedBackgroundColor = UIColorMake(238, 239, 241);
  UICMI.tableViewCellWarningBackgroundColor = UIColorYellow;
  UICMI.tableViewCellDisclosureIndicatorImage = [UIImage ui_imageWithShape:UIImageShapeDisclosureIndicator size:CGSizeMake(6, 10) lineWidth:1 tintColor:UIColorMake(173, 180, 190)];
  UICMI.tableViewCellCheckmarkImage = [UIImage ui_imageWithShape:UIImageShapeCheckmark size:CGSizeMake(15, 12) tintColor:self.themeTintColor];
  UICMI.tableViewCellSpacingBetweenDetailButtonAndDisclosureIndicator = 12;
  
  UICMI.tableViewSectionHeaderBackgroundColor = UIColorMake(244, 244, 244);
  UICMI.tableViewSectionFooterBackgroundColor = UIColorMake(244, 244, 244);
  UICMI.tableViewSectionHeaderFont = UIFontBoldMake(12);
  UICMI.tableViewSectionFooterFont = UIFontBoldMake(12);
  UICMI.tableViewSectionHeaderTextColor = UIColorGray5;
  UICMI.tableViewSectionFooterTextColor = UIColorGray;
  UICMI.tableViewSectionHeaderContentInset = UIEdgeInsetsMake(4, 15, 4, 15);
  UICMI.tableViewSectionFooterContentInset = UIEdgeInsetsMake(4, 15, 4, 15);
  
  UICMI.tableViewGroupedSectionHeaderFont = UIFontMake(12);
  UICMI.tableViewGroupedSectionFooterFont = UIFontMake(12);
  UICMI.tableViewGroupedSectionHeaderTextColor = UIColorGrayDarken;
  UICMI.tableViewGroupedSectionFooterTextColor = UIColorGray;
  UICMI.tableViewGroupedSectionHeaderDefaultHeight = UITableViewAutomaticDimension;
  UICMI.tableViewGroupedSectionFooterDefaultHeight = UITableViewAutomaticDimension;
  UICMI.tableViewGroupedSectionFooterContentInset = UIEdgeInsetsMake(8, 15, 2, 15);
  
#pragma mark - UIWindowLevel
  UICMI.windowLevelUIAlertView = UIWindowLevelAlert - 4.0;
  UICMI.windowLevelUIImagePreviewView = UIWindowLevelStatusBar + 1.0;
  
#pragma mark - Others
  
  UICMI.supportedOrientationMask = UIInterfaceOrientationMaskPortrait;
  UICMI.automaticallyRotateDeviceOrientation = YES;
  UICMI.statusbarStyleLightInitially = YES;
  UICMI.needsBackBarButtonItemTitle = NO;
  UICMI.hidesBottomBarWhenPushedInitially = YES;
  UICMI.navigationBarHiddenInitially = NO;
}

#pragma mark - <QDThemeProtocol>

- (UIColor *)themeTintColor {
  return UIColorTheme9;
}

- (UIColor *)themeListTextColor {
  return self.themeTintColor;
}

- (UIColor *)themeCodeColor {
  return self.themeTintColor;
}

- (UIColor *)themeGridItemTintColor {
  return self.themeTintColor;
}

- (NSString *)themeName {
  return @"ygb";
}

@end
