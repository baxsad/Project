//
//  UIImage+UI.m
//  Project
//
//  Created by pmo on 2017/9/26.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "UIImage+UI.h"
#import "UICommonDefines.h"
#import "UIHelper.h"

@implementation UIImage (UI)
+ (UIImage *)imageWithView:(UIView *)view {
  CGContextInspectSize(view.bounds.size);
  UIImage *resultImage = nil;
  UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextInspectContext(context);
  [view.layer renderInContext:context];
  resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return resultImage;
}

+ (UIImage *)imageWithView:(UIView *)view afterScreenUpdates:(BOOL)afterUpdates {
  // iOS 7 截图新方式，性能好会好一点，不过不一定适用，因为这个方法的使用条件是：界面要已经render完，否则截到得图将会是empty。
  UIImage *resultImage = nil;
  UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
  [view drawViewHierarchyInRect:CGRectMakeWithSize(view.bounds.size) afterScreenUpdates:afterUpdates];
  resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return resultImage;
}
@end
