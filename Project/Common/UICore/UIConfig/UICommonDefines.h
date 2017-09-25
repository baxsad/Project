//
//  UICommonDefines.h
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#define ScreenScale ([[UIScreen mainScreen] scale])
#define UIColorMake(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define UIColorMakeWithRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]
#define UIFontMake(size) [UIFont systemFontOfSize:size]
#define UIFontBoldMake(size) [UIFont boldSystemFontOfSize:size]
#define UIFontMediumMake(fontSize) [UIFont fontWithName:[[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? @"PingFangSC-Medium" : @"HelveticaNeue-Medium" size:fontSize]
#define UIImageMake(img) [UIImage imageNamed:img inBundle:nil compatibleWithTraitCollection:nil]
#define UIImageMakeWithFile(name) UIImageMakeWithFileAndSuffix(name, @"png")
#define UIImageMakeWithFileAndSuffix(name, suffix) [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", [[NSBundle mainBundle] resourcePath], name, suffix]]

#define UIViewAnimationOptionsCurveOut (7<<16)
#define UIViewAnimationOptionsCurveIn (8<<16)

// 是否横竖屏
// 用户界面横屏了才会返回YES
#define IS_LANDSCAPE UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])
// 无论支不支持横屏，只要设备横屏了，就会返回YES
#define IS_DEVICE_LANDSCAPE UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])

// 屏幕宽度，会根据横竖屏的变化而变化
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

// 屏幕宽度，跟横竖屏无关
#define DEVICE_WIDTH (IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

// 屏幕高度，会根据横竖屏的变化而变化
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

// 屏幕高度，跟横竖屏无关
#define DEVICE_HEIGHT (IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)

CG_INLINE void
ReplaceMethod(Class _class, SEL _originSelector, SEL _newSelector) {
  Method oriMethod = class_getInstanceMethod(_class, _originSelector);
  Method newMethod = class_getInstanceMethod(_class, _newSelector);
  BOOL isAddedMethod = class_addMethod(_class, _originSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
  if (isAddedMethod) {
    class_replaceMethod(_class, _newSelector, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
  } else {
    method_exchangeImplementations(oriMethod, newMethod);
  }
}

CG_INLINE CGFloat
removeFloatMin(CGFloat floatValue) {
  return floatValue == CGFLOAT_MIN ? 0 : floatValue;
}

CG_INLINE CGFloat
floorInPixel(CGFloat floatValue) {
  floatValue = removeFloatMin(floatValue);
  CGFloat resultValue = floor(floatValue * ScreenScale) / ScreenScale;
  return resultValue;
}

CG_INLINE float
flatfSpecificScale(float floatValue, float scale) {
  scale = scale == 0 ? ScreenScale : scale;
  CGFloat flattedValue = ceilf(floatValue * scale) / scale;
  return flattedValue;
}

CG_INLINE float
flatf(float floatValue) {
  return flatfSpecificScale(floatValue, 0);
}

CG_INLINE BOOL
CGSizeIsEmpty(CGSize size) {
  return size.width <= 0 || size.height <= 0;
}

CG_INLINE CGSize
CGSizeCeil(CGSize size) {
  return CGSizeMake(ceil(size.width), ceil(size.height));
}

CG_INLINE CGSize
CGSizeFlatted(CGSize size) {
  return CGSizeMake(flatf(size.width), flatf(size.height));
}

static CGFloat onePixel = -1.0f;
CG_INLINE float
PixelOne() {
  if (onePixel < 0) {
    onePixel = 1 / [[UIScreen mainScreen] scale];
  }
  return onePixel;
}

CG_INLINE CGRect
CGRectFlatMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
  return CGRectMake(flatf(x), flatf(y), flatf(width), flatf(height));
}

CG_INLINE CGRect
CGRectMakeWithSize(CGSize size) {
  return CGRectMake(0, 0, size.width, size.height);
}

CG_INLINE CGRect
CGRectSetX(CGRect rect, CGFloat x) {
  rect.origin.x = flatf(x);
  return rect;
}

CG_INLINE CGRect
CGRectSetY(CGRect rect, CGFloat y) {
  rect.origin.y = flatf(y);
  return rect;
}

CG_INLINE CGRect
CGRectSetXY(CGRect rect, CGFloat x, CGFloat y) {
  rect.origin.x = flatf(x);
  rect.origin.y = flatf(y);
  return rect;
}

CG_INLINE CGRect
CGRectSetWidth(CGRect rect, CGFloat width) {
  rect.size.width = flatf(width);
  return rect;
}

CG_INLINE CGRect
CGRectSetHeight(CGRect rect, CGFloat height) {
  rect.size.height = flatf(height);
  return rect;
}

CG_INLINE CGRect
CGRectSetSize(CGRect rect, CGSize size) {
  rect.size = CGSizeFlatted(size);
  return rect;
}

CG_INLINE CGFloat
UIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
  return insets.left + insets.right;
}

CG_INLINE CGFloat
UIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
  return insets.top + insets.bottom;
}

CG_INLINE CGFloat
CGFloatGetCenter(CGFloat parent, CGFloat child) {
  return flatf((parent - child) / 2.0);
}
