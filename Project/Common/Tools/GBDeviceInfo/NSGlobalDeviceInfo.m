//
//  NSGlobalDeviceInfo.m
//  Project
//
//  Created by jearoc on 2017/8/31.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "NSGlobalDeviceInfo.h"
#import <stdlib.h>
#import <stdio.h>
#import <sys/types.h>
#import <sys/sysctl.h>
#import <sys/utsname.h>
#import "dlfcn.h"

static NSString * const kHardwareCPUFrequencyKey =          @"hw.cpufrequency";
static NSString * const kHardwareNumberOfCoresKey =         @"hw.ncpu";
static NSString * const kHardwareByteOrderKey =             @"hw.byteorder";
static NSString * const kHardwareL2CacheSizeKey =           @"hw.l2cachesize";

@interface NSGlobalDeviceInfo ()

@property (strong, atomic, readwrite) NSString *name;
@property (strong, atomic, readwrite) NSString *systemName;
@property (strong, atomic, readwrite) NSString *systemVersion;
@property (strong, atomic, readwrite) NSString *deviceInfoString;
@property (assign, atomic, readwrite) NSGlobalDeviceVersion deviceVersion;
@property (assign, atomic, readwrite) NSGlobalDeviceFamily family;
@property (assign, atomic, readwrite) NSGlobalDeviceModel model;
@property (strong, atomic, readwrite) NSString *modelString;
@property (assign, atomic, readwrite) NSGlobalDisplayInfo displayInfo;
@property (assign, atomic, readwrite) NSGlobalCPUInfo cpuInfo;
@property (assign, atomic, readwrite) CGFloat physicalMemory;

@end

@implementation NSGlobalDeviceInfo

- (NSString *)description {
  return [NSString stringWithFormat:@"%@\nname:%@\nsystemName:%@\nsystemVersion:%@\ndeviceInfoString: %@\nmodel: %ld\nfamily: %ld\ndisplay: %ld\nppi: %ld\ndeviceVersion.major: %ld\ndeviceVersion.minor: %ld\ncpuInfo.frequency: %.3f\ncpuInfo.numberOfCores: %ld\ncpuInfo.l2CacheSize: %.3f\npysicalMemory: %.3f",
          [super description],
          self.name,
          self.systemName,
          self.systemVersion,
          self.deviceInfoString,
          (long)self.model,
          (long)self.family,
          (long)self.displayInfo.display,
          (unsigned long)self.displayInfo.pixelsPerInch,
          (unsigned long)self.deviceVersion.major,
          (unsigned long)self.deviceVersion.minor,
          self.cpuInfo.frequency,
          (unsigned long)self.cpuInfo.numberOfCores,
          self.cpuInfo.l2CacheSize,
          self.physicalMemory
          ];
}

#pragma mark - Public

+ (instancetype)deviceInfo {
  static id _shared;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _shared = [self new];
  });
  
  return _shared;
}

- (instancetype)init {
  if (self = [super init]) {
    
    self.name = [UIDevice currentDevice].name;
    
    self.systemName = [UIDevice currentDevice].systemName;
    
    self.systemVersion = [UIDevice currentDevice].systemVersion;
    
    self.deviceInfoString = [self.class _rawDeviceInfoString];
    
    self.deviceVersion = [self.class _deviceVersion];
    
    NSArray *modelNuances = [self.class _modelNuances];
    self.family = [modelNuances[0] integerValue];
    self.model = [modelNuances[1] integerValue];
    self.modelString = modelNuances[2];
    self.displayInfo = NSGlobalDisplayInfoMake([modelNuances[3] integerValue], [modelNuances[4] doubleValue]);
    
    self.physicalMemory = [self.class _physicalMemory];
    
    self.cpuInfo = [self.class _cpuInfo];
  }
  
  return self;
}

#pragma mark - Private

#pragma mark - Private API

+ (NSString *)_rawDeviceInfoString {
  struct utsname systemInfo;
  uname(&systemInfo);
  return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSGlobalDeviceVersion)_deviceVersion {
  NSString *deviceInfoString = [self _rawDeviceInfoString];
  
  NSUInteger positionOfFirstInteger = [deviceInfoString rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location;
  NSUInteger positionOfComma = [deviceInfoString rangeOfString:@","].location;
  
  NSUInteger major = 0;
  NSUInteger minor = 0;
  
  if (positionOfComma != NSNotFound) {
    major = [[deviceInfoString substringWithRange:NSMakeRange(positionOfFirstInteger, positionOfComma - positionOfFirstInteger)] integerValue];
    minor = [[deviceInfoString substringFromIndex:positionOfComma + 1] integerValue];
  }
  
  return NSGlobalDeviceVersionMake(major, minor);
}

+ (NSArray *)_modelNuances {
  NSGlobalDeviceFamily family = NSGlobalDeviceFamilyUnknown;
  NSGlobalDeviceModel model = NSGlobalDeviceModelUnknown;
  NSString *modelString = @"Unknown Device";
  NSGlobalDeviceDisplay display = NSGlobalDeviceDisplayUnknown;
  CGFloat pixelsPerInch = 0;
  
  // Simulator
  if (TARGET_IPHONE_SIMULATOR) {
    family = NSGlobalDeviceFamilySimulator;
    BOOL iPadScreen = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    model = iPadScreen ? NSGlobalDeviceModelSimulatoriPad : NSGlobalDeviceModelSimulatoriPhone;
    modelString = iPadScreen ? @"iPad Simulator": @"iPhone Simulator";
    display = NSGlobalDeviceDisplayUnknown;
    pixelsPerInch = 0;
  }
  // Actual device
  else {
    NSGlobalDeviceVersion deviceVersion = [self _deviceVersion];
    NSString *deviceInfoString = [self _rawDeviceInfoString];
    
    
    NSDictionary *familyManifest = @{
                                     @"iPhone": @(NSGlobalDeviceFamilyiPhone),
                                     @"iPad": @(NSGlobalDeviceFamilyiPad),
                                     @"iPod": @(NSGlobalDeviceFamilyiPod),
                                     };
    
    NSDictionary *modelManifest = @{
                                    @"iPhone": @{
                                        // 1st Gen
                                        @[@1, @1]: @[@(NSGlobalDeviceModeliPhone1), @"iPhone 1", @(NSGlobalDeviceDisplay3p5Inch), @163],
                                        
                                        // 3G
                                        @[@1, @2]: @[@(NSGlobalDeviceModeliPhone3G), @"iPhone 3G", @(NSGlobalDeviceDisplay3p5Inch), @163],
                                        
                                        // 3GS
                                        @[@2, @1]: @[@(NSGlobalDeviceModeliPhone3GS), @"iPhone 3GS", @(NSGlobalDeviceDisplay3p5Inch), @163],
                                        
                                        // 4
                                        @[@3, @1]: @[@(NSGlobalDeviceModeliPhone4), @"iPhone 4", @(NSGlobalDeviceDisplay3p5Inch), @326],
                                        @[@3, @2]: @[@(NSGlobalDeviceModeliPhone4), @"iPhone 4", @(NSGlobalDeviceDisplay3p5Inch), @326],
                                        @[@3, @3]: @[@(NSGlobalDeviceModeliPhone4), @"iPhone 4", @(NSGlobalDeviceDisplay3p5Inch), @326],
                                        
                                        // 4S
                                        @[@4, @1]: @[@(NSGlobalDeviceModeliPhone4S), @"iPhone 4S", @(NSGlobalDeviceDisplay3p5Inch), @326],
                                        
                                        // 5
                                        @[@5, @1]: @[@(NSGlobalDeviceModeliPhone5), @"iPhone 5", @(NSGlobalDeviceDisplay4Inch), @326],
                                        @[@5, @2]: @[@(NSGlobalDeviceModeliPhone5), @"iPhone 5", @(NSGlobalDeviceDisplay4Inch), @326],
                                        
                                        // 5c
                                        @[@5, @3]: @[@(NSGlobalDeviceModeliPhone5c), @"iPhone 5c", @(NSGlobalDeviceDisplay4Inch), @326],
                                        @[@5, @4]: @[@(NSGlobalDeviceModeliPhone5c), @"iPhone 5c", @(NSGlobalDeviceDisplay4Inch), @326],
                                        
                                        // 5s
                                        @[@6, @1]: @[@(NSGlobalDeviceModeliPhone5s), @"iPhone 5s", @(NSGlobalDeviceDisplay4Inch), @326],
                                        @[@6, @2]: @[@(NSGlobalDeviceModeliPhone5s), @"iPhone 5s", @(NSGlobalDeviceDisplay4Inch), @326],
                                        
                                        // 6 Plus
                                        @[@7, @1]: @[@(NSGlobalDeviceModeliPhone6Plus), @"iPhone 6 Plus", @(NSGlobalDeviceDisplay5p5Inch), @401],
                                        
                                        // 6
                                        @[@7, @2]: @[@(NSGlobalDeviceModeliPhone6), @"iPhone 6", @(NSGlobalDeviceDisplay4p7Inch), @326],
                                        
                                        // 6s
                                        @[@8, @1]: @[@(NSGlobalDeviceModeliPhone6s), @"iPhone 6s", @(NSGlobalDeviceDisplay4p7Inch), @326],
                                        
                                        // 6s Plus
                                        @[@8, @2]: @[@(NSGlobalDeviceModeliPhone6sPlus), @"iPhone 6s Plus", @(NSGlobalDeviceDisplay5p5Inch), @401],
                                        
                                        // SE
                                        @[@8, @4]: @[@(NSGlobalDeviceModeliPhoneSE), @"iPhone SE", @(NSGlobalDeviceDisplay4Inch), @326],
                                        
                                        // 7
                                        @[@9, @1]: @[@(NSGlobalDeviceModeliPhone7), @"iPhone 7", @(NSGlobalDeviceDisplay4p7Inch), @326],
                                        @[@9, @3]: @[@(NSGlobalDeviceModeliPhone7), @"iPhone 7", @(NSGlobalDeviceDisplay4p7Inch), @326],
                                        
                                        // 7 Plus
                                        @[@9, @2]: @[@(NSGlobalDeviceModeliPhone7Plus), @"iPhone 7 Plus", @(NSGlobalDeviceDisplay5p5Inch), @401],
                                        @[@9, @4]: @[@(NSGlobalDeviceModeliPhone7Plus), @"iPhone 7 Plus", @(NSGlobalDeviceDisplay5p5Inch), @401],
                                        },
                                    @"iPad": @{
                                        // 1
                                        @[@1, @1]: @[@(NSGlobalDeviceModeliPad1), @"iPad 1", @(NSGlobalDeviceDisplay9p7Inch), @132],
                                        
                                        // 2
                                        @[@2, @1]: @[@(NSGlobalDeviceModeliPad2), @"iPad 2", @(NSGlobalDeviceDisplay9p7Inch), @132],
                                        @[@2, @2]: @[@(NSGlobalDeviceModeliPad2), @"iPad 2", @(NSGlobalDeviceDisplay9p7Inch), @132],
                                        @[@2, @3]: @[@(NSGlobalDeviceModeliPad2), @"iPad 2", @(NSGlobalDeviceDisplay9p7Inch), @132],
                                        @[@2, @4]: @[@(NSGlobalDeviceModeliPad2), @"iPad 2", @(NSGlobalDeviceDisplay9p7Inch), @132],
                                        
                                        // Mini
                                        @[@2, @5]: @[@(NSGlobalDeviceModeliPadMini1), @"iPad Mini 1", @(NSGlobalDeviceDisplay7p9Inch), @163],
                                        @[@2, @6]: @[@(NSGlobalDeviceModeliPadMini1), @"iPad Mini 1", @(NSGlobalDeviceDisplay7p9Inch), @163],
                                        @[@2, @7]: @[@(NSGlobalDeviceModeliPadMini1), @"iPad Mini 1", @(NSGlobalDeviceDisplay7p9Inch), @163],
                                        
                                        // 3
                                        @[@3, @1]: @[@(NSGlobalDeviceModeliPad3), @"iPad 3", @(NSGlobalDeviceDisplay9p7Inch), @264],
                                        @[@3, @2]: @[@(NSGlobalDeviceModeliPad3), @"iPad 3", @(NSGlobalDeviceDisplay9p7Inch), @264],
                                        @[@3, @3]: @[@(NSGlobalDeviceModeliPad3), @"iPad 3", @(NSGlobalDeviceDisplay9p7Inch), @264],
                                        
                                        // 4
                                        @[@3, @4]: @[@(NSGlobalDeviceModeliPad4), @"iPad 4", @(NSGlobalDeviceDisplay9p7Inch), @264],
                                        @[@3, @5]: @[@(NSGlobalDeviceModeliPad4), @"iPad 4", @(NSGlobalDeviceDisplay9p7Inch), @264],
                                        @[@3, @6]: @[@(NSGlobalDeviceModeliPad4), @"iPad 4", @(NSGlobalDeviceDisplay9p7Inch), @264],
                                        
                                        // Air
                                        @[@4, @1]: @[@(NSGlobalDeviceModeliPadAir1), @"iPad Air 1", @(NSGlobalDeviceDisplay9p7Inch), @264],
                                        @[@4, @2]: @[@(NSGlobalDeviceModeliPadAir1), @"iPad Air 1", @(NSGlobalDeviceDisplay9p7Inch), @264],
                                        @[@4, @3]: @[@(NSGlobalDeviceModeliPadAir1), @"iPad Air 1", @(NSGlobalDeviceDisplay9p7Inch), @264],
                                        
                                        // Mini 2
                                        @[@4, @4]: @[@(NSGlobalDeviceModeliPadMini2), @"iPad Mini 2", @(NSGlobalDeviceDisplay7p9Inch), @326],
                                        @[@4, @5]: @[@(NSGlobalDeviceModeliPadMini2), @"iPad Mini 2", @(NSGlobalDeviceDisplay7p9Inch), @326],
                                        @[@4, @6]: @[@(NSGlobalDeviceModeliPadMini2), @"iPad Mini 2", @(NSGlobalDeviceDisplay7p9Inch), @326],
                                        
                                        // Mini 3
                                        @[@4, @7]: @[@(NSGlobalDeviceModeliPadMini3), @"iPad Mini 3", @(NSGlobalDeviceDisplay7p9Inch), @326],
                                        @[@4, @8]: @[@(NSGlobalDeviceModeliPadMini3), @"iPad Mini 3", @(NSGlobalDeviceDisplay7p9Inch), @326],
                                        @[@4, @9]: @[@(NSGlobalDeviceModeliPadMini3), @"iPad Mini 3", @(NSGlobalDeviceDisplay7p9Inch), @326],
                                        
                                        // Mini 4
                                        @[@5, @1]: @[@(NSGlobalDeviceModeliPadMini4), @"iPad Mini 4", @(NSGlobalDeviceDisplay7p9Inch), @326],
                                        @[@5, @2]: @[@(NSGlobalDeviceModeliPadMini4), @"iPad Mini 4", @(NSGlobalDeviceDisplay7p9Inch), @326],
                                        
                                        // Air 2
                                        @[@5, @3]: @[@(NSGlobalDeviceModeliPadAir2), @"iPad Air 2", @(NSGlobalDeviceDisplay9p7Inch), @264],
                                        @[@5, @4]: @[@(NSGlobalDeviceModeliPadAir2), @"iPad Air 2", @(NSGlobalDeviceDisplay9p7Inch), @264],
                                        
                                        // Pro 12.9-inch
                                        @[@6, @7]: @[@(NSGlobalDeviceModeliPadPro12p9Inch), @"iPad Pro 12.9-inch", @(NSGlobalDeviceDisplay12p9Inch), @264],
                                        @[@6, @8]: @[@(NSGlobalDeviceModeliPadPro12p9Inch), @"iPad Pro 12.9-inch", @(NSGlobalDeviceDisplay12p9Inch), @264],
                                        
                                        // Pro 9.7-inch
                                        @[@6, @3]: @[@(NSGlobalDeviceModeliPadPro9p7Inch), @"iPad Pro 9.7-inch", @(NSGlobalDeviceDisplay9p7Inch), @264],
                                        @[@6, @4]: @[@(NSGlobalDeviceModeliPadPro9p7Inch), @"iPad Pro 9.7-inch", @(NSGlobalDeviceDisplay9p7Inch), @264],
                                        
                                        // iPad 5th Gen, 2017
                                        @[@6, @11]: @[@(NSGlobalDeviceModeliPad5), @"iPad 2017",
                                                      @(NSGlobalDeviceDisplay9p7Inch), @264],
                                        @[@6, @12]: @[@(NSGlobalDeviceModeliPad5), @"iPad 2017",
                                                      @(NSGlobalDeviceDisplay9p7Inch), @264],
                                        },
                                    @"iPod": @{
                                        // 1st Gen
                                        @[@1, @1]: @[@(NSGlobalDeviceModeliPod1), @"iPod Touch 1", @(NSGlobalDeviceDisplay3p5Inch), @163],
                                        
                                        // 2nd Gen
                                        @[@2, @1]: @[@(NSGlobalDeviceModeliPod2), @"iPod Touch 2", @(NSGlobalDeviceDisplay3p5Inch), @163],
                                        
                                        // 3rd Gen
                                        @[@3, @1]: @[@(NSGlobalDeviceModeliPod3), @"iPod Touch 3", @(NSGlobalDeviceDisplay3p5Inch), @163],
                                        
                                        // 4th Gen
                                        @[@4, @1]: @[@(NSGlobalDeviceModeliPod4), @"iPod Touch 4", @(NSGlobalDeviceDisplay3p5Inch), @326],
                                        
                                        // 5th Gen
                                        @[@5, @1]: @[@(NSGlobalDeviceModeliPod5), @"iPod Touch 5", @(NSGlobalDeviceDisplay4Inch), @326],
                                        
                                        // 6th Gen
                                        @[@7, @1]: @[@(NSGlobalDeviceModeliPod6), @"iPod Touch 6", @(NSGlobalDeviceDisplay4Inch), @326],
                                        },
                                    };
    
    for (NSString *familyString in familyManifest) {
      if ([deviceInfoString hasPrefix:familyString]) {
        family = [familyManifest[familyString] integerValue];
        
        NSArray *modelNuances = modelManifest[familyString][@[@(deviceVersion.major), @(deviceVersion.minor)]];
        if (modelNuances) {
          model = [modelNuances[0] integerValue];
          modelString = modelNuances[1];
          display = [modelNuances[2] integerValue];
          pixelsPerInch = [modelNuances[3] doubleValue];
        }
        
        break;
      }
    }
  }
  
  return @[@(family), @(model), modelString, @(display), @(pixelsPerInch)];
}

+ (NSString *)_sysctlStringForKey:(NSString *)key {
  const char *keyCString = [key UTF8String];
  NSString *answer = @"";
  
  size_t length;
  sysctlbyname(keyCString, NULL, &length, NULL, 0);
  if (length) {
    char *answerCString = malloc(length * sizeof(char));
    sysctlbyname(keyCString, answerCString, &length, NULL, 0);
    answer = [NSString stringWithCString:answerCString encoding:NSUTF8StringEncoding];
    free(answerCString);
  }
  
  return answer;
}

+ (CGFloat)_sysctlCGFloatForKey:(NSString *)key {
  const char *keyCString = [key UTF8String];
  CGFloat answerFloat = 0;
  
  size_t length = 0;
  sysctlbyname(keyCString, NULL, &length, NULL, 0);
  if (length) {
    char *answerRaw = malloc(length * sizeof(char));
    sysctlbyname(keyCString, answerRaw, &length, NULL, 0);
    switch (length) {
      case 8: {
        answerFloat = (CGFloat)*(int64_t *)answerRaw;
      } break;
        
      case 4: {
        answerFloat = (CGFloat)*(int32_t *)answerRaw;
      } break;
        
      default: {
        answerFloat = 0.;
      } break;
    }
    free(answerRaw);
  }
  
  return answerFloat;
}


+ (NSGlobalCPUInfo)_cpuInfo {
  return NSGlobalCPUInfoMake(
                       [self _sysctlCGFloatForKey:kHardwareCPUFrequencyKey] / 1000000000., //giga
                       (NSUInteger)[self _sysctlCGFloatForKey:kHardwareNumberOfCoresKey],
                       [self _sysctlCGFloatForKey:kHardwareL2CacheSizeKey] / 1024          //kibi
                       );
}

+ (CGFloat)_physicalMemory {
  return [[NSProcessInfo processInfo] physicalMemory] / 1073741824.;      //gibi
}

@end
