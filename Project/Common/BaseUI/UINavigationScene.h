//
//  UINavigationScene.h
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationBarTransition.h"

@class UIScene;

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationScene : UINavigationController
@property(nullable, nonatomic,readonly,strong) UIScene *topScene;
@property(nullable, nonatomic,readonly,strong) UIScene *visibleScene;
@end

NS_ASSUME_NONNULL_END
