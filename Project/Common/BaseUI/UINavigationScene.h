//
//  UINavigationScene.h
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (UI) <UIGestureRecognizerDelegate>
- (nullable UIViewController *)rootViewController;
@end

@interface UINavigationScene : UINavigationController<UINavigationControllerDelegate>
- (void)didInitialized NS_REQUIRES_SUPER;
@end

@interface UINavigationController (Hooks)
- (void)willShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated NS_REQUIRES_SUPER;
- (void)didShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated NS_REQUIRES_SUPER;
@end

@protocol UINavigationSceneDelegate <NSObject>
@required
- (BOOL)shouldSetStatusBarStyleLight;
- (BOOL)preferredNavigationBarHidden;
@optional
- (void)willPopInNavigationControllerWithAnimated:(BOOL)animated;
- (void)didPopInNavigationControllerWithAnimated:(BOOL)animated;
- (void)viewControllerKeepingAppearWhenSetViewControllersWithAnimated:(BOOL)animated;
- (nullable UIColor *)titleViewTintColor;
- (nullable UIImage *)navigationBarBackgroundImage;
- (nullable UIImage *)navigationBarShadowImage;
- (nullable UIColor *)navigationBarTintColor;
- (nullable NSString *)backBarButtonItemTitleWithPreviousViewController:(nullable UIViewController *)viewController;
- (BOOL)shouldCustomNavigationBarTransitionWhenPushAppearing;
- (BOOL)shouldCustomNavigationBarTransitionWhenPushDisappearing;
- (BOOL)shouldCustomNavigationBarTransitionWhenPopAppearing;
- (BOOL)shouldCustomNavigationBarTransitionWhenPopDisappearing;
@end

@protocol UINavigationControllerBackButtonHandlerProtocol <NSObject>
@optional
- (BOOL)shouldHoldBackButtonEvent;
- (BOOL)canPopViewController;
@end

@interface UIViewController (BackBarButtonSupport) <UINavigationControllerBackButtonHandlerProtocol>
@end

NS_ASSUME_NONNULL_END
