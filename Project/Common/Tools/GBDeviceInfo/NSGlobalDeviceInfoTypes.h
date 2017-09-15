//
//  NSGlobalDeviceInfoTypes.h
//  Project
//
//  Created by jearoc on 2017/8/31.
//  Copyright © 2017年 jearoc. All rights reserved.
//

typedef NS_ENUM(NSInteger, NSGlobalDeviceModel) {
  NSGlobalDeviceModelUnknown = 0,
  NSGlobalDeviceModelSimulatoriPhone,
  NSGlobalDeviceModelSimulatoriPad,
  NSGlobalDeviceModeliPhone1,
  NSGlobalDeviceModeliPhone3G,
  NSGlobalDeviceModeliPhone3GS,
  NSGlobalDeviceModeliPhone4,
  NSGlobalDeviceModeliPhone4S,
  NSGlobalDeviceModeliPhone5,
  NSGlobalDeviceModeliPhone5c,
  NSGlobalDeviceModeliPhone5s,
  NSGlobalDeviceModeliPhoneSE,
  NSGlobalDeviceModeliPhone6,
  NSGlobalDeviceModeliPhone6Plus,
  NSGlobalDeviceModeliPhone6s,
  NSGlobalDeviceModeliPhone6sPlus,
  NSGlobalDeviceModeliPhone7,
  NSGlobalDeviceModeliPhone7Plus,
  NSGlobalDeviceModeliPad1,
  NSGlobalDeviceModeliPad2,
  NSGlobalDeviceModeliPad3,
  NSGlobalDeviceModeliPad4,
  NSGlobalDeviceModeliPadMini1,
  NSGlobalDeviceModeliPadMini2,
  NSGlobalDeviceModeliPadMini3,
  NSGlobalDeviceModeliPadMini4,
  NSGlobalDeviceModeliPadAir1,
  NSGlobalDeviceModeliPadAir2,
  NSGlobalDeviceModeliPadPro9p7Inch,
  NSGlobalDeviceModeliPadPro12p9Inch,
  NSGlobalDeviceModeliPad5,
  NSGlobalDeviceModeliPod1,
  NSGlobalDeviceModeliPod2,
  NSGlobalDeviceModeliPod3,
  NSGlobalDeviceModeliPod4,
  NSGlobalDeviceModeliPod5,
  NSGlobalDeviceModeliPod6,
};

typedef NS_ENUM(NSInteger, NSGlobalDeviceDisplay) {
  NSGlobalDeviceDisplayUnknown = 0,
  NSGlobalDeviceDisplay3p5Inch,
  NSGlobalDeviceDisplay4Inch,
  NSGlobalDeviceDisplay4p7Inch,
  NSGlobalDeviceDisplay5p5Inch,
  NSGlobalDeviceDisplay7p9Inch,
  NSGlobalDeviceDisplay9p7Inch,
  NSGlobalDeviceDisplay12p9Inch,
};

typedef NS_ENUM(NSInteger, NSGlobalDeviceFamily) {
  NSGlobalDeviceFamilyUnknown = 0,
  NSGlobalDeviceFamilyiPhone,
  NSGlobalDeviceFamilyiPad,
  NSGlobalDeviceFamilyiPod,
  NSGlobalDeviceFamilySimulator,
};

typedef struct {
  CGFloat                                             frequency;
  NSUInteger                                          numberOfCores;
  CGFloat                                             l2CacheSize;
} NSGlobalCPUInfo;

typedef struct {
  NSUInteger                                          major;
  NSUInteger                                          minor;
} NSGlobalDeviceVersion;

typedef struct {
  NSGlobalDeviceDisplay                                     display;
  CGFloat                                             pixelsPerInch;
} NSGlobalDisplayInfo;

inline static NSGlobalCPUInfo NSGlobalCPUInfoMake(CGFloat frequency, NSUInteger numberOfCores, CGFloat l2CacheSize) {
  return (NSGlobalCPUInfo){frequency, numberOfCores, l2CacheSize};
};

inline static NSGlobalDeviceVersion NSGlobalDeviceVersionMake(NSUInteger major, NSUInteger minor) {
  return (NSGlobalDeviceVersion){major, minor};
};

inline static NSGlobalDisplayInfo NSGlobalDisplayInfoMake(NSGlobalDeviceDisplay display, CGFloat pixelsPerInch) {
  return (NSGlobalDisplayInfo){display, pixelsPerInch};
};
