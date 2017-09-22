//
//  UIScene.h
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NavBarItemPosition) {
  NavBarItemPositionLeft,
  NavBarItemPositionRight,
};

@interface UIScene : UIViewController
- (void)showBarButton:(NavBarItemPosition)position
                title:(NSString *)name;
- (void)showBarButton:(NavBarItemPosition)position
                title:(NSString *)name
                color:(UIColor *)color;
- (void)showBarButton:(NavBarItemPosition)position image:(UIImage *)image;
- (void)showBarButton:(NavBarItemPosition)position button:(UIButton *)button;
- (void)leftButtonTouch;
- (void)rightButtonTouch;
@end

NS_ASSUME_NONNULL_END
