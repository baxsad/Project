//
//  YGBTestScene.m
//  Project
//
//  Created by jearoc on 2017/10/10.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "YGBTestScene.h"

@interface YGBTestScene ()<YGBBLESocketDelegate>
@end

@implementation YGBTestScene

- (void)viewDidLoad {
  [super viewDidLoad];
  socket.delegate = self;
}

- (void)initSubviews
{
  [super initSubviews];
  
  UIStaticTableViewCellData *c = [[UIStaticTableViewCellData alloc] init];
  c.identifier = 1;
  c.text = @"连接";
  c.didSelectTarget = self;
  c.didSelectAction = @selector(handleConnectCellEvent:);
  c.accessoryType = UIStaticTableViewCellAccessoryTypeDetailButton;
  c.accessoryTarget = self;
  c.accessoryAction = @selector(handleConnectCellEvent:);
  
  UIStaticTableViewCellData *a = [[UIStaticTableViewCellData alloc] init];
  a.identifier = 0;
  a.text = @"断开重连";
  a.accessoryType = UIStaticTableViewCellAccessoryTypeSwitch;
  a.accessoryTarget = self;
  a.accessoryAction = @selector(handleAutoConnectCellEvent:);
  
  UIStaticTableViewCellData *i = [[UIStaticTableViewCellData alloc] init];
  i.identifier = 2;
  i.style = UITableViewCellStyleSubtitle;
  i.height = TableViewCellNormalHeight + 6;
  i.text = @"设备状态（点击获取）";
  i.detailText = @"模式：?? && 闪烁：??";
  i.accessoryType = UIStaticTableViewCellAccessoryTypeNone;
  i.didSelectTarget = self;
  i.didSelectAction = @selector(handleInfoCellEvent:);
  
  UIStaticTableViewCellData *m = [[UIStaticTableViewCellData alloc] init];
  m.identifier = 3;
  m.text = @"模式（随机）";
  m.didSelectTarget = self;
  m.didSelectAction = @selector(handleModelSwitchCellEvent:);
  m.accessoryType = UIStaticTableViewCellAccessoryTypeDisclosureIndicator;
  m.accessoryTarget = self;
  m.accessoryAction = @selector(handleModelSwitchCellEvent:);
  
  UIStaticTableViewCellData *t = [[UIStaticTableViewCellData alloc] init];
  t.identifier = 4;
  t.text = @"闪烁方式（随机）";
  t.didSelectTarget = self;
  t.didSelectAction = @selector(handleTikCellEvent:);
  t.accessoryType = UIStaticTableViewCellAccessoryTypeDisclosureIndicator;
  
  UIStaticTableViewCellData *r = [[UIStaticTableViewCellData alloc] init];
  r.identifier = 4;
  r.text = @"初始化";
  r.didSelectTarget = self;
  r.didSelectAction = @selector(handleResetCellEvent:);
  r.accessoryType = UIStaticTableViewCellAccessoryTypeDisclosureIndicator;
  
  UIStaticTableViewCellDataSource *dataSource = [[UIStaticTableViewCellDataSource alloc] initWithCellDataSections:@[@[c,a,i,m,t,r]]];
  self.tableView.staticCellDataSource = dataSource;
}

- (void)initTableView
{
  [super initTableView];
  
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated
{
  [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
  self.titleView.title = @"荧光棒测试";
  UIBarButtonItem *xc = [UINavigationButton barButtonItemWithType:UINavigationButtonTypeNormal
                                                            title:@"#"
                                                         position:UINavigationButtonPositionRight
                                                           target:self
                                                           action:@selector(testDescription)];
  self.navigationItem.rightBarButtonItem = xc;
}

- (void)willPopInNavigationControllerWithAnimated:(BOOL)animated
{
  [socket disConnect];
}

- (void)testDescription
{
  [UITips showInfo:@"荧光棒测试项目" detailText:@"只提供开发测试，非正常使用功能!" inView:self.view hideAfterDelay:1.5f];
}

#pragma mark - cell event

- (void)handleConnectCellEvent:(UIStaticTableViewCellData *)cellData {
  [socket connect];
}

- (void)handleAutoConnectCellEvent:(UISwitch *)switchControl {
  // UISwitch 的开关事件，注意第一个参数的类型是 UISwitch
  if (switchControl.on) {
    [socket addAutoConnectPeripheral:self.currPeripheral];
  } else {
    [socket removeAutoConnectPeripheral:self.currPeripheral];
  }
}

- (void)handleInfoCellEvent:(UIStaticTableViewCellData *)cellData {
  NSData *value = [YGBPacket packet_get_device_inf_one];
  [socket sendData:value characteristicUUID:@"B6110002-1114-4D64-8426-0690F9BE36EF" error:nil];
}

- (void)handleModelSwitchCellEvent:(UIStaticTableViewCellData *)cellData {
  NSData *value = [YGBPacket packet_set_state_mode:arc4random() % 100 > 50 ? 0x00 : 0x01
                                               ctr:0x00
                                               tik:0x01
                                                 R:arc4random() % 255
                                                 G:arc4random() % 255
                                                 B:arc4random() % 255];
  [socket sendData:value characteristicUUID:@"B6110002-1114-4D64-8426-0690F9BE36EF" error:nil];
}

- (void)handleTikCellEvent:(UIStaticTableViewCellData *)cellData
{
  int random = arc4random() % 100;
  NSData *value = [YGBPacket packet_set_tik_mode:random < 33 ? 0x01 : random < 66 ? 0x02 : 0x03
                                               R:arc4random() % 255
                                               G:arc4random() % 255
                                               B:arc4random() % 255];
  [socket sendData:value characteristicUUID:@"B6110002-1114-4D64-8426-0690F9BE36EF" error:nil];
}

- (void)handleResetCellEvent:(UIStaticTableViewCellData *)cellData
{
  NSData *value = [YGBPacket packet_set_restore:0x01];
  [socket sendData:value characteristicUUID:@"B6110002-1114-4D64-8426-0690F9BE36EF" error:nil];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return section == 0 ? @"荧光棒" : nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // 因为需要自定义 cell 的内容，所以才需要重写 tableView:cellForRowAtIndexPath: 方法。
  // 当重写这个方法时，请通过 staticCellDataSource 同名方法获取到 cell 实例
  SSUITableCell *cell = [tableView.staticCellDataSource cellForRowAtIndexPath:indexPath];
  
  if ([cell.accessoryView isKindOfClass:[UISwitch class]]) {
    UISwitch *switchControl = (UISwitch *)cell.accessoryView;
    switchControl.onTintColor = [UIThemeManager sharedInstance].currentTheme.themeTintColor;
    switchControl.tintColor = switchControl.onTintColor;
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // 因为需要自定义 cell 的内容，所以才需要重写 tableView:didSelectRowAtIndexPath: 方法。
  // 当重写这个方法时，请调用 qmui_staticCellDataSource 的同名方法以保证功能的完整
  [tableView.staticCellDataSource didSelectRowAtIndexPath:indexPath];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - YGBBLESocketDelegate

- (void)readyStateUpdate:(YGBBLEReadyState)state socket:(YGBBLESocket *)socket
{
  NSString *info;
  if (state == YGBBLEReadyStateUnused) info = @"蓝牙闲置";
  if (state == YGBBLEReadyStateOpen) info = @"蓝牙打开";
  if (state == YGBBLEReadyStateClosed) info = @"蓝牙关闭";
  [UITips showWithText:info inView:self.view hideAfterDelay:1.0];
}

- (void)connectSucceed:(CBPeripheral *)peripheral
{
  [UITips showWithText:[NSString stringWithFormat:@"成功连接到外设:%@",peripheral.name] inView:self.view hideAfterDelay:1.0];
  UIStaticTableViewCellData *s = [self.tableView.staticCellDataSource.cellDataSections[0] objectAtIndex:0];
  s.accessoryType = UIStaticTableViewCellAccessoryTypeDoneButton;
  [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)connectFailed:(CBPeripheral *)peripheral error:(NSError *)error
{
  [UITips showWithText:[NSString stringWithFormat:@"连接外设失败:%@",peripheral.name] inView:self.view hideAfterDelay:1.0];
  UIStaticTableViewCellData *s = [self.tableView.staticCellDataSource.cellDataSections[0] objectAtIndex:0];
  s.accessoryType = UIStaticTableViewCellAccessoryTypeDetailButton;
  [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)disconnect:(CBPeripheral *)peripheral error:(NSError *)error
{
  [UITips showWithText:[NSString stringWithFormat:@"外设失去连接:%@",peripheral.name] inView:self.view hideAfterDelay:1.0];
  UIStaticTableViewCellData *s = [self.tableView.staticCellDataSource.cellDataSections[0] objectAtIndex:0];
  s.accessoryType = UIStaticTableViewCellAccessoryTypeDetailButton;
  [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)discoverCharacteristicsSucceed:(NSDictionary *)characteristics peripheral:(CBPeripheral *)peripheral service:(CBService *)service
{
  
}

- (void)discoverCharacteristicsFailed:(CBPeripheral *)peripheral service:(CBService *)service error:(NSError *)error
{
  
}

- (void)receiveDataSucceed:(CBCharacteristic *)characteristic peripheral:(CBPeripheral *)peripheral value:(NSData *)value
{
  if ([characteristic.UUID.UUIDString isEqualToString:@"2A19"]) {}
  if ([characteristic.UUID.UUIDString isEqualToString:@"B6110002-1114-4D64-8426-0690F9BE36EF"]) {}
  if ([characteristic.UUID.UUIDString isEqualToString:@"B6110003-1114-4D64-8426-0690F9BE36EF"]) {
    unsigned int mode,ctr,tik;
    [value getMode:&mode ctr:&ctr tik:&tik];
    UIStaticTableViewCellData *i = [self.tableView.staticCellDataSource.cellDataSections[0] objectAtIndex:2];
    i.detailText = [NSString stringWithFormat:@"模式：%@ && 闪烁：%@",mode == 0x00 ? @"显示" : @"灯亮",tik == 0x01 ? @"常亮" : tik == 0x02 ? @"呼吸" : @"闪烁"];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
  }
}

- (void)receiveDataFailed:(CBCharacteristic *)characteristic peripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
  
}

- (void)characteristicDidWritValue:(NSData *)data peripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic
{
  unsigned int mode,ctr,tik;
  [data getMode:&mode ctr:&ctr tik:&tik];
  UIStaticTableViewCellData *i = [self.tableView.staticCellDataSource.cellDataSections[0] objectAtIndex:2];
  i.detailText = [NSString stringWithFormat:@"模式：%@ && 闪烁：%@",mode == 0x00 ? @"显示" : @"灯亮",tik == 0x01 ? @"常亮" : tik == 0x02 ? @"呼吸" : @"闪烁"];
  [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

@end
