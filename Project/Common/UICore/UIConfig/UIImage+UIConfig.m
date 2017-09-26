//
//  UIImage+UIConfig.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "UIImage+UIConfig.h"
#import "UICommonDefines.h"
#import "UIHelper.h"

@implementation UIImage (UIConfig)

+ (UIImage *)ui_imageWithShape:(UIImageShape)shape
                          size:(CGSize)size
                     tintColor:(UIColor *)tintColor {
  CGFloat lineWidth = 0;
  switch (shape) {
    case UIImageShapeNavBack:
    lineWidth = 2;
    break;
    case UIImageShapeDisclosureIndicator:
    lineWidth = 2;
    break;
    case UIImageShapeCheckmark:
    lineWidth = 2;
    break;
    case UIImageShapeNavClose:
    lineWidth = 2;
    break;
    case UIImageShapeNavAdd:
    lineWidth = 2;
    break;
    default:
    break;
  }
  return [UIImage ui_imageWithShape:shape size:size lineWidth:lineWidth tintColor:tintColor];
}
  
+ (UIImage *)ui_imageWithShape:(UIImageShape)shape
                          size:(CGSize)size
                     lineWidth:(CGFloat)lineWidth
                     tintColor:(UIColor *)tintColor {
  size = CGSizeFlatted(size);
  CGContextInspectSize(size);
  
  UIImage *resultImage = nil;
  tintColor = tintColor ? tintColor : [UIColor whiteColor];
  
  
  UIGraphicsBeginImageContextWithOptions(size, NO, 0);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextInspectContext(context);
  UIBezierPath *path = nil;
  BOOL drawByStroke = NO;
  CGFloat drawOffset = lineWidth / 2;
  switch (shape) {
    case UIImageShapeOval: {
      path = [UIBezierPath bezierPathWithOvalInRect:CGRectMakeWithSize(size)];
    }
    break;
    case UIImageShapeTriangle: {
      path = [UIBezierPath bezierPath];
      [path moveToPoint:CGPointMake(0, size.height)];
      [path addLineToPoint:CGPointMake(size.width / 2, 0)];
      [path addLineToPoint:CGPointMake(size.width, size.height)];
      [path closePath];
    }
    break;
    case UIImageShapeNavBack: {
      drawByStroke = YES;
      path = [UIBezierPath bezierPath];
      path.lineWidth = lineWidth;
      [path moveToPoint:CGPointMake(size.width - drawOffset, drawOffset)];
      [path addLineToPoint:CGPointMake(0 + drawOffset, size.height / 2.0)];
      [path addLineToPoint:CGPointMake(size.width - drawOffset, size.height - drawOffset)];
    }
    break;
    case UIImageShapeDisclosureIndicator: {
      path = [UIBezierPath bezierPath];
      drawByStroke = YES;
      path.lineWidth = lineWidth;
      [path moveToPoint:CGPointMake(drawOffset, drawOffset)];
      [path addLineToPoint:CGPointMake(size.width - drawOffset, size.height / 2)];
      [path addLineToPoint:CGPointMake(drawOffset, size.height - drawOffset)];
    }
    break;
    case UIImageShapeCheckmark: {
      CGFloat lineAngle = M_PI_4;
      path = [UIBezierPath bezierPath];
      [path moveToPoint:CGPointMake(0, size.height / 2)];
      [path addLineToPoint:CGPointMake(size.width / 3, size.height)];
      [path addLineToPoint:CGPointMake(size.width, lineWidth * sin(lineAngle))];
      [path addLineToPoint:CGPointMake(size.width - lineWidth * cos(lineAngle), 0)];
      [path addLineToPoint:CGPointMake(size.width / 3, size.height - lineWidth / sin(lineAngle))];
      [path addLineToPoint:CGPointMake(lineWidth * sin(lineAngle), size.height / 2 - lineWidth * sin(lineAngle))];
      [path closePath];
    }
    break;
    case UIImageShapeNavClose: {
      drawByStroke = YES;
      path = [UIBezierPath bezierPath];
      [path moveToPoint:CGPointMake(0, 0)];
      [path addLineToPoint:CGPointMake(size.width, size.height)];
      [path closePath];
      [path moveToPoint:CGPointMake(size.width, 0)];
      [path addLineToPoint:CGPointMake(0, size.height)];
      [path closePath];
      path.lineWidth = lineWidth;
      path.lineCapStyle = kCGLineCapRound;
    }
    break;
    case UIImageShapeNavAdd: {
      drawByStroke = YES;
      path = [UIBezierPath bezierPath];
      [path moveToPoint:CGPointMake(size.width/2.0, 0)];
      [path addLineToPoint:CGPointMake(size.width/2.0, size.height)];
      [path closePath];
      [path moveToPoint:CGPointMake(0, size.height/2.0)];
      [path addLineToPoint:CGPointMake(size.width, size.height/2.0)];
      [path closePath];
      path.lineWidth = lineWidth;
      path.lineCapStyle = kCGLineCapRound;
    }
    break;
    default:
    break;
  }
  
  if (drawByStroke) {
    CGContextSetStrokeColorWithColor(context, tintColor.CGColor);
    [path stroke];
  } else {
    CGContextSetFillColorWithColor(context, tintColor.CGColor);
    [path fill];
  }
  
  resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return resultImage;
}
  
+ (UIImage *)ui_imageWithColor:(UIColor *)color
                          size:(CGSize)size
                  cornerRadius:(CGFloat)cornerRadius {
  size = CGSizeFlatted(size);
  CGContextInspectSize(size);
  
  UIImage *resultImage = nil;
  color = color ? color : [UIColor whiteColor];
  
  UIGraphicsBeginImageContextWithOptions(size, NO, 0);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, color.CGColor);
  
  if (cornerRadius > 0) {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMakeWithSize(size) cornerRadius:cornerRadius];
    [path addClip];
    [path fill];
  } else {
    CGContextFillRect(context, CGRectMakeWithSize(size));
  }
  
  resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return resultImage;
}

+ (UIImage *)ui_imageWithColor:(UIColor *)color
{
  return [self ui_imageWithColor:color size:CGSizeMake(1, 1) cornerRadius:0];
}

- (UIImage *)ui_imageWithSpacingExtensionInsets:(UIEdgeInsets)extension {
  CGSize contextSize = CGSizeMake(self.size.width + UIEdgeInsetsGetHorizontalValue(extension), self.size.height + UIEdgeInsetsGetVerticalValue(extension));
  UIGraphicsBeginImageContextWithOptions(contextSize, NO, self.scale);
  [self drawAtPoint:CGPointMake(extension.left, extension.top)];
  UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return finalImage;
}
  
- (UIImage *)ui_imageByApplyingAlpha:(CGFloat)alpha
{
  UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
  
  CGContextScaleCTM(ctx, 1, -1);
  
  CGContextTranslateCTM(ctx, 0, -area.size.height);
  
  CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
  
  CGContextSetAlpha(ctx, alpha);
  
  CGContextDrawImage(ctx, area, self.CGImage);
  
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  return newImage;
}

CG_INLINE CGFloat
flatSpecificScale(CGFloat floatValue, CGFloat scale) {
  floatValue = floatValue == CGFLOAT_MIN ? 0 : floatValue;
  scale = scale == 0 ? [[UIScreen mainScreen] scale] : scale;
  CGFloat flattedValue = ceil(floatValue * scale) / scale;
  return flattedValue;
}
#define AngleWithDegrees(deg) (M_PI * (deg) / 180.0)

- (UIImage *)ui_imageWithOrientation:(UIImageOrientation)orientation {
  if (orientation == UIImageOrientationUp) {
    return self;
  }
  
  CGSize contextSize = self.size;
  if (orientation == UIImageOrientationLeft || orientation == UIImageOrientationRight) {
    contextSize = CGSizeMake(contextSize.height, contextSize.width);
  }
  
  contextSize = CGSizeMake(flatSpecificScale(contextSize.width, self.scale),
                           flatSpecificScale(contextSize.height, self.scale));
  
  UIGraphicsBeginImageContextWithOptions(contextSize, NO, self.scale);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextInspectContext(context);
  
  // 画布的原点在左上角，旋转后可能图片就飞到画布外了，所以旋转前先把图片摆到特定位置再旋转，图片刚好就落在画布里
  switch (orientation) {
    case UIImageOrientationUp:
      // 上
      break;
    case UIImageOrientationDown:
      // 下
      CGContextTranslateCTM(context, contextSize.width, contextSize.height);
      CGContextRotateCTM(context, AngleWithDegrees(180));
      break;
    case UIImageOrientationLeft:
      // 左
      CGContextTranslateCTM(context, 0, contextSize.height);
      CGContextRotateCTM(context, AngleWithDegrees(-90));
      break;
    case UIImageOrientationRight:
      // 右
      CGContextTranslateCTM(context, contextSize.width, 0);
      CGContextRotateCTM(context, AngleWithDegrees(90));
      break;
    case UIImageOrientationUpMirrored:
    case UIImageOrientationDownMirrored:
      // 向上、向下翻转是一样的
      CGContextTranslateCTM(context, 0, contextSize.height);
      CGContextScaleCTM(context, 1, -1);
      break;
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRightMirrored:
      // 向左、向右翻转是一样的
      CGContextTranslateCTM(context, contextSize.width, 0);
      CGContextScaleCTM(context, -1, 1);
      break;
  }
  
  // 在前面画布的旋转、移动的结果上绘制自身即可，这里不用考虑旋转带来的宽高置换的问题
  [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
  
  UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return imageOut;
}
  
@end
