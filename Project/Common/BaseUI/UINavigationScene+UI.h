//
//  UINavigationScene+UI.h
//  Project
//
//  Created by pmo on 2017/9/24.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (UI)
- (nullable UIViewController *)rootViewController;
@end

@protocol UINavigationControllerBackButtonHandlerProtocol <NSObject>
@optional
- (BOOL)shouldHoldBackButtonEvent;
- (BOOL)canPopViewController;
- (BOOL)forceEnableInteractivePopGestureRecognizer;
@end

@interface UIViewController (BackBarButtonSupport) <UINavigationControllerBackButtonHandlerProtocol>
@end
