//
//  YGBError.h
//  IDool
//
//  Created by jearoc on 2017/8/2.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YGB_DEBUG_LOG_ENABLED

NS_ASSUME_NONNULL_BEGIN

extern void YGBErrorLog(NSString *format, ...);
extern void YGBDebugLog(NSString *format, ...);

extern NSError *YGBErrorWithDomainCodeDescription(NSString *domain, NSInteger code, NSString *description);
extern NSError *YGBErrorWithCodeDescription(NSInteger code, NSString *description);
extern NSError *YGBErrorWithCodeDescriptionUnderlyingError(NSInteger code, NSString *description, NSError *underlyingError);

NS_ASSUME_NONNULL_END
