//
//  NSGlobalTraking.m
//  Project
//
//  Created by jearoc on 2017/8/31.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "NSGlobalTraking.h"

#define Control [NSGlobalTraking sharedControl]

static NSString * const kUserDefaultsVersionTrailKey =      @"kGBVersionTrail";
static NSString * const kVersionsKey =                      @"kGBVersion";
static NSString * const kBuildsKey =                        @"kGBBuild";

@interface NSGlobalTraking ()

@property (strong, nonatomic) NSDictionary                  *versionTrail;
@property (assign, nonatomic) BOOL                          isFirstLaunchEver;
@property (assign, nonatomic) BOOL                          isFirstLaunchForVersion;
@property (assign, nonatomic) BOOL                          isFirstLaunchForBuild;

@end

@implementation NSGlobalTraking

#pragma mark - Storage

+ (NSGlobalTraking *)sharedControl {
  static NSGlobalTraking *sharedControl;
  @synchronized(self) {
    if (!sharedControl) {
      sharedControl = [NSGlobalTraking new];
    }
    return sharedControl;
  }
}

#pragma mark - Public API

+ (void)track {
  BOOL needsSync = NO;
  
  ///< 读取历史记录
  NSDictionary *oldVersionTrail = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsVersionTrailKey];
  
  ///< 检查是否是第一次 Launch
  if (oldVersionTrail == nil) {
    Control.isFirstLaunchEver = YES;
    
    Control.versionTrail = @{kVersionsKey: [NSMutableArray new], kBuildsKey: [NSMutableArray new]};
  }
  else {
    Control.isFirstLaunchEver = NO;
    
    ///< 加载历史记录
    Control.versionTrail = @{kVersionsKey: [oldVersionTrail[kVersionsKey] mutableCopy], kBuildsKey: [oldVersionTrail[kBuildsKey] mutableCopy]};
    
    needsSync = YES;
  }
  
  ///< 检查是否是当前版本第一次 Launch
  if ([Control.versionTrail[kVersionsKey] containsObject:[self currentVersion]]) {
    Control.isFirstLaunchForVersion = NO;
  }
  else {
    Control.isFirstLaunchForVersion = YES;
    
    [Control.versionTrail[kVersionsKey] addObject:[self currentVersion]];
    
    needsSync = YES;
  }
  
  ///< 检查是否是当前 Build 第一次 Launch
  if ([Control.versionTrail[kBuildsKey] containsObject:[self currentBuild]]) {
    Control.isFirstLaunchForBuild = NO;
  }
  else {
    Control.isFirstLaunchForBuild = YES;
    
    [Control.versionTrail[kBuildsKey] addObject:[self currentBuild]];
    
    needsSync = YES;
  }
  
  ///< 持久化
  if (needsSync) {
    [[NSUserDefaults standardUserDefaults] setObject:Control.versionTrail forKey:kUserDefaultsVersionTrailKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
}

+ (BOOL)isFirstLaunchEver {
  return Control.isFirstLaunchEver;
}

+ (BOOL)isFirstLaunchForVersion {
  return Control.isFirstLaunchForVersion;
}

+ (BOOL)isFirstLaunchForBuild {
  return Control.isFirstLaunchForBuild;
}

+ (BOOL)isFirstLaunchForVersion:(NSString *)version {
  if ([[self currentVersion] isEqualToString:version]) {
    return [self isFirstLaunchForVersion];
  }
  else {
    return NO;
  }
}

+ (BOOL)isFirstLaunchForBuild:(NSString *)build {
  if ([[self currentBuild] isEqualToString:build]) {
    return [self isFirstLaunchForBuild];
  }
  else {
    return NO;
  }
}

#pragma mark - Versions

+ (NSString *)currentVersion {
  return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)previousVersion {
  NSUInteger count = [Control.versionTrail[kVersionsKey] count];
  if (count >= 2) {
    return Control.versionTrail[kVersionsKey][count-2];
  }
  else return nil;
}

+ (NSString *)firstInstalledVersion {
  return [Control.versionTrail[kVersionsKey] firstObject];
}

+ (NSArray *)versionHistory {
  return Control.versionTrail[kVersionsKey];
}

#pragma mark - Builds

+ (NSString *)currentBuild {
  return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

+ (NSString *)previousBuild {
  NSUInteger count = [Control.versionTrail[kBuildsKey] count];
  if (count >= 2) {
    return Control.versionTrail[kBuildsKey][count-2];
  }
  else return nil;
}

+ (NSString *)firstInstalledBuild {
  return [Control.versionTrail[kBuildsKey] firstObject];
}

+ (NSArray *)buildHistory {
  return Control.versionTrail[kBuildsKey];
}


@end
