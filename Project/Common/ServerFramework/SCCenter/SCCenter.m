//
//  SCCenter.m
//  Project
//
//  Created by jearoc on 2017/9/15.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "SCCenter.h"

static  NSString *kSetupSelector = @"modSetUp:";
static  NSString *kInitSelector = @"modInit:";
static  NSString *kSplashSeletor = @"modSplash:";
static  NSString *kTearDownSelector = @"modTearDown:";
static  NSString *kWillResignActiveSelector = @"modWillResignActive:";
static  NSString *kDidEnterBackgroundSelector = @"modDidEnterBackground:";
static  NSString *kWillEnterForegroundSelector = @"modWillEnterForeground:";
static  NSString *kDidBecomeActiveSelector = @"modDidBecomeActive:";
static  NSString *kWillTerminateSelector = @"modWillTerminate:";
static  NSString *kUnmountEventSelector = @"modUnmount:";
static  NSString *kQuickActionSelector = @"modQuickAction:";
static  NSString *kOpenURLSelector = @"modOpenURL:";
static  NSString *kDidReceiveMemoryWarningSelector = @"modDidReceiveMemoryWaring:";
static  NSString *kFailToRegisterForRemoteNotificationsSelector = @"modDidFailToRegisterForRemoteNotifications:";
static  NSString *kDidRegisterForRemoteNotificationsSelector = @"modDidRegisterForRemoteNotifications:";
static  NSString *kDidReceiveRemoteNotificationsSelector = @"modDidReceiveRemoteNotification:";
static  NSString *kDidReceiveLocalNotificationsSelector = @"modDidReceiveLocalNotification:";
static  NSString *kWillPresentNotificationSelector = @"modWillPresentNotification:";
static  NSString *kDidReceiveNotificationResponseSelector = @"modDidReceiveNotificationResponse:";
static  NSString *kWillContinueUserActivitySelector = @"modWillContinueUserActivity:";
static  NSString *kContinueUserActivitySelector = @"modContinueUserActivity:";
static  NSString *kDidUpdateContinueUserActivitySelector = @"modDidUpdateContinueUserActivity:";
static  NSString *kFailToContinueUserActivitySelector = @"modDidFailToContinueUserActivity:";
static  NSString *kHandleWatchKitExtensionRequestSelector = @"modHandleWatchKitExtensionRequest:";
static  NSString *kAppCustomSelector = @"modDidCustomEvent:";

@interface SCCenter ()
@property(nonatomic, strong) NSMutableDictionary<NSNumber *, NSString *> *SCSelectorByEvent;
@end

@implementation SCCenter

#pragma mark - public

+ (instancetype)defaultCenter
{
  static dispatch_once_t p;
  static id SCCInstance = nil;
  
  dispatch_once(&p, ^{
    SCCInstance = [[self alloc] init];
  });
  
  return SCCInstance;
}

- (instancetype)init
{
  if (self = [super init]) {
    _context = [SCContext defaultContext];
  }
  return self;
}

- (void)triggerEvent:(SCEventType)eventType
{
  [self triggerEvent:eventType
     withCustomParam:nil];
}

- (void)triggerEvent:(SCEventType)eventType
     withCustomParam:(NSDictionary *)customParam
{
  switch (eventType) {
    case SCInitEvent:
      //special
      [self handleModulesInitEventForTarget:nil withCustomParam :customParam];
      break;
    case SCTearDownEvent:
      //special
      [self handleModulesTearDownEventForTarget:nil withCustomParam:customParam];
      break;
    default: {
      NSString *selectorStr = [self.SCSelectorByEvent objectForKey:@(eventType)];
      [self handleModuleEvent:eventType forTarget:nil withSeletorStr:selectorStr andCustomParam:customParam];
    }
      break;
  }
}

- (void)handleModulesInitEventForTarget:(id)target
                        withCustomParam:(NSDictionary *)customParam
{
  
}

- (void)handleModulesTearDownEventForTarget:(id)target
                            withCustomParam:(NSDictionary *)customParam
{
  
}

- (void)handleModuleEvent:(NSInteger)eventType
                forTarget:(id)target
           withSeletorStr:(NSString *)selectorStr
           andCustomParam:(NSDictionary *)customParam
{
  
}

#pragma mark - getter

- (NSMutableDictionary<NSNumber *, NSString *> *)SCSelectorByEvent
{
  if (!_SCSelectorByEvent) {
    _SCSelectorByEvent = @{
                           @(SCSetupEvent):kSetupSelector,
                           @(SCInitEvent):kInitSelector,
                           @(SCTearDownEvent):kTearDownSelector,
                           @(SCSplashEvent):kSplashSeletor,
                           @(SCWillResignActiveEvent):kWillResignActiveSelector,
                           @(SCDidEnterBackgroundEvent):kDidEnterBackgroundSelector,
                           @(SCWillEnterForegroundEvent):kWillEnterForegroundSelector,
                           @(SCDidBecomeActiveEvent):kDidBecomeActiveSelector,
                           @(SCWillTerminateEvent):kWillTerminateSelector,
                           @(SCUnmountEvent):kUnmountEventSelector,
                           @(SCOpenURLEvent):kOpenURLSelector,
                           @(SCDidReceiveMemoryWarningEvent):kDidReceiveMemoryWarningSelector,
                           @(SCDidReceiveRemoteNotificationEvent):kDidReceiveRemoteNotificationsSelector,
                           @(SCWillPresentNotificationEvent):kWillPresentNotificationSelector,
                           @(SCDidReceiveNotificationResponseEvent):kDidReceiveNotificationResponseSelector,
                           @(SCDidFailToRegisterForRemoteNotificationsEvent):kFailToRegisterForRemoteNotificationsSelector,
                           @(SCDidRegisterForRemoteNotificationsEvent):kDidRegisterForRemoteNotificationsSelector,
                           @(SCDidReceiveLocalNotificationEvent):kDidReceiveLocalNotificationsSelector,
                           @(SCWillContinueUserActivityEvent):kWillContinueUserActivitySelector,
                           @(SCContinueUserActivityEvent):kContinueUserActivitySelector,
                           @(SCDidFailToContinueUserActivityEvent):kFailToContinueUserActivitySelector,
                           @(SCDidUpdateUserActivityEvent):kDidUpdateContinueUserActivitySelector,
                           @(SCQuickActionEvent):kQuickActionSelector,
                           @(SCHandleWatchKitExtensionRequestEvent):kHandleWatchKitExtensionRequestSelector,
                           @(SCDidCustomEvent):kAppCustomSelector,
                           }.mutableCopy;
  }
  return _SCSelectorByEvent;
}

@end
