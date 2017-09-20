//
//  YGBBLESocketDelegate.h
//  IDool
//
//  Created by jearoc on 2017/8/3.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "YGBDefines.h"
@class YGBBLESocket;
@class CBPeripheral,CBService,CBCharacteristic;
@protocol YGBBLESocketDelegate <NSObject>
@optional

/**
 当前连接的外设信号改变回调

 @param peripheral 当前连接的外设
 @param RSSI 信号值
 @param error error
 */
- (void)didUpdateRSSI:(CBPeripheral *)peripheral
                 RSSI:(NSNumber *)RSSI
                error:(NSError *)error;

/**
 蓝牙状态改变，蓝牙断开连接的同时当前连接的外设也会断开连接

 @param state 蓝牙状态
 @param socket socket
 */
- (void)readyStateUpdate:(YGBBLEReadyState)state
                  socket:(YGBBLESocket *)socket;

/**
 连接上外设时的回调

 @param peripheral 当前连接的外设
 */
- (void)connectSucceed:(CBPeripheral *)peripheral;

/**
 外设连接失败的回调

 @param peripheral 连接失败的外设
 @param error error
 */
- (void)connectFailed:(CBPeripheral *)peripheral
                error:(NSError *)error;

/**
 外设断开连接时的回调

 @param peripheral 失去连接的外设
 @param error error
 */
- (void)disconnect:(CBPeripheral *)peripheral
             error:(NSError *)error;

/**
 成功发现外设特征的回调
 
 @param characteristics 特征集合
 @param peripheral 当前连接的外设
 @param service service
 */
- (void)discoverCharacteristicsSucceed:(NSDictionary *)characteristics
                            peripheral:(CBPeripheral *)peripheral
                               service:(CBService *)service;

/**
 发现外设特征失败的回调
 
 @param peripheral 当前连接的外设
 @param service service
 @param error error
 */
- (void)discoverCharacteristicsFailed:(CBPeripheral *)peripheral
                              service:(CBService *)service
                                error:(NSError *)error;

/**
 成功接收到数据的回调

 @param characteristic 特征
 @param peripheral 外设
 @param value value
 */
- (void)receiveDataSucceed:(CBCharacteristic *)characteristic
                peripheral:(CBPeripheral *)peripheral
                     value:(NSData *)value;

/**
 接收数据失败的回调

 @param characteristic 特征
 @param peripheral 外设
 @param error error
 */
- (void)receiveDataFailed:(CBCharacteristic *)characteristic
                peripheral:(CBPeripheral *)peripheral
                     error:(NSError *)error;

/**
 请求成功

 @param data data
 @param peripheral 当前连接的外设
 */
- (void)requestSucceed:(NSData *)data
            peripheral:(CBPeripheral *)peripheral;

/**
 请求失败

 @param error error
 @param peripheral 当前连接的外设
 */
- (void)requestFailed:(NSError *)error
           peripheral:(CBPeripheral *)peripheral;


@end
