//
//  UIConfigurationManager.h
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIConfigurationManager : NSObject

#pragma mark - System Color

@property(nonatomic,strong) UIColor          *clearColor;
@property(nonatomic,strong) UIColor          *whiteColor;
@property(nonatomic,strong) UIColor          *blackColor;
@property(nonatomic,strong) UIColor          *grayColor;
@property(nonatomic,strong) UIColor          *grayDarkenColor;
@property(nonatomic,strong) UIColor          *grayLightenColor;
@property(nonatomic,strong) UIColor          *redColor;
@property(nonatomic,strong) UIColor          *greenColor;
@property(nonatomic,strong) UIColor          *blueColor;
@property(nonatomic,strong) UIColor          *yellowColor;

#pragma mark - Global Color

@property(nonatomic,strong) UIColor          *appMainColor;
@property(nonatomic,strong) UIColor          *textPlaceholderColor;
@property(nonatomic,strong) UIColor          *imagePlaceholderColor;

#pragma mark - Controller

@property(nonatomic,strong) UIColor          *sceneBackgroundColor;

#pragma mark - TableView

@property(nonatomic,strong) UIColor          *tableViewBackgroundColor;
@property(nonatomic,strong) UIColor          *tableViewSeparatorColor;
@property(nonatomic,strong) UIColor          *tableViewCellBackgroundColor;
@property(nonatomic,strong) UIColor          *tableViewCellSelectedBackgroundColor;
  
#pragma mark - UIButton
  
@property(nonatomic,assign) CGFloat          buttonHighlightedAlpha;
@property(nonatomic,assign) CGFloat          buttonDisabledAlpha;

#pragma mark - ToolBar

@property(nonatomic,strong) UIColor          *toolBarTintColor;

#pragma mark - NavigationBar

@property(nonatomic,assign) CGFloat           navBarHighlightedAlpha;
@property(nonatomic,assign) CGFloat           navBarDisabledAlpha;
@property(nonatomic,strong) UIFont           *navBarButtonFont;
@property(nonatomic,strong) UIFont           *navBarButtonFontBold;
@property(nonatomic,strong) UIImage          *navBarBackgroundImage;
@property(nonatomic,strong) UIColor          *navBarShadowImageColor;
@property(nonatomic,strong) UIColor          *navBarBarTintColor;
@property(nonatomic,strong) UIColor          *navBarTintColor;
@property(nonatomic,strong) UIColor          *navBarTitleColor;
@property(nonatomic,strong) UIFont           *navBarTitleFont;
@property(nonatomic,strong) UIColor          *navBarSubTitleColor;
@property(nonatomic,strong) UIFont           *navBarSubTitleFont;
@property(nonatomic,assign) UIOffset         navBarBackButtonTitlePositionAdjustment;
@property(nonatomic,assign) CGFloat          navBarBackButtonMarginLeft;
@property(nonatomic,strong) UIImage          *navBarBackIndicatorImage;
@property(nonatomic,strong) UIImage          *navBarCloseButtonImage;
@property(nonatomic,strong) UIImage          *navBarAddButtonImage;
@property(nonatomic,strong) UIColor          *navBarButtonItemNormallColor;
@property(nonatomic,strong) UIColor          *navBarButtonItemHighlightedColor;
@property(nonatomic,strong) UIColor          *navBarButtonItemDisabledColor;
@property(nonatomic,strong) UIFont           *navBarButtonItemTitleFont;
@property(nonatomic,assign) BOOL              needsBackBarButtonItemTitle;
@property(nonatomic,assign) BOOL              navigationBarHiddenInitially;
@property(nonatomic,assign) BOOL              hidesBottomBarWhenPushedInitially;

#pragma mark - StatusBar

@property(nonatomic, assign) BOOL             statusbarStyleLightInitially;

#pragma mark - TabBar

@property(nonatomic,strong) UIImage          *tabBarBackgroundImage;
@property(nonatomic,strong) UIColor          *tabBarShadowImageColor;
@property(nonatomic,strong) UIColor          *tabBarBarTintColor;
@property(nonatomic,strong) UIColor          *tabBarTintColor;
@property(nonatomic,strong) UIColor          *tabBarItemTitleColor;
@property(nonatomic,strong) UIColor          *tabBarItemTitleColorSelected;

#pragma mark - 

+ (UIConfigurationManager *)sharedInstance;
- (void)initDefaultConfiguration;

@end

@interface UIConfigurationManager (UIAppearance)
  
- (void)renderGlobalAppearances;

@end
