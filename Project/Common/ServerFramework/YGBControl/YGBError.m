//
//  YGBError.m
//  IDool
//
//  Created by jearoc on 2017/8/2.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "YGBError.h"
#import "YGBBLESocket.h"

NS_ASSUME_NONNULL_BEGIN

extern void YGBErrorLog(NSString *format, ...)
{
  __block va_list arg_list;
  va_start (arg_list, format);
  
  NSString *formattedString = [[NSString alloc] initWithFormat:format arguments:arg_list];
  
  va_end(arg_list);
  
  NSLog(@"[YGBBLESocket] %@", formattedString);
}

extern void YGBDebugLog(NSString *format, ...)
{
#ifdef YGB_DEBUG_LOG_ENABLED
  YGBErrorLog(format);
#endif
}

NSError *YGBErrorWithDomainCodeDescription(NSString *domain, NSInteger code, NSString *description)
{
  return [NSError errorWithDomain:domain code:code userInfo:@{ NSLocalizedDescriptionKey: description }];
}

NSError *YGBErrorWithCodeDescription(NSInteger code, NSString *description)
{
  return YGBErrorWithDomainCodeDescription(YGBBLESocketErrorDomain, code, description);
}

NSError *YGBErrorWithCodeDescriptionUnderlyingError(NSInteger code, NSString *description, NSError *underlyingError)
{
  return [NSError errorWithDomain:YGBBLESocketErrorDomain
                             code:code
                         userInfo:@{ NSLocalizedDescriptionKey: description,
                                     NSUnderlyingErrorKey: underlyingError }];
}


NS_ASSUME_NONNULL_END
