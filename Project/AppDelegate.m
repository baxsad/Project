//
//  AppDelegate.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "YGBUIConfigurationTemplate.h"

@interface AppDelegate ()<BuglyDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  [UIThemeManager sharedInstance].currentTheme = [[YGBUIConfigurationTemplate alloc] init];
  [NSGlobalTraking track];
  [self _setupBugly];
  
  ViewController *root = [[ViewController alloc] init];
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.window.rootViewController = root;
  [self.window makeKeyAndVisible];
  
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)_setupBugly
{
  BuglyConfig *config = [[BuglyConfig alloc] init];
#if DEBUG
  config.debugMode = YES;
#endif
  config.blockMonitorEnable = YES;
  config.blockMonitorTimeout = 1.5;
  config.channel = @"YGB";
  config.delegate = self;
  config.consolelogEnable = NO;
  config.viewControllerTrackingEnable = NO;
  [Bugly startWithAppId:@"9db722a8ad"
#if DEBUG
      developmentDevice:YES
#endif
                 config:config];
  
  [Bugly setTag:1799];
  [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@",
                            [UIDevice currentDevice].name]];
  [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
}

#pragma mark - BuglyDelegate

- (NSString *)attachmentForException:(NSException *)exception {
  NSLog(@"(%@:%d) %s %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__,exception);
  
  return @"This is an attachment";
}

@end
