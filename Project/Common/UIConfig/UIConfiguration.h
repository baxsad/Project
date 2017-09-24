//
//  UIConfiguration.h
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "UIConfigurationManager.h"

#ifndef UIConfiguration_h
#define UIConfiguration_h

#define UICMI [UIConfigurationManager sharedInstance]

#define UIColorClear                                    [UICMI clearColor]
#define UIColorWhite                                    [UICMI whiteColor]
#define UIColorBlack                                    [UICMI blackColor]
#define UIColorGray                                     [UICMI grayColor]
#define UIColorGrayDarken                               [UICMI grayDarkenColor]
#define UIColorGrayLighten                              [UICMI grayLightenColor]
#define UIColorRed                                      [UICMI redColor]
#define UIColorGreen                                    [UICMI greenColor]
#define UIColorBlue                                     [UICMI blueColor]
#define UIColorYellow                                   [UICMI yellowColor]

#define UIColorMain                                     [UICMI appMainColor]
#define TextPlaceholderColor                            [UICMI textPlaceholderColor]
#define ImagePlaceholderColor                           [UICMI imagePlaceholderColor]

#define SceneBackgroundColor                            [UICMI sceneBackgroundColor]

#define TableViewBackgroundColor                        [UICMI tableViewBackgroundColor]
#define TableViewSeparatorColor                         [UICMI tableViewSeparatorColor]
#define TableViewCellBackgroundColor                    [UICMI tableViewCellBackgroundColor]
#define TableViewCellSelectedBackgroundColor            [UICMI tableViewCellSelectedBackgroundColor]

#define ButtonHighlightedAlpha                          [UICMI buttonHighlightedAlpha]
#define ButtonDisabledAlpha                             [UICMI buttonDisabledAlpha]

#define ToolBarTintColor                                [UICMI toolBarTintColor]

#define NavBarHighlightedAlpha                          [UICMI navBarHighlightedAlpha]
#define NavBarDisabledAlpha                             [UICMI navBarDisabledAlpha]
#define NavBarButtonFont                                [UICMI navBarButtonFont]
#define NavBarButtonFontBold                            [UICMI navBarButtonFontBold]
#define NavBarBackgroundImage                           [UICMI navBarBackgroundImage]
#define NavBarShadowImageColor                          [UICMI navBarShadowImageColor]
#define NavBarBarTintColor                              [UICMI navBarBarTintColor]
#define NavBarTintColor                                 [UICMI navBarTintColor]
#define NavBarTitleColor                                [UICMI navBarTitleColor]
#define NavBarTitleFont                                 [UICMI navBarTitleFont]
#define NavBarSubTitleColor                             [UICMI navBarSubTitleColor]
#define NavBarSubTitleFont                              [UICMI navBarSubTitleFont]
#define NavBarBackButtonTitlePositionAdjustment         [UICMI navBarBackButtonTitlePositionAdjustment]
#define NavBarBackButtonMarginLeft                      [UICMI navBarBackButtonMarginLeft]
#define NavBarBackIndicatorImage                        [UICMI navBarBackIndicatorImage]
#define NavBarCloseButtonImage                          [UICMI navBarCloseButtonImage]
#define NavBarAddButtonImage                            [UICMI navBarAddButtonImage]
#define NavBarButtonItemNormallColor                    [UICMI navBarButtonItemNormallColor]
#define NavBarButtonItemHighlightedColor                [UICMI navBarButtonItemHighlightedColor]
#define NavBarButtonItemDisabledColor                   [UICMI navBarButtonItemDisabledColor]
#define NavBarButtonItemTitleFont                       [UICMI navBarButtonItemTitleFont]
#define NeedsBackBarButtonItemTitle                     [UICMI needsBackBarButtonItemTitle]
#define NavigationBarHiddenInitially                    [UICMI navigationBarHiddenInitially]
#define HidesBottomBarWhenPushedInitially               [UICMI hidesBottomBarWhenPushedInitially]

#define StatusbarStyleLightInitially                    [UICMI statusbarStyleLightInitially]

#define TabBarBackgroundImage                           [UICMI tabBarBackgroundImage]
#define TabBarShadowImageColor                          [UICMI tabBarShadowImageColor]
#define TabBarBarTintColor                              [UICMI tabBarBarTintColor]
#define TabBarTintColor                                 [UICMI tabBarTintColor]
#define TabBarItemTitleColor                            [UICMI tabBarItemTitleColor]
#define TabBarItemTitleColorSelected                    [UICMI tabBarItemTitleColorSelected]

#endif
