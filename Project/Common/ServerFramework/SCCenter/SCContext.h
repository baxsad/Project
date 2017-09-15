//
//  SCContext.h
//  Project
//
//  Created by jearoc on 2017/9/15.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCModel.h"

@interface SCContext : NSObject <NSCopying>

@property(nonatomic, strong) UIApplication *application;
@property(nonatomic, strong) NSDictionary *launchOptions;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400
@property (nonatomic, strong) SCShortcutItem *touchShortcutItem;
#endif
@property (nonatomic, strong) SCOpenURLItem *openURLItem;
@property (nonatomic, strong) SCNotificationsItem *notificationsItem;
@property (nonatomic, strong) SCUserActivityItem *userActivityItem;
@property (nonatomic, strong) SCWatchItem *watchItem;
+ (instancetype)defaultContext;

@end
