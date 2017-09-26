//
//  UITextField+UIKeyboardManager.m
//  Project
//
//  Created by pmo on 2017/9/26.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "UITextField+UIKeyboardManager.h"

@implementation UITextField (UIKeyboardManager)

- (void)setKeyboardWillShowNotificationBlock:(void (^)(UIKeyboardUserInfo *))keyboardWillShowNotificationBlock {
  objc_setAssociatedObject(self, @selector(keyboardWillShowNotificationBlock), keyboardWillShowNotificationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
  if (keyboardWillShowNotificationBlock) {
    [self initKeyboardManagerIfNeeded];
  }
}

- (void (^)(UIKeyboardUserInfo *))keyboardWillShowNotificationBlock {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setKeyboardDidShowNotificationBlock:(void (^)(UIKeyboardUserInfo *))keyboardDidShowNotificationBlock {
  objc_setAssociatedObject(self, @selector(keyboardDidShowNotificationBlock), keyboardDidShowNotificationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
  if (keyboardDidShowNotificationBlock) {
    [self initKeyboardManagerIfNeeded];
  }
}

- (void (^)(UIKeyboardUserInfo *))keyboardDidShowNotificationBlock {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setKeyboardWillHideNotificationBlock:(void (^)(UIKeyboardUserInfo *))keyboardWillHideNotificationBlock {
  objc_setAssociatedObject(self, @selector(keyboardWillHideNotificationBlock), keyboardWillHideNotificationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
  if (keyboardWillHideNotificationBlock) {
    [self initKeyboardManagerIfNeeded];
  }
}

- (void (^)(UIKeyboardUserInfo *))keyboardWillHideNotificationBlock {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setKeyboardDidHideNotificationBlock:(void (^)(UIKeyboardUserInfo *))keyboardDidHideNotificationBlock {
  objc_setAssociatedObject(self, @selector(keyboardDidHideNotificationBlock), keyboardDidHideNotificationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
  if (keyboardDidHideNotificationBlock) {
    [self initKeyboardManagerIfNeeded];
  }
}

- (void (^)(UIKeyboardUserInfo *))keyboardDidHideNotificationBlock {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setKeyboardWillChangeFrameNotificationBlock:(void (^)(UIKeyboardUserInfo *))keyboardWillChangeFrameNotificationBlock {
  objc_setAssociatedObject(self, @selector(keyboardWillChangeFrameNotificationBlock), keyboardWillChangeFrameNotificationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
  if (keyboardWillChangeFrameNotificationBlock) {
    [self initKeyboardManagerIfNeeded];
  }
}

- (void (^)(UIKeyboardUserInfo *))keyboardWillChangeFrameNotificationBlock {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setKeyboardDidChangeFrameNotificationBlock:(void (^)(UIKeyboardUserInfo *))keyboardDidChangeFrameNotificationBlock {
  objc_setAssociatedObject(self, @selector(keyboardDidChangeFrameNotificationBlock), keyboardDidChangeFrameNotificationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
  if (keyboardDidChangeFrameNotificationBlock) {
    [self initKeyboardManagerIfNeeded];
  }
}

- (void (^)(UIKeyboardUserInfo *))keyboardDidChangeFrameNotificationBlock {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setKeyboardManager:(UIKeyboardManager *)keyboardManager {
  objc_setAssociatedObject(self, @selector(keyboardManager), keyboardManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIKeyboardManager *)keyboardManager {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)initKeyboardManagerIfNeeded {
  if (!self.keyboardManager) {
    self.keyboardManager = [[UIKeyboardManager alloc] initWithDelegate:self];
    [self.keyboardManager addTargetResponder:self];
  }
}

#pragma mark - <UIKeyboardManagerDelegate>

- (void)keyboardWillShowWithUserInfo:(UIKeyboardUserInfo *)keyboardUserInfo {
  if (self.keyboardWillShowNotificationBlock) {
    self.keyboardWillShowNotificationBlock(keyboardUserInfo);
  }
}

- (void)keyboardWillHideWithUserInfo:(UIKeyboardUserInfo *)keyboardUserInfo {
  if (self.keyboardWillHideNotificationBlock) {
    self.keyboardWillHideNotificationBlock(keyboardUserInfo);
  }
}

- (void)keyboardWillChangeFrameWithUserInfo:(UIKeyboardUserInfo *)keyboardUserInfo {
  if (self.keyboardWillChangeFrameNotificationBlock) {
    self.keyboardWillChangeFrameNotificationBlock(keyboardUserInfo);
  }
}

- (void)keyboardDidShowWithUserInfo:(UIKeyboardUserInfo *)keyboardUserInfo {
  if (self.keyboardDidShowNotificationBlock) {
    self.keyboardDidShowNotificationBlock(keyboardUserInfo);
  }
}

- (void)keyboardDidHideWithUserInfo:(UIKeyboardUserInfo *)keyboardUserInfo {
  if (self.keyboardDidHideNotificationBlock) {
    self.keyboardDidHideNotificationBlock(keyboardUserInfo);
  }
}

- (void)keyboardDidChangeFrameWithUserInfo:(UIKeyboardUserInfo *)keyboardUserInfo {
  if (self.keyboardDidChangeFrameNotificationBlock) {
    self.keyboardDidChangeFrameNotificationBlock(keyboardUserInfo);
  }
}

@end
