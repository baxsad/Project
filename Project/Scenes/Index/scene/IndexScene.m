//
//  IndexScene.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "IndexScene.h"
#import "NextScene.h"
#import "TestView.h"
#import "YGBBLESocket.h"

@interface IndexScene ()<YGBBLESocketDelegate>
@property (nonatomic, strong) YGBBLESocket *socket;
@end

@implementation IndexScene

- (void)didUpdateRSSI:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI error:(NSError *)error
{
  NSLog(@"233");
}

- (void)readyStateUpdate:(YGBBLEReadyState)state socket:(YGBBLESocket *)socket
{
  NSLog(@"233");
}
- (void)onConnect:(CBPeripheral *)peripheral
{
  NSLog(@"233");
}
- (void)onDisconnect:(CBPeripheral *)peripheral error:(NSError *)error
{
  NSLog(@"233");
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.socket = [[YGBBLESocket alloc] initWithUUID:@"35E1613F-D2E9-1A2A-DBE8-65747B8EA925" channel:@"YGB"];
  self.socket.delegate = self;
  
  UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 100, 50)];
  btn.backgroundColor = UIColorRed;
  [btn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:btn];
  
  UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, 100, 50)];
  btn2.backgroundColor = UIColorBlue;
  [btn2 addTarget:self action:@selector(action2) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:btn2];
  
  TestView *test = [[TestView alloc] initWithFrame:CGRectMake(20, 300, 100, 50)];
  test.backgroundColor = UIColorGreen;
  [self.view addSubview:test];
  @weakify(self);
  [[test rac_signalForSelector:@selector(buttonClick)] subscribeNext:^(id x) {
    @strongify(self);
    [self.socket connect];
  }];
  
  UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(20, 400, 100, 50)];
  btn3.backgroundColor = UIColorGrayLighten;
  [btn3 addTarget:self action:@selector(action3) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:btn3];
  
  self.navBarBarTintColor = UIColorRed;
  self.navBarBackgroundAlpha = 1.0;
  self.statusBarStyle = UIStatusBarStyleDefault;
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}
  
- (void)action
{
  NextScene *next = NextScene.alloc.init;
  [self.navigationController pushViewController:next animated:YES];
}
  
- (void)action2
{
  [self setNavBarHidden:!self.navBarHidden animation:YES];
}

- (void)action3
{
  NSError *error;
  [self.socket sendData:[YGBPacket packet_set_state_mode:0 ctr:0 tik:1 R:0xff G:0x5a B:0x5f] error:&error];
  if (error) {
    NSLog(@"error");
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
