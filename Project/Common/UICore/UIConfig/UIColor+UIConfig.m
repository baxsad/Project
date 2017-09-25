//
//  UIColor+UIConfig.m
//  Project
//
//  Created by pmo on 2017/9/24.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "UIColor+UIConfig.h"

@implementation UIColor (UIConfig)

- (UIColor *)ui_colorWithAlpha:(CGFloat)alpha backgroundColor:(UIColor *)backgroundColor {
  return [UIColor ui_colorWithBackendColor:backgroundColor frontColor:[self colorWithAlphaComponent:alpha]];
  
}

- (UIColor *)ui_colorWithAlphaAddedToWhite:(CGFloat)alpha {
  return [self ui_colorWithAlpha:alpha backgroundColor:UIColorWhite];
}

+ (UIColor *)ui_colorWithBackendColor:(UIColor *)backendColor frontColor:(UIColor *)frontColor {
  CGFloat bgAlpha = [backendColor ui_alpha];
  CGFloat bgRed = [backendColor ui_red];
  CGFloat bgGreen = [backendColor ui_green];
  CGFloat bgBlue = [backendColor ui_blue];
  
  CGFloat frAlpha = [frontColor ui_alpha];
  CGFloat frRed = [frontColor ui_red];
  CGFloat frGreen = [frontColor ui_green];
  CGFloat frBlue = [frontColor ui_blue];
  
  CGFloat resultAlpha = frAlpha + bgAlpha * (1 - frAlpha);
  CGFloat resultRed = (frRed * frAlpha + bgRed * bgAlpha * (1 - frAlpha)) / resultAlpha;
  CGFloat resultGreen = (frGreen * frAlpha + bgGreen * bgAlpha * (1 - frAlpha)) / resultAlpha;
  CGFloat resultBlue = (frBlue * frAlpha + bgBlue * bgAlpha * (1 - frAlpha)) / resultAlpha;
  return [UIColor colorWithRed:resultRed green:resultGreen blue:resultBlue alpha:resultAlpha];
}

- (CGFloat)ui_red {
  CGFloat r;
  if ([self getRed:&r green:0 blue:0 alpha:0]) {
    return r;
  }
  return 0;
}

- (CGFloat)ui_green {
  CGFloat g;
  if ([self getRed:0 green:&g blue:0 alpha:0]) {
    return g;
  }
  return 0;
}

- (CGFloat)ui_blue {
  CGFloat b;
  if ([self getRed:0 green:0 blue:&b alpha:0]) {
    return b;
  }
  return 0;
}

- (CGFloat)ui_alpha {
  CGFloat a;
  if ([self getRed:0 green:0 blue:0 alpha:&a]) {
    return a;
  }
  return 0;
}

@end
