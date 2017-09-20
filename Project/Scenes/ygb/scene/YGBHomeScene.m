//
//  YGBHomeScene.m
//  Project
//
//  Created by jearoc on 2017/9/19.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "YGBHomeScene.h"

@interface YGBHomeScene ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation YGBHomeScene

- (void)viewDidLoad {
  [super viewDidLoad];
  //self.statusBarStyle = UIStatusBarStyleLightContent;
  //self.navBarBarTintColor = [UIColor blackColor];
  self.navBarBackgroundAlpha = 1.0;
  self.tableView = [[UITableView alloc] init];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.view addSubview:self.tableView];
  @weakify(self);
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.left.right.bottom.equalTo(self.view);
    make.top.equalTo(self.view).offset(-64);
  }];
  
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 99;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
  }
  cell.textLabel.text = [NSString stringWithFormat:@"%li",indexPath.row];
  return cell;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
