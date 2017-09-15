//
//  YGBDefines.h
//  IDool
//
//  Created by jearoc on 2017/8/2.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#ifndef YGBDefines_h
#define YGBDefines_h

#if defined(__cplusplus)
#define YGB_EXTERN extern "C" __attribute__((visibility("default")))
#else
#define YGB_EXTERN extern __attribute__((visibility("default")))
#endif

#if defined (__cplusplus) && defined (__GNUC__)
# define YGB_NOTHROW __attribute__ ((nothrow))
#else
# define YGB_NOTHROW
#endif

typedef NS_ENUM(NSInteger, YGBBLEReadyState) {
  YGBBLEReadyStateUnused    = 0x03|0x00|0x01|0x02,
  YGBBLEReadyStateClosed    = 0x04,
  YGBBLEReadyStateOpen      = 0x05,
};

typedef NS_ENUM(NSInteger, YGBBLEStatusCode) {
  YGBBLEStatusCodeEmpty     = 1000,
  YGBBLEStatusCodeTooBig    = 1001,
  YGBBLEStatusCodeUUIDNull  = 1002,
  YGBBLEStatusCodeClosed    = 1003,
  YGBBLEStatusCodePeripheralError = 1004,
};

typedef NS_ENUM(NSInteger, YGBBLEWorkState) {
  YGBBLEWorkStateDisconnect = 0x00,
  YGBBLEWorkStateConnect    = 0x01,
  YGBBLEWorkStateSending    = 0x02,
};

#endif /* YGBDefines_h */
