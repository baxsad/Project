//
//  UIImage+UIConfig.h
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CGContextInspectSize(size) [UIImage inspectContextSize:size]

#ifdef DEBUG
#define CGContextInspectContext(context) [UIImage inspectContextIfInvalidatedInDebugMode:context]
#else
#define CGContextInspectContext(context) if(![UIImage inspectContextIfInvalidatedInReleaseMode:context]){return nil;}
#endif

typedef NS_ENUM(NSInteger, UIImageShape) {
  UIImageShapeOval,                 // 椭圆
  UIImageShapeTriangle,             // 三角形
  UIImageShapeDisclosureIndicator,  // 列表cell右边的箭头
  UIImageShapeCheckmark,            // 列表cell右边的checkmark
  UIImageShapeNavBack,              // 返回按钮的箭头
  UIImageShapeNavClose,             // 导航栏的关闭icon
  UIImageShapeNavAdd                // 导航栏的加号icon
};

@interface UIImage (UIConfig)

+ (UIImage *)ui_imageWithShape:(UIImageShape)shape
                          size:(CGSize)size
                     tintColor:(UIColor *)tintColor;
  
+ (UIImage *)ui_imageWithShape:(UIImageShape)shape
                          size:(CGSize)size
                     lineWidth:(CGFloat)lineWidth
                     tintColor:(UIColor *)tintColor;
  
+ (UIImage *)ui_imageWithColor:(UIColor *)color
                          size:(CGSize)size
                  cornerRadius:(CGFloat)cornerRadius;
  
- (UIImage *)ui_imageWithSpacingExtensionInsets:(UIEdgeInsets)extension;
  
- (UIImage *)ui_imageByApplyingAlpha:(CGFloat)alpha;
  
@end
