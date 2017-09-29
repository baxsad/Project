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
#import "UIImage+UI.h"
#import "UIHelper.h"

@implementation YGBUIConfigurationTemplate

- (void)setupConfigurationTemplate {
  
  // === 修改配置值 === //
  
#pragma mark - Global Color
  
  UICMI.clearColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
  UICMI.whiteColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
  UICMI.blackColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
  UICMI.grayColor = UIColorMake(113, 120, 130);
  UICMI.grayDarkenColor = UIColorMake(93, 100, 110);
  UICMI.grayLightenColor = UIColorMake(173, 180, 190);
  UICMI.redColor = UIColorMake(250, 58, 58);
  UICMI.greenColor = UIColorMake(159, 214, 97);
  UICMI.blueColor = UIColorMake(49, 189, 243);
  UICMI.yellowColor = UIColorMake(255, 207, 71);
  
  UICMI.linkColor = UIColorMake(56, 116, 171);
  UICMI.disabledColor = UIColorGray;
  UICMI.backgroundColor = UIColorWhite;
  UICMI.maskDarkColor = UIColorMakeWithRGBA(0, 0, 0, .35f);
  UICMI.maskLightColor = UIColorMakeWithRGBA(255, 255, 255, .5f);
  UICMI.separatorColor = UIColorMake(222, 224, 226);
  UICMI.separatorDashedColor = UIColorMake(17, 17, 17);
  UICMI.placeholderColor = UIColorMake(196, 200, 208);
  
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
  UICMI.navBarBackIndicatorImage = [UIImage imageWithShape:UIImageShapeNavBack size:CGSizeMake(12, 20) tintColor:NavBarTintColor];
  UICMI.navBarCloseButtonImage = [UIImage imageWithShape:UIImageShapeNavClose size:CGSizeMake(16, 16) tintColor:NavBarTintColor];
  
  UICMI.navBarLoadingMarginRight = 3;
  UICMI.navBarAccessoryViewMarginLeft = 5;
  UICMI.navBarActivityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
  UICMI.navBarAccessoryViewTypeDisclosureIndicatorImage = [UIImage imageWithShape:UIImageShapeTriangle size:CGSizeMake(8, 5) tintColor:UIColorWhite];
  
#pragma mark - TabBar
  
  UICMI.tabBarBackgroundImage = [UIImage imageWithColor:UIColorMake(249, 249, 249)];
  UICMI.tabBarBarTintColor = nil;
  UICMI.tabBarShadowImageColor = UIColorSeparator;
  UICMI.tabBarTintColor = self.themeTintColor;
  UICMI.tabBarItemTitleColor = UIColorMake(153, 160, 170);
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
  
  UICMI.tableViewBackgroundColor = UIColorMake(255, 255, 255);
  UICMI.tableViewGroupedBackgroundColor = UIColorMake(246, 246, 246);
  UICMI.tableSectionIndexColor = UIColorGrayDarken;
  UICMI.tableSectionIndexBackgroundColor = UIColorClear;
  UICMI.tableSectionIndexTrackingBackgroundColor = UIColorClear;
  UICMI.tableViewSeparatorColor = UIColorSeparator;
  
  UICMI.tableViewCellNormalHeight = 56;
  UICMI.tableViewCellTitleLabelColor = UIColorMake(93, 100, 110);
  UICMI.tableViewCellDetailLabelColor = UIColorMake(133, 140, 150);
  UICMI.tableViewCellBackgroundColor = UIColorWhite;
  UICMI.tableViewCellSelectedBackgroundColor = UIColorMake(238, 239, 241);
  UICMI.tableViewCellWarningBackgroundColor = UIColorYellow;
  UICMI.tableViewCellDisclosureIndicatorImage = [UIImage imageWithShape:UIImageShapeDisclosureIndicator size:CGSizeMake(6, 10) lineWidth:1 tintColor:UIColorMake(173, 180, 190)];
  UICMI.tableViewCellCheckmarkImage = [UIImage imageWithShape:UIImageShapeCheckmark size:CGSizeMake(15, 12) tintColor:self.themeTintColor];
  UICMI.tableViewCellSpacingBetweenDetailButtonAndDisclosureIndicator = 12;
  
  UICMI.tableViewSectionHeaderBackgroundColor = UIColorMake(244, 244, 244);
  UICMI.tableViewSectionFooterBackgroundColor = UIColorMake(244, 244, 244);
  UICMI.tableViewSectionHeaderFont = UIFontBoldMake(12);
  UICMI.tableViewSectionFooterFont = UIFontBoldMake(12);
  UICMI.tableViewSectionHeaderTextColor = UIColorMake(133, 140, 150);
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
  UICMI.collectionViewBackgroundColor = UIColorMake(255, 255, 255);
  
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

#pragma mark - <ThemeProtocol>

- (UIColor *)themeTintColor {
  return UIColorMake(238, 133, 193);
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
