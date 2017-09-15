//
//  NSGlobalDeviceInfo.h
//  Project
//
//  Created by jearoc on 2017/8/31.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NSGlobalDeviceInfoInterface.h"
#import "NSGlobalDeviceInfoTypes.h"

@interface NSGlobalDeviceInfo : NSObject<NSGlobalDeviceInfoInterface>

@property (strong, atomic, readonly) NSString *name;///< e.g. "王锐 的 iPhone".

@property (strong, atomic, readonly) NSString *systemName;///< e.g. "iOS".

@property (strong, atomic, readonly) NSString *systemVersion;///< e.g. "10.3.3".

@property (assign, atomic, readonly) NSGlobalDeviceVersion deviceVersion;///< e.g. {7,2}.

@property (strong, atomic, readonly) NSString *deviceInfoString;///< e.g. "iPhone7,2".

@property (assign, atomic, readonly) NSGlobalDeviceFamily family;///< e.g. NSGlobalDeviceFamilyiPhone.

@property (assign, atomic, readonly) NSGlobalDeviceModel model;///< e.g. NSGlobalDeviceModeliPhone6.

@property (strong, atomic, readonly) NSString *modelString;///<  e.g. "iPhone 6".

@property (assign, atomic, readonly) NSGlobalDisplayInfo displayInfo;

@property (assign, atomic, readonly) NSGlobalCPUInfo cpuInfo;

@property (assign, atomic, readonly) CGFloat physicalMemory;///< GB (gibi)

@end
