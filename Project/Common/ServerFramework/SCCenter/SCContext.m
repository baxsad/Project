//
//  SCContext.m
//  Project
//
//  Created by jearoc on 2017/9/15.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "SCContext.h"

@implementation SCContext

+ (instancetype)defaultContext
{
  static dispatch_once_t p;
  static id SCInstance = nil;
  
  dispatch_once(&p, ^{
    SCInstance = [[[self class] alloc] init];
  });
  
  return SCInstance;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400
    self.touchShortcutItem = [SCShortcutItem new];
#endif
    self.openURLItem = [SCOpenURLItem new];
    self.notificationsItem = [SCNotificationsItem new];
    self.userActivityItem = [SCUserActivityItem new];
    self.watchItem = [SCWatchItem new];
  }
  
  return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  SCContext *context = [[self.class allocWithZone:zone] init];
  
  context.application = self.application;
  context.launchOptions = self.launchOptions;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400
  context.touchShortcutItem = self.touchShortcutItem;
#endif
  context.openURLItem = self.openURLItem;
  context.notificationsItem = self.notificationsItem;
  context.userActivityItem = self.userActivityItem;
  context.watchItem = self.watchItem;
  
  return context;
}

@end
