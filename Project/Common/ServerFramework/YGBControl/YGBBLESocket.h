//
//  YGBBLESocket.h
//  IDool
//
//  Created by jearoc on 2017/8/2.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGBDefines.h"
#import "YGBBLESocketDelegate.h"
#import "YGBPacket.h"

NS_ASSUME_NONNULL_BEGIN

/**********************************************************************************
 *
 * (1) scan peripherals
 * (2) connect peripheral
 * (3) find peripheral servers
 * (4) read data,noti
 * (5) send data
 *
 **********************************************************************************/

@class YGBBLESocket;

@protocol YGBBLESocketDelegate;

extern NSString *const YGBBLESocketErrorDomain;
extern NSString *const YGBBLESocketErrorKey;

@interface YGBBLESocket : NSObject

@property (nonatomic, weak) id <YGBBLESocketDelegate> delegate;
@property (nullable, nonatomic, strong) dispatch_queue_t delegateDispatchQueue;
@property (nullable, nonatomic, strong) NSOperationQueue *delegateOperationQueue;

@property (atomic, assign, readonly) YGBBLEReadyState readyState;
@property (atomic, assign, readonly) YGBBLEWorkState workState;

@property (nullable, nonatomic, strong, readonly) NSString *UUID;
@property (nullable, nonatomic, strong, readonly) NSString *channel;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithUUID:(NSString *)UUID channel:(NSString *)channel;

- (void)sendData:(nullable NSData *)data characteristic:(CBCharacteristic *)characteristic error:(NSError **)error;
- (void)sendDataNoCopy:(nullable NSData *)data characteristic:(CBCharacteristic *)characteristic error:(NSError **)error;
- (void)sendData:(nullable NSData *)data characteristicUUID:(NSString *)UUID error:(NSError **)error;
- (void)sendDataNoCopy:(nullable NSData *)data characteristicUUID:(NSString *)UUID error:(NSError **)error;

- (void)connect;
- (void)disConnect;

@end

NS_ASSUME_NONNULL_END
