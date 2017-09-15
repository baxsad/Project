//
//  NSGlobalTraking.h
//  Project
//
//  Created by jearoc on 2017/8/31.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSGlobalTraking : NSObject

+ (void)track;

+ (BOOL)isFirstLaunchEver;

+ (BOOL)isFirstLaunchForVersion;

+ (BOOL)isFirstLaunchForBuild;

+ (BOOL)isFirstLaunchForVersion:(NSString *)version;

+ (BOOL)isFirstLaunchForBuild:(NSString *)build;

+ (NSString *)currentVersion;

+ (NSString *)previousVersion;

+ (NSString *)firstInstalledVersion;

+ (NSArray *)versionHistory;

+ (NSString *)currentBuild;

+ (NSString *)previousBuild;

+ (NSString *)firstInstalledBuild;

+ (NSArray *)buildHistory;

@end
