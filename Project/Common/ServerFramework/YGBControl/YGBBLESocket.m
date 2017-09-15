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
#import "BabyBluetooth.h"

NSString *const YGBBLESocketErrorDomain = @"YGBBLESocketErrorDomain";
NSString *const YGBBLESocketErrorKey = @"YGBBLESocketErrorKey";

#define Lock() pthread_mutex_lock(&(self -> _lock))
#define Unlock() pthread_mutex_unlock(&(self -> _lock))

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
  pthread_mutex_t _lock;
}

- (instancetype)initWithUUID:(NSString *)UUID channel:(nonnull NSString *)channel
{
  if (self = [super init]) {
    assert(UUID);
    _UUID       = UUID;
    _channel    = channel == nil || channel.length == 0 ? @"YGB.BANGBANGBNAG.CN" : channel;
    _workQueue  = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    _littleBoy  = [BabyBluetooth shareBabyBluetooth];
    _services   = [NSMutableDictionary dictionary];
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
  }
  
  return self;
}

- (void)_addObserver
{
  @weakify(self);
  
  // Bluetooth readyState update
  [_littleBoy setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
    @strongify(self);
    if (central.state != CBManagerStatePoweredOn) {
      self -> _peripheral = nil;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(readyStateUpdate:socket:)]) {
      [self.delegate readyStateUpdate:self.readyState socket:self];
    }
  }];
  
  // Bluetooth RSSI update
  [_littleBoy setBlockOnDidReadRSSIAtChannel:_channel block:^(NSNumber *RSSI, NSError *error) {
    @strongify(self);
    if (self -> _RSSI != nil || [self -> _RSSI integerValue] == [RSSI integerValue]) {
      self -> _RSSI = RSSI;
      return ;
    }
    self -> _RSSI = RSSI;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didUpdateRSSI:RSSI:error:)]) {
      [self.delegate didUpdateRSSI:self -> _peripheral RSSI:RSSI error:error];
    }
  }];
  
  // Bluetooth discover Peripherals
  [_littleBoy setBlockOnDiscoverToPeripheralsAtChannel:_channel
                                                 block:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
                                                   @strongify(self);
                                                   if ([peripheral.identifier.UUIDString isEqualToString:self.UUID]) {
                                                     self -> _littleBoy
                                                     .having(peripheral)
                                                     .and
                                                     .channel(self -> _channel)
                                                     .then
                                                     .connectToPeripherals()
                                                     .discoverServices()
                                                     .begin();
                                                   }
                                                 }];
  
  // Bluetooth filter for discover Peripherals
  [_littleBoy setFilterOnDiscoverPeripheralsAtChannel:_channel
                                               filter:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
                                                 if (peripheralName.length >0) {
                                                   return YES;
                                                 }
                                                 return NO;
                                               }];
  
  // Bluetooth Connected to peripheral successed
  [_littleBoy setBlockOnConnectedAtChannel:self.channel block:^(CBCentralManager *central, CBPeripheral *peripheral) {
    @strongify(self);
    self -> _peripheral = peripheral;
    self -> _workState = YGBBLEWorkStateConnect;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onConnect:)]) {
      [self.delegate onConnect:self -> _peripheral];
    }
  }];
  
  // Bluetooth Connected to peripheral failed
  [_littleBoy setBlockOnFailToConnectAtChannel:self.channel block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
    @strongify(self);
    self -> _peripheral = nil;
    self -> _workState = YGBBLEWorkStateDisconnect;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDisconnect:error:)]) {
      [self.delegate onDisconnect:self -> _peripheral error:error];
    }
  }];
  
  // Bluetooth Disconnect for peripheral
  [_littleBoy setBlockOnDisconnectAtChannel:self.channel block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
    @strongify(self);
    self -> _peripheral = nil;
    self -> _workState = YGBBLEWorkStateDisconnect;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDisconnect:error:)]) {
      [self.delegate onDisconnect:self -> _peripheral error:error];
    }
  }];
  
  // Hert Beats
  BabyRhythm *rhythm = [[BabyRhythm alloc] init];
  [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
    @strongify(self);
    if (self -> _peripheral) [self -> _peripheral readRSSI];
  }];
  [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {}];
  [rhythm beats];
  
  // Bluetooth discover Peripheral Servers
  [_littleBoy setBlockOnDiscoverServicesAtChannel:_channel block:^(CBPeripheral *peripheral, NSError *error) {
    @strongify(self);
    if (![peripheral.identifier.UUIDString isEqualToString:self -> _peripheral.identifier.UUIDString]) return ;
    for (CBService *s in peripheral.services) {
      Lock();
      CBService *service = [self -> _services objectForKey:s.UUID.UUIDString];
      Unlock();
      if (service == nil) {
        Lock();
        [self -> _services setObject:s forKey:s.UUID.UUIDString];
        Unlock();
      }
    }
  }];
  
  /**
  //设置发现设service的Characteristics的委托
  [_littleBoy setBlockOnDiscoverCharacteristicsAtChannel:_channel block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
    NSLog(@"发现服务 %@ 的特征 %@",service.UUID,service.characteristics);
  }];
  
  //设置读取characteristics的委托
  [_littleBoy setBlockOnReadValueForCharacteristicAtChannel:_channel block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
    NSLog(@"读取服务 %@ 的特征 %@ 的值 %@",characteristics.service.UUID,characteristics.UUID,characteristics.value);
  }];
  
  //设置发现characteristics的descriptors的委托
  [_littleBoy setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:_channel block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
    NSLog(@"发现服务 %@ 的特征 %@ 的描述符 %@",characteristic.service.UUID,characteristic.UUID,characteristic.descriptors);
  }];
  
  //设置读取Descriptor的委托
  [_littleBoy setBlockOnReadValueForDescriptorsAtChannel:_channel block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
    NSLog(@"读取服务 %@ 的特征 %@ 的描述符 %@ 的值 %@",descriptor.characteristic.service.UUID,descriptor.characteristic.UUID, descriptor.UUID,descriptor.value);
  }];
   */
  
}

- (BOOL)sendData:(nullable NSData *)data error:(NSError **)error
{
  data = [data copy];
  return [self sendDataNoCopy:data error:error];
}

- (BOOL)sendDataNoCopy:(nullable NSData *)data error:(NSError **)error
{
  if (self.readyState != YGBBLEReadyStateOpen) {
    NSString *message = @"Invalid State: Cannot call `sendDataNoCopy:error:` until connection is open.";
    if (error) {
      *error = YGBErrorWithCodeDescription(2134, message);
    }
    YGBDebugLog(message);
    return NO;
  }
  
  if (self.workState == YGBBLEWorkStateDisconnect) {
    NSString *message = @"Invalid State: Cannot call `sendDataNoCopy:error:` server is disconnect.";
    if (error) {
      *error = YGBErrorWithCodeDescription(2136, message);
    }
    YGBDebugLog(message);
    return NO;
  }
  
  if (self.workState == YGBBLEWorkStateSending) {
    NSString *message = @"Invalid State: Cannot call `sendDataNoCopy:error:` data is sending.";
    if (error) {
      *error = YGBErrorWithCodeDescription(2138, message);
    }
    YGBDebugLog(message);
    return NO;
  }
  
  if (_peripheral == nil) {
    NSString *message = @"Invalid State: Cannot call `sendDataNoCopy:error:` Peripheral is nil.";
    if (error) {
      *error = YGBErrorWithCodeDescription(2140, message);
    }
    YGBDebugLog(message);
    return NO;
  }
  
  dispatch_async(_workQueue, ^{
    if (data) {
      [self _sendData:data];
    } else {
      [self _sendData:nil];
    }
  });
  return YES;
}

- (void)_sendData:(NSData *)data
{
  [self assertOnWorkQueue];
  
  if (!data) {
    return;
  }
  
  size_t dataLength = data.length;
  
  if (dataLength > 20) {
    [self errorWithCode:YGBBLEStatusCodeTooBig reason:@"Message too big"];
    return;
  }else if (dataLength == 0){
    [self errorWithCode:YGBBLEStatusCodeEmpty reason:@"Message is empty"];
    return;
  }
  
  // send pocket
  
  if ([[_littleBoy findConnectedPeripheral:_peripheral.name] isEqual:_peripheral] == NO) {
    [self errorWithCode:YGBBLEStatusCodePeripheralError reason:@"This peripheral is not BLE current Peripheral"];
    return;
  }
  
  
  
}

- (void)connect
{
  if (self.readyState != YGBBLEReadyStateOpen) {
    [self errorWithCode:YGBBLEStatusCodeClosed reason:@"Bluetooth is closed"];
    return;
  }
  
  if (self.UUID == nil && self.UUID.length == 0) {
    [self errorWithCode:YGBBLEStatusCodeUUIDNull reason:@"UUID is empty"];
    return;
  }
  
  [self _addObserver];
  [_littleBoy cancelScan];
  [_littleBoy cancelAllPeripheralsConnection];
  _littleBoy.channel(_channel).scanForPeripherals().begin();
}

- (void)disConnect
{
  [_littleBoy cancelScan];
  [_littleBoy cancelAllPeripheralsConnection];
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
  assert(dispatch_get_specific((__bridge void *)self) == (__bridge void *)_workQueue);
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
