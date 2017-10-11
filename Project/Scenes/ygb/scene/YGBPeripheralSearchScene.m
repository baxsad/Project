//
//  YGBPeripheralSearchScene.m
//  Project
//
//  Created by jearoc on 2017/10/11.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "YGBPeripheralSearchScene.h"
#import "YGBTestScene.h"
#import "YGBBLESocket.h"

@interface YGBPeripheralSearchScene ()<YGBBLESocketDelegate>
@property (nonatomic, strong) YGBBLESocket *socket;
@property (nonatomic, strong) UIStaticTableViewCellDataSource *dataSource;
@end

@implementation YGBPeripheralSearchScene{
  BOOL _searchOn;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.socket = [[YGBBLESocket alloc] initWithUUID:@"2EFF60BC-9064-5E47-21D8-FC5C73266ACA" channel:@"YGB"];
  self.socket.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  if (_searchOn) {
    [self.socket find];
  }
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  [self.socket stopFind];
}

- (void)initSubviews
{
  [super initSubviews];
}

- (void)initTableView
{
  [super initTableView];
  
  UIStaticTableViewCellData *s = [[UIStaticTableViewCellData alloc] init];
  s.identifier = 0;
  s.text = @"搜索";
  s.accessoryType = UIStaticTableViewCellAccessoryTypeSwitch;
  s.accessoryTarget = self;
  s.accessoryAction = @selector(handleFindCellEvent:);
  
  UIStaticTableViewCellDataSource *dataSource = [[UIStaticTableViewCellDataSource alloc] initWithCellDataSections:@[@[s],@[].mutableCopy]];
  self.tableView.staticCellDataSource = dataSource;
  self.dataSource = dataSource;
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated
{
  [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
  self.titleView.title = @"搜索";
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return section == 1 ? @"选取设备..." : nil;
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

#pragma mark - handleCellEvent

- (void)handleFindCellEvent:(UISwitch *)switchControl {
  // UISwitch 的开关事件，注意第一个参数的类型是 UISwitch
  if (switchControl.on) {
    [self.socket find];
    _searchOn = YES;
  } else {
    [self.socket stopFind];
    _searchOn = NO;
    NSMutableArray *ygbList = (NSMutableArray *)[self.dataSource.cellDataSections objectAtIndex:1];
    [ygbList removeAllObjects];
    [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
  }
}

- (void)handleYGBCellEvent:(UIStaticTableViewCellData *)cellData
{
  if (cellData.extendObject == nil) {
    [UITips showWithText:@"设备未知错误" inView:self.view hideAfterDelay:1.7];
    return;
  }
  YGBTestScene *test = [YGBTestScene.alloc initWithStyle:UITableViewStyleGrouped];
  test -> socket = self.socket;
  test.currPeripheral = cellData.extendObject;
  [self.navigationController pushViewController:test animated:YES];
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

- (void)findPeripheral:(CBPeripheral *)peripheral socket:(YGBBLESocket *)socket RSSI:(NSNumber *)RSSI
{
  NSMutableArray *ygbList = (NSMutableArray *)[self.dataSource.cellDataSections objectAtIndex:1];
  [ygbList removeAllObjects];
  
  UIStaticTableViewCellData *i = [[UIStaticTableViewCellData alloc] init];
  i.identifier = 1;
  i.style = UITableViewCellStyleSubtitle;
  i.height = TableViewCellNormalHeight + 6;
  i.text = peripheral.name;
  i.detailText = [NSString stringWithFormat:@"RSSI:%@",RSSI];
  i.accessoryType = UIStaticTableViewCellAccessoryTypeNone;
  i.didSelectTarget = self;
  i.didSelectAction = @selector(handleYGBCellEvent:);
  i.extendObject = peripheral;
  
  [ygbList addObject:i];
  [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
