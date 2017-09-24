//
//  UIScene.h
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationScene.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (UI)
@property(nullable, nonatomic, weak, readonly) UIViewController *previousViewController;
@property(nullable, nonatomic, copy, readonly) NSString *previousViewControllerTitle;
- (nullable UIViewController *)visibleViewControllerIfExist;
- (BOOL)isPresented;
- (BOOL)isViewLoadedAndVisible;
@end

@interface UIViewController (Runtime)
- (BOOL)hasOverrideUIKitMethod:(_Nonnull SEL)selector;
@end

@interface UIViewController (Hooks)
- (void)initSubviews NS_REQUIRES_SUPER;
- (void)contentSizeCategoryDidChanged:(NSNotification *)notification;
@end

@interface UIScene : UIViewController<UINavigationSceneDelegate>
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (void)didInitialized NS_REQUIRES_SUPER;
@property(nonatomic, assign) BOOL autorotate;
@property(nonatomic, assign) UIInterfaceOrientationMask supportedOrientationMask;
@end

NS_ASSUME_NONNULL_END
