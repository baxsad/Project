//
//  YGBBLESocket.m
//  IDool
//
//  Created by jearoc on 2017/8/2.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#include <pthread.h>
#import "YGBBLESocket.h"
#import "YGBError.h"

NSString *const YGBBLESocketErrorDomain = @"YGBBLESocketErrorDomain";
NSString *const YGBBLESocketErrorKey = @"YGBBLESocketErrorKey";

#define Lock() pthread_mutex_lock(&(self -> _lock))
#define Unlock() pthread_mutex_unlock(&(self -> _lock))
#define YGB_CHECK_CURRENT_PERIPHERAL if(![peripheral.identifier.UUIDString isEqualToString:self.UUID])return;

static CBPeripheral *willConnectingPeripheral;

@interface YGBBLESocket ()
@property (nullable, nonatomic, strong, readwrite) NSString *UUID;
@property (nullable, nonatomic, strong, readwrite) NSString *channel;
@end

@implementation YGBBLESocket {
  dispatch_queue_t _workQueue;
  BabyBluetooth *_littleBoy;
  CBPeripheral *_peripheral;
  NSNumber *_RSSI;
  
  NSMutableDictionary *_services;
  NSMutableDictionary *_characteristics;
  pthread_mutex_t _lock;
}

- (instancetype)initWithUUID:(NSString *)UUID channel:(nonnull NSString *)channel
{
  if (self = [super init]) {
    assert(UUID);
    _UUID       = UUID;
    _channel    = channel == nil || channel.length == 0 ? @"YGB.BANGBANGBNAG.CN" : channel;
    _workQueue  = dispatch_queue_create((__bridge void *)self, DISPATCH_QUEUE_SERIAL);
    _littleBoy  = [BabyBluetooth shareBabyBluetooth];
    _services   = [NSMutableDictionary dictionary];
    _characteristics = [NSMutableDictionary dictionary];
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    
    [_littleBoy setBabyOptionsAtChannel:_channel
          scanForPeripheralsWithOptions:scanForPeripheralsWithOptions
           connectPeripheralWithOptions:connectOptions
         scanForPeripheralsWithServices:nil
                   discoverWithServices:nil
            discoverWithCharacteristics:nil];
    [self _addObserver];
  }
  
  return self;
}

- (void)_addObserver
{
  @weakify(self);
  
  // 蓝牙状态改变
  [_littleBoy setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
    @strongify(self);
    if (self.readyState != CBManagerStatePoweredOn) {
      self -> _peripheral = nil;
      willConnectingPeripheral = nil;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(readyStateUpdate:socket:)]) {
      [self.delegate readyStateUpdate:self.readyState socket:self];
    }
  }];
  
  // 当前连接设备的信号变化
  [[[NSNotificationCenter defaultCenter] rac_addObserverForName:BabyNotificationAtDidReadRSSI
                                                         object:nil] subscribeNext:^(NSDictionary *object) {
    @strongify(self);
    CBPeripheral *peripheral = object[@"peripheral"];
    NSNumber *RSSI = object[@"RSSI"];
    NSError *error = object[@"error"];
    if ([object[@"error"] isKindOfClass:[NSError class]]) {
      return;
    }
    if (peripheral == nil) {
      return;
    }
    YGB_CHECK_CURRENT_PERIPHERAL
    if (self -> _RSSI != nil || [self -> _RSSI integerValue] == [RSSI integerValue]) {
      self -> _RSSI = RSSI;
      return ;
    }
    self -> _RSSI = RSSI;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didUpdateRSSI:RSSI:error:)]) {
      [self.delegate didUpdateRSSI:self -> _peripheral RSSI:RSSI error:error];
    }
  }];
  
  // 扫描到外设时的回调
  [_littleBoy setBlockOnDiscoverToPeripheralsAtChannel:_channel
                                                 block:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
                                                   @strongify(self);
                                                   NSLog(@"%@",peripheral);
                                                   YGB_CHECK_CURRENT_PERIPHERAL
                                                   if (willConnectingPeripheral == nil) {
                                                     willConnectingPeripheral = peripheral;
                                                     if (self.delegate && [self.delegate respondsToSelector:@selector(findPeripheral:socket:RSSI:)]) {
                                                       [self.delegate findPeripheral:peripheral socket:self RSSI:RSSI];
                                                     }
                                                   }
                                                 }];
  
  // 扫描过滤
  [_littleBoy setFilterOnDiscoverPeripheralsAtChannel:_channel
                                               filter:^BOOL(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
                                                 @strongify(self);
                                                 return [peripheral.identifier.UUIDString isEqualToString:self.UUID];
                                               }];
  
  // 连接过滤
  [_littleBoy setFilterOnConnectToPeripheralsAtChannel:_channel
                                                filter:^BOOL(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
                                                  @strongify(self);
                                                  return [peripheral.identifier.UUIDString isEqualToString:self.UUID];
                                                }];
  
  // 成功连接到外设时的回调
  [_littleBoy setBlockOnConnectedAtChannel:_channel
                                     block:^(CBCentralManager *central, CBPeripheral *peripheral) {
                                       @strongify(self);
                                       YGB_CHECK_CURRENT_PERIPHERAL
                                       self -> _peripheral = peripheral;
                                       self -> _workState = YGBBLEWorkStateConnect;
                                       [self -> _littleBoy cancelScan];
                                       if (self.delegate && [self.delegate respondsToSelector:@selector(connectSucceed:)]) {
                                         [self.delegate connectSucceed:self -> _peripheral];
                                       }
                                     }];
  
  // 连接外设失败的回调
  [_littleBoy setBlockOnFailToConnectAtChannel:self.channel block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
    @strongify(self);
    YGB_CHECK_CURRENT_PERIPHERAL
    self -> _peripheral = nil;
    self -> _workState = YGBBLEWorkStateDisconnect;
    [self -> _littleBoy cancelScan];
    if (self.delegate && [self.delegate respondsToSelector:@selector(connectFailed:error:)]) {
      [self.delegate connectFailed:self -> _peripheral error:error];
    }
  }];
  
  // 外设失去连接时的回调
  [_littleBoy setBlockOnDisconnectAtChannel:self.channel block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
    @strongify(self);
    YGB_CHECK_CURRENT_PERIPHERAL
    self -> _peripheral = nil;
    self -> _workState = YGBBLEWorkStateDisconnect;
    [self -> _littleBoy cancelScan];
    if (self.delegate && [self.delegate respondsToSelector:@selector(disconnect:error:)]) {
      [self.delegate disconnect:self -> _peripheral error:error];
    }
  }];
  
  // 心跳
  BabyRhythm *rhythm = [[BabyRhythm alloc] init];
  [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
    @strongify(self);
    if (self -> _peripheral) [self -> _peripheral readRSSI];
  }];
  [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {}];
  [rhythm beats];
  
  // 发现外设服务时的回调
  [_littleBoy setBlockOnDiscoverServicesAtChannel:_channel block:^(CBPeripheral *peripheral, NSError *error) {
    @strongify(self);
    YGB_CHECK_CURRENT_PERIPHERAL
    for (CBService *s in peripheral.services) {
      Lock();
      CBService *service = [self -> _services objectForKey:s.UUID.UUIDString];
      Unlock();
      if (service == nil && s.UUID.UUIDString.length > 0) {
        Lock();
        [self -> _services setObject:s forKey:s.UUID.UUIDString];
        Unlock();
      }
    }
  }];
  
  // 发现外设服务特征的回调
  [_littleBoy setBlockOnDiscoverCharacteristicsAtChannel:_channel block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
    @strongify(self);
    YGB_CHECK_CURRENT_PERIPHERAL
    if (error) {
      if (self.delegate && [self.delegate respondsToSelector:@selector(discoverCharacteristicsFailed:service:error:)]) {
        [self.delegate discoverCharacteristicsFailed:peripheral service:service error:error];
      }
      return;
    }
    for (CBCharacteristic *c in service.characteristics) {
      Lock();
      CBCharacteristic *characteristic = [self -> _characteristics objectForKey:c.UUID.UUIDString];
      Unlock();
      if (characteristic == nil && c.UUID.UUIDString.length > 0) {
        Lock();
        [self -> _characteristics setObject:c forKey:c.UUID.UUIDString];
        Unlock();
      }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(discoverCharacteristicsSucceed:peripheral:service:)]) {
      [self.delegate discoverCharacteristicsSucceed:self -> _characteristics peripheral:peripheral service:service];
    }
  }];
  
  // 读取特征值的回调
  [_littleBoy setBlockOnReadValueForCharacteristicAtChannel:_channel block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
    @strongify(self);
    YGB_CHECK_CURRENT_PERIPHERAL
    if (error) {
      if (self.delegate && [self.delegate respondsToSelector:@selector(receiveDataFailed:peripheral:error:)]) {
        [self.delegate receiveDataFailed:characteristics peripheral:peripheral error:error];
      }
      return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(receiveDataSucceed:peripheral:value:)]) {
      [self.delegate receiveDataSucceed:characteristics peripheral:peripheral value:characteristics.value];
    }

  }];
  
  // 写值成功的回调
  [_littleBoy setBlockOnDidWriteValueForCharacteristicAtChannel:_channel
                                                          block:^(CBCharacteristic *characteristic, NSError *error) {
                                                            @strongify(self);
                                                            if (self.delegate && [self.delegate respondsToSelector:@selector(characteristicDidWritValue:peripheral:characteristic:)]) {
                                                              [self.delegate characteristicDidWritValue:characteristic.value
                                                                                             peripheral:self -> _peripheral
                                                                                         characteristic:characteristic];
                                                            }
                                                          }];
  
  /**
  // 设置发现特征的描述的回调
  [_littleBoy setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:_channel block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
    @strongify(self);
    YGB_CHECK_CURRENT_PERIPHERAL
    NSLog(@"发现服务 %@ 的特征 %@ 的描述符 %@",characteristic.service.UUID,characteristic.UUID,characteristic.descriptors);
  }];
  
  // 读取描述的回调
  [_littleBoy setBlockOnReadValueForDescriptorsAtChannel:_channel block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
    @strongify(self);
    YGB_CHECK_CURRENT_PERIPHERAL
    NSLog(@"读取服务 %@ 的特征 %@ 的描述符 %@ 的值 %@",descriptor.characteristic.service.UUID,descriptor.characteristic.UUID, descriptor.UUID,descriptor.value);
  }];
  */
  
}

- (void)sendData:(nullable NSData *)data characteristicUUID:(NSString *)UUID error:(NSError **)error
{
  return [self sendData:data characteristic:UUID==nil||UUID.length<=0 ? nil : _characteristics[UUID] error:error];
}

- (void)sendDataNoCopy:(nullable NSData *)data characteristicUUID:(NSString *)UUID error:(NSError **)error
{
  return [self sendDataNoCopy:data characteristic:UUID==nil||UUID.length<=0 ? nil : _characteristics[UUID] error:error];
}

- (void)sendData:(nullable NSData *)data characteristic:(CBCharacteristic *)characteristic error:(NSError **)error
{
  if (characteristic == nil) {
    NSString *message = @"特征不能为空";
    if (error) {
      *error = YGBErrorWithCodeDescription(YGBErrorCodeCharacteristicNill, message);
    }
    [self errorWithCode:YGBErrorCodeCharacteristicNill reason:message];
    YGBDebugLog(message);
    return;
  }
  
  if (data == nil) {
    NSString *message = @"数据包不能为空";
    if (error) {
      *error = YGBErrorWithCodeDescription(YGBErrorCodeDataEmpty, message);
    }
    [self errorWithCode:YGBErrorCodeDataEmpty reason:message];
    YGBDebugLog(message);
    return;
  }
  data = [data copy];
  return [self sendDataNoCopy:data characteristic:characteristic error:error];
}

- (void)sendDataNoCopy:(nullable NSData *)data characteristic:(CBCharacteristic *)characteristic error:(NSError **)error;
{
  if (characteristic == nil) {
    NSString *message = @"特征不能为空";
    if (error) {
      *error = YGBErrorWithCodeDescription(YGBErrorCodeCharacteristicNill, message);
    }
    [self errorWithCode:YGBErrorCodeCharacteristicNill reason:message];
    YGBDebugLog(message);
    return;
  }
  
  if (data == nil) {
    NSString *message = @"数据包不能为空";
    if (error) {
      *error = YGBErrorWithCodeDescription(YGBErrorCodeDataEmpty, message);
    }
    [self errorWithCode:YGBErrorCodeDataEmpty reason:message];
    YGBDebugLog(message);
    return;
  }
  
  if (self.readyState != YGBBLEReadyStateOpen) {
    NSString *message = @"蓝牙未打开";
    if (error) {
      *error = YGBErrorWithCodeDescription(YGBErrorCodeBLEClosed, message);
    }
    [self errorWithCode:YGBErrorCodeBLEClosed reason:message];
    YGBDebugLog(message);
    return;
  }
  
  if (self.workState == YGBBLEWorkStateDisconnect) {
    NSString *message = @"外设未连接";
    if (error) {
      *error = YGBErrorWithCodeDescription(YGBErrorCodePeripheralDisconnect, message);
    }
    [self errorWithCode:YGBErrorCodePeripheralDisconnect reason:message];
    YGBDebugLog(message);
    return;
  }
  
  if (self.workState == YGBBLEWorkStateSending) {
    NSString *message = @"当前有数据正在发送中";
    if (error) {
      *error = YGBErrorWithCodeDescription(YGBErrorCodePeripheralBusy, message);
    }
    [self errorWithCode:YGBErrorCodePeripheralBusy reason:message];
    YGBDebugLog(message);
    return;
  }
  
  if (_peripheral == nil) {
    NSString *message = @"当前没有连接的外设";
    if (error) {
      *error = YGBErrorWithCodeDescription(YGBErrorCodePeripheralNill, message);
    }
    [self errorWithCode:YGBErrorCodePeripheralNill reason:message];
    YGBDebugLog(message);
    return;
  }
  
  dispatch_async(_workQueue, ^{
    [self _sendData:data characteristic:characteristic];
  });
}

- (void)_sendData:(NSData *)data characteristic:(CBCharacteristic *)characteristic
{
  [self assertOnWorkQueue];
  
  if (!data) {
    return;
  }
  
  size_t dataLength = data.length;
  
  if (dataLength > 20) {
    [self errorWithCode:YGBErrorCodeDataTooBig reason:@"数据包过大"];
    return;
  }else if (dataLength == 0){
    [self errorWithCode:YGBErrorCodeDataEmpty reason:@"数据包不能为空"];
    return;
  }
  
  if (_peripheral == nil) {
    [self errorWithCode:YGBErrorCodePeripheralNill reason:@"This peripheral is not BLE current Peripheral"];
    return;
  }
  
  [_peripheral writeValue:data
        forCharacteristic:characteristic
                     type:CBCharacteristicWriteWithResponse];
  
}

- (void)connect
{
  if (self.readyState != YGBBLEReadyStateOpen) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(connectFailed:error:)]) {
      [self.delegate connectFailed:nil error:YGBErrorWithCodeDescription(YGBErrorCodeBLEClosed, @"蓝牙处于关闭状态")];
    }
    return;
  }
  
  if (self.UUID == nil && self.UUID.length == 0) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(connectFailed:error:)]) {
      [self.delegate connectFailed:nil error:YGBErrorWithCodeDescription(YGBErrorCodeUUIDNill, @"UUID 不能为空")];
    }
    return;
  }
  
  if (willConnectingPeripheral == nil) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(connectFailed:error:)]) {
      [self.delegate connectFailed:nil error:YGBErrorWithCodeDescription(YGBErrorCodePeripheralNill, @"没有可供连接的外设")];
    }
    return;
  }
  
  self -> _littleBoy
  .having(willConnectingPeripheral)
  .and
  .channel(self -> _channel)
  .then
  .connectToPeripherals()
  .discoverServices()
  .discoverCharacteristics()
  .readValueForCharacteristic()
  .discoverDescriptorsForCharacteristic()
  .readValueForDescriptors()
  .begin();
  
}

- (void)disConnect
{
  [_littleBoy cancelScan];
  [_littleBoy cancelAllPeripheralsConnection];
}

- (void)find
{
  if (self.readyState != YGBBLEReadyStateOpen) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(connectFailed:error:)]) {
      [self.delegate connectFailed:nil error:YGBErrorWithCodeDescription(YGBErrorCodeBLEClosed, @"蓝牙处于关闭状态")];
    }
    return;
  }
  
  if (self.UUID == nil && self.UUID.length == 0) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(connectFailed:error:)]) {
      [self.delegate connectFailed:nil error:YGBErrorWithCodeDescription(YGBErrorCodeUUIDNill, @"UUID 不能为空")];
    }
    return;
  }
  
  willConnectingPeripheral = nil;
  [_littleBoy cancelScan];
  [_littleBoy cancelAllPeripheralsConnection];
  _littleBoy.channel(_channel).scanForPeripherals().begin();
}

- (void)stopFind
{
  [_littleBoy cancelScan];
}

- (void)addAutoConnectPeripheral:(CBPeripheral *)peripheral
{
  [_littleBoy AutoReconnect:peripheral];
}

- (void)removeAutoConnectPeripheral:(CBPeripheral *)peripheral
{
  [_littleBoy AutoReconnectCancel:peripheral];
}

#pragma mark - 

- (void)errorWithCode:(NSInteger)code reason:(NSString *)reason
{
  
}

#pragma mark -

- (void)dealloc
{
  [self disConnect];
}

- (void)assertOnWorkQueue;
{
  //assert(dispatch_get_specific((__bridge void *)self) == (__bridge void *)_workQueue);
}

#pragma mark - getter

- (YGBBLEReadyState)readyState
{
  if (_littleBoy.centralManager.state == CBManagerStatePoweredOn) {
    return YGBBLEReadyStateOpen;
  }else if(_littleBoy.centralManager.state == CBManagerStatePoweredOff){
    return YGBBLEReadyStateClosed;
  }else{
    return YGBBLEReadyStateUnused;
  }
}

@end
