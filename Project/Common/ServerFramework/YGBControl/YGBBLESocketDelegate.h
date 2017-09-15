//
//  YGBBLESocketDelegate.h
//  IDool
//
//  Created by jearoc on 2017/8/3.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "YGBDefines.h"
@class YGBBLESocket;
@class CBPeripheral;
@protocol YGBBLESocketDelegate <NSObject>

@optional
- (void)didUpdateRSSI:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI error:(NSError *)error;

- (void)readyStateUpdate:(YGBBLEReadyState)state socket:(YGBBLESocket *)socket;
- (void)onConnect:(CBPeripheral *)peripheral;
- (void)onDisconnect:(CBPeripheral *)peripheral error:(NSError *)error;

@end
