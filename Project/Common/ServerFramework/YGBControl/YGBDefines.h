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

typedef NS_ENUM(NSInteger, YGBErrorCode) {
  YGBErrorCodeDataEmpty      = 1000,
  YGBErrorCodeDataTooBig     = 1001,
  YGBErrorCodeUUIDNill       = 1002,
  YGBErrorCodeBLEClosed      = 1003,
  YGBErrorCodePeripheralNill = 1004,
  YGBErrorCodePeripheralDisconnect = 1005,
  YGBErrorCodePeripheralBusy = 1006,
  YGBErrorCodeCharacteristicNill = 1007,
};

typedef NS_ENUM(NSInteger, YGBBLEWorkState) {
  YGBBLEWorkStateDisconnect = 0x00,
  YGBBLEWorkStateConnect    = 0x01,
  YGBBLEWorkStateSending    = 0x02,
};

#endif /* YGBDefines_h */
