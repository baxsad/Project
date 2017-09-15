//
//  MainDelegate.m
//  Project
//
//  Created by jearoc on 2017/9/15.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "MainDelegate.h"
#import "SCCenter.h"

@interface MainDelegate ()

@end

@implementation MainDelegate

#pragma mark - 启动程序

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions NS_AVAILABLE_IOS(6_0)
{
  /**
   *  告诉代理进程启动但还没进入状态保存
   *  启动程序 ： (1)
   */
  
  return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  /**
   *  告诉代理启动基本完成程序准备开始运行
   *  启动程序 ： (2)
   */
  [SCContext defaultContext].application = application;
  [SCContext defaultContext].launchOptions = launchOptions;
  [SCCenter defaultCenter].enableException = YES;
  
  [[SCCenter defaultCenter] triggerEvent:SCSetupEvent];
  [[SCCenter defaultCenter] triggerEvent:SCInitEvent];
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [[SCCenter defaultCenter] triggerEvent:SCSplashEvent];
  });
  
  return YES;
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
  /**
   *  3DTouch
   */
  [[SCContext defaultContext].touchShortcutItem setShortcutItem:shortcutItem];
  [[SCContext defaultContext].touchShortcutItem setScompletionHandler:completionHandler];
  [[SCCenter defaultCenter] triggerEvent:SCQuickActionEvent];
}
#endif

#pragma mark - 按下home键

- (void)applicationWillResignActive:(UIApplication *)application
{
  /**
   *  当应用程序将要入非活动状态执行，在此期间，应用程序不接收消息或事件，比如来电话了
   *  按下home键 ： (1)
   */
  [[SCCenter defaultCenter] triggerEvent:SCWillResignActiveEvent];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  /**
   *  当程序被推送到后台的时候调用。所以要设置后台继续运行，则在这个函数里面设置即可
   *  按下home键 ： (2)
   */
  [[SCCenter defaultCenter] triggerEvent:SCDidEnterBackgroundEvent];
}

#pragma mark - 双击home键，再打开程序

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  /**
   *  当程序从后台将要重新回到前台时候调用，和 applicationDidEnterBackground 相反
   *   从后台再打开程序 ： (1)
   */
  [[SCCenter defaultCenter] triggerEvent:SCWillEnterForegroundEvent];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  /**
   *  当应用程序入活动状态执行，和 applicationWillResignActive 相反
   *   从后台再打开程序 ： (2)
   */
  [[SCCenter defaultCenter] triggerEvent:SCDidBecomeActiveEvent];
}

#pragma mark - 程序退出杀死

- (void)applicationWillTerminate:(UIApplication *)application
{
  /**
   *  当程序将要退出是被调用，通常是用来保存数据和一些退出前的清理工作。这个需要要设置UIApplicationExitsOnSuspend的键值。
   */
  [[SCCenter defaultCenter] triggerEvent:SCWillTerminateEvent];
}

#pragma mark - 从其他应用调起

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
  /**
   *  app 被从其他应用调起
   *  iOS4.2的时候推出
   */
  [[SCContext defaultContext].openURLItem setOpenURL:url];
  [[SCContext defaultContext].openURLItem setSourceApplication:sourceApplication];
  [[SCContext defaultContext].openURLItem setAnnotation:annotation];
  [[SCCenter defaultCenter] triggerEvent:SCOpenURLEvent];
  return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
  
  /**
   *  app 被从其他应用调起
   *  iOS9.0的时候推出
   */
  [[SCContext defaultContext].openURLItem setOpenURL:url];
  [[SCContext defaultContext].openURLItem setOptions:options];
  [[SCCenter defaultCenter] triggerEvent:SCOpenURLEvent];
  return YES;
}
#endif

#pragma mark - 应用接收内存警告消息

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
  [[SCCenter defaultCenter] triggerEvent:SCDidReceiveMemoryWarningEvent];
}

#pragma mark - 通知

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
  /**
   *  注册远程通知失败
   */
  [[SCContext defaultContext].notificationsItem setNotificationsError:error];
  [[SCCenter defaultCenter] triggerEvent:SCDidFailToRegisterForRemoteNotificationsEvent];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
  /**
   *  远程通知注册成功，APNs返回设备的deviceToken
   */
  [[SCContext defaultContext].notificationsItem setDeviceToken: deviceToken];
  [[SCCenter defaultCenter] triggerEvent:SCDidRegisterForRemoteNotificationsEvent];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
  /**
   *  接受到远程通知消息
   *  iOS7-
   */
  [[SCContext defaultContext].notificationsItem setUserInfo: userInfo];
  [[SCCenter defaultCenter] triggerEvent:SCDidReceiveRemoteNotificationEvent];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
  /**
   *  接受到远程通知消息
   *  iOS7+
   */
  [[SCContext defaultContext].notificationsItem setUserInfo: userInfo];
  [[SCContext defaultContext].notificationsItem setNotificationResultHander: completionHandler];
  [[SCCenter defaultCenter] triggerEvent:SCDidReceiveRemoteNotificationEvent];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
  /**
   *  接受到本地通知消息
   *  iOS7-
   */
  [[SCContext defaultContext].notificationsItem setLocalNotification: notification];
  [[SCCenter defaultCenter] triggerEvent:SCDidReceiveLocalNotificationEvent];
}

#pragma mark - 用户活动

#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80000
- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity
{
  if([UIDevice currentDevice].systemVersion.floatValue > 8.0f){
    [[SCContext defaultContext].userActivityItem setUserActivity: userActivity];
    [[SCCenter defaultCenter] triggerEvent:SCDidUpdateUserActivityEvent];
  }
}

- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error
{
  if([UIDevice currentDevice].systemVersion.floatValue > 8.0f){
    [[SCContext defaultContext].userActivityItem setUserActivityType: userActivityType];
    [[SCContext defaultContext].userActivityItem setUserActivityError: error];
    [[SCCenter defaultCenter] triggerEvent:SCDidFailToContinueUserActivityEvent];
  }
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
  if([UIDevice currentDevice].systemVersion.floatValue > 8.0f){
    [[SCContext defaultContext].userActivityItem setUserActivity: userActivity];
    [[SCContext defaultContext].userActivityItem setRestorationHandler: restorationHandler];
    [[SCCenter defaultCenter] triggerEvent:SCContinueUserActivityEvent];
  }
  return YES;
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType
{
  if([UIDevice currentDevice].systemVersion.floatValue > 8.0f){
    [[SCContext defaultContext].userActivityItem setUserActivityType: userActivityType];
    [[SCCenter defaultCenter] triggerEvent:SCWillContinueUserActivityEvent];
  }
  return YES;
}

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(nullable NSDictionary *)userInfo reply:(void(^)(NSDictionary * __nullable replyInfo))reply {
  if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
    [SCContext defaultContext].watchItem.userInfo = userInfo;
    [SCContext defaultContext].watchItem.replyHandler = reply;
    [[SCCenter defaultCenter] triggerEvent:SCHandleWatchKitExtensionRequestEvent];
  }
}
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
  [[SCContext defaultContext].notificationsItem setNotification: notification];
  [[SCContext defaultContext].notificationsItem setNotificationPresentationOptionsHandler: completionHandler];
  [[SCContext defaultContext].notificationsItem setCenter:center];
  [[SCCenter defaultCenter] triggerEvent:SCWillPresentNotificationEvent];
};

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
  [[SCContext defaultContext].notificationsItem setNotificationResponse: response];
  [[SCContext defaultContext].notificationsItem setNotificationCompletionHandler:completionHandler];
  [[SCContext defaultContext].notificationsItem setCenter:center];
  [[SCCenter defaultCenter] triggerEvent:SCDidReceiveNotificationResponseEvent];
};
#endif

@end
