//
//  UITextField+UIKeyboardManager.h
//  Project
//
//  Created by pmo on 2017/9/26.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardManager.h"

@interface UITextField (UIKeyboardManager)<UIKeyboardManagerDelegate>
@property(nonatomic, copy) void (^keyboardWillShowNotificationBlock)(UIKeyboardUserInfo *keyboardUserInfo);
@property(nonatomic, copy) void (^keyboardWillHideNotificationBlock)(UIKeyboardUserInfo *keyboardUserInfo);
@property(nonatomic, copy) void (^keyboardWillChangeFrameNotificationBlock)(UIKeyboardUserInfo *keyboardUserInfo);
@property(nonatomic, copy) void (^keyboardDidShowNotificationBlock)(UIKeyboardUserInfo *keyboardUserInfo);
@property(nonatomic, copy) void (^keyboardDidHideNotificationBlock)(UIKeyboardUserInfo *keyboardUserInfo);
@property(nonatomic, copy) void (^keyboardDidChangeFrameNotificationBlock)(UIKeyboardUserInfo *keyboardUserInfo);
@property(nonatomic, strong, readonly) UIKeyboardManager *keyboardManager;
@end
