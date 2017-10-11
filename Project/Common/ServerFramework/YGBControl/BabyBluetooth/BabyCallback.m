/*
 BabyBluetooth
 简单易用的蓝牙ble库，基于CoreBluetooth 作者：刘彦玮
 https://github.com/coolnameismy/BabyBluetooth
 */

//  Created by 刘彦玮 on 15/9/2.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import "BabyCallback.h"

@implementation BabyCallback


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setFilterOnDiscoverPeripherals:^BOOL(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
            if (![peripheral.name isEqualToString:@""]) {
                return YES;
            }
            return NO;
        }];
        [self setFilterOnconnectToPeripherals:^BOOL(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
            if (![peripheral.name isEqualToString:@""]) {
                return YES;
            }
            return NO;
        }];
    }
    return self;
}
@end
