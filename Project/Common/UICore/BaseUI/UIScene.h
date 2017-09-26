//
//  UIScene.h
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardManager.h"
#import "UINavigationScene.h"
#import "UINavigationScene+UI.h"
#import "UINavigationTitleView.h"
#import "UIEmptyView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIScene : UIViewController<UINavigationSceneDelegate>
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (void)didInitialized NS_REQUIRES_SUPER;
@property(nonatomic, assign) BOOL autorotate;
@property(nonatomic, assign) UIInterfaceOrientationMask supportedOrientationMask;
@property(nonatomic, strong, readonly) UINavigationTitleView *titleView;
@property(nonatomic, strong) UIEmptyView *emptyView;
@property(nonatomic, assign, readonly, getter = isEmptyViewShowing) BOOL emptyViewShowing;
- (void)showEmptyView;
- (void)showEmptyViewWithLoading;
- (void)showEmptyViewWithText:(NSString *)text
                   detailText:(NSString *)detailText
                  buttonTitle:(NSString *)buttonTitle
                 buttonAction:(SEL)action;
- (void)showEmptyViewWithImage:(UIImage *)image
                          text:(NSString *)text
                    detailText:(NSString *)detailText
                   buttonTitle:(NSString *)buttonTitle
                  buttonAction:(SEL)action;
- (void)showEmptyViewWithLoading:(BOOL)showLoading
                           image:(UIImage *)image
                            text:(NSString *)text
                      detailText:(NSString *)detailText
                     buttonTitle:(NSString *)buttonTitle
                    buttonAction:(SEL)action;
- (void)hideEmptyView;
- (BOOL)layoutEmptyView;
@end

@interface UIScene (UIKeyboard)
@property(nonatomic, strong, readonly) UITapGestureRecognizer *hideKeyboardTapGestureRecognizer;
@property(nonatomic, strong, readonly) UIKeyboardManager *hideKeyboardManager;
- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
