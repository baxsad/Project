//
//  SCCenter.h
//  Project
//
//  Created by jearoc on 2017/9/15.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCContext.h"
#import "SCCenterProtocol.h"

typedef NS_ENUM(NSInteger, SCEventType)
{
  SCSetupEvent = 0,
  SCInitEvent,
  SCTearDownEvent,
  SCSplashEvent,
  SCQuickActionEvent,
  SCWillResignActiveEvent,
  SCDidEnterBackgroundEvent,
  SCWillEnterForegroundEvent,
  SCDidBecomeActiveEvent,
  SCWillTerminateEvent,
  SCUnmountEvent,
  SCOpenURLEvent,
  SCDidReceiveMemoryWarningEvent,
  SCDidFailToRegisterForRemoteNotificationsEvent,
  SCDidRegisterForRemoteNotificationsEvent,
  SCDidReceiveRemoteNotificationEvent,
  SCDidReceiveLocalNotificationEvent,
  SCWillPresentNotificationEvent,
  SCDidReceiveNotificationResponseEvent,
  SCWillContinueUserActivityEvent,
  SCContinueUserActivityEvent,
  SCDidFailToContinueUserActivityEvent,
  SCDidUpdateUserActivityEvent,
  SCHandleWatchKitExtensionRequestEvent,
  SCDidCustomEvent = 1000
};

@interface SCCenter : NSObject

@property (nonatomic, strong, readonly) SCContext *context;
@property (nonatomic, assign) BOOL enableException;
+ (instancetype)defaultCenter;

- (void)triggerEvent:(SCEventType)eventType;
- (void)triggerEvent:(SCEventType)eventType
     withCustomParam:(NSDictionary *)customParam;

+ (void)registerDynamicListener:(Class)listener;
- (void)registerDynamicListener:(Class)listener;

@end
