//
//  UIScene+UI.h
//  Project
//
//  Created by jearoc on 2017/9/25.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UIScene;
@protocol UINavigationControllerBackButtonHandlerProtocol;

@interface UIViewController (UI)
@property(nullable, nonatomic, weak, readonly) UIViewController *previousViewController;
@property(nullable, nonatomic, copy, readonly) NSString *previousViewControllerTitle;
- (nullable UIViewController *)visibleViewControllerIfExist;
- (BOOL)isPresented;
- (BOOL)isViewLoadedAndVisible;
@end

@interface UIViewController (Runtime)
- (BOOL)hasOverrideUIKitMethod:(_Nonnull SEL)selector;
- (BOOL)hasOverrideMethod:(SEL)selector ofSuperclass:(Class)superclass;
@end

@interface UIScene (Hooks)
- (void)initSubviews NS_REQUIRES_SUPER;
- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated;
- (void)setToolbarItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated;
- (void)contentSizeCategoryDidChanged:(NSNotification *)notification;
@end

@interface UIViewController (Handler)<UINavigationControllerBackButtonHandlerProtocol>
@end

NS_ASSUME_NONNULL_END
