//
//  NSGlobalDeviceInfoInterface.h
//  Project
//
//  Created by jearoc on 2017/8/31.
//  Copyright © 2017年 jearoc. All rights reserved.
//

@class NSGlobalDeviceInfo;

@protocol NSGlobalDeviceInfoInterface <NSObject>
@required

+ (NSGlobalDeviceInfo *)deviceInfo;

@end
