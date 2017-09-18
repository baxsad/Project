//
//  SCCenterProtocol.h
//  Project
//
//  Created by jearoc on 2017/9/18.
//  Copyright © 2017年 jearoc. All rights reserved.
//
#import <Foundation/Foundation.h>

@class SCCenter;
@class SCContext;

#define SC_EXPORT_CONTROL \
+ (void)load { [SCCenter registerDynamicListener:[self class]]; }

@protocol SCCenterProtocol <NSObject>

@optional

- (void)scBasicLevel;

- (NSInteger)scPriority;

- (BOOL)scAsync;

- (void)scSetUp:(SCContext *)context;

- (void)scInit:(SCContext *)context;

- (void)scSplash:(SCContext *)context;

- (void)scQuickAction:(SCContext *)context;

- (void)scTearDown:(SCContext *)context;

- (void)scWillResignActive:(SCContext *)context;

- (void)scDidEnterBackground:(SCContext *)context;

- (void)scWillEnterForeground:(SCContext *)context;

- (void)scDidBecomeActive:(SCContext *)context;

- (void)scWillTerminate:(SCContext *)context;

- (void)scUnmount:(SCContext *)context;

- (void)scOpenURL:(SCContext *)context;

- (void)scDidReceiveMemoryWaring:(SCContext *)context;

- (void)scDidFailToRegisterForRemoteNotifications:(SCContext *)context;

- (void)scDidRegisterForRemoteNotifications:(SCContext *)context;

- (void)scDidReceiveRemoteNotification:(SCContext *)context;

- (void)scDidReceiveLocalNotification:(SCContext *)context;

- (void)scWillPresentNotification:(SCContext *)context;

- (void)scDidReceiveNotificationResponse:(SCContext *)context;

- (void)scWillContinueUserActivity:(SCContext *)context;

- (void)scContinueUserActivity:(SCContext *)context;

- (void)scDidFailToContinueUserActivity:(SCContext *)context;

- (void)scDidUpdateContinueUserActivity:(SCContext *)context;

- (void)scHandleWatchKitExtensionRequest:(SCContext *)context;

- (void)scDidCustomEvent:(SCContext *)context;

@end
