//
//  MineScene.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "MineScene.h"
#import "YGBHomeScene.h"

@interface MineScene ()
@property(nonatomic, strong) NSArray<NSString *> *dataSource;
@end

@implementation MineScene

- (void)viewDidLoad {
  [super viewDidLoad];
  self.dataSource = @[@"Fluorescent bar test",
                      @"连接",
                      @"控制",
                      @"断开",
                      ];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
  [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
  self.title = @"Laboratory";
  self.navigationItem.rightBarButtonItem = [UINavigationButton barButtonItemWithImage:UIImageMake(@"icon_nav_about")
                                                                             position:UINavigationButtonPositionRight
                                                                               target:self
                                                                               action:@selector(handleAboutItemEvent)];
}

- (void)handleAboutItemEvent
{
  UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
  contentView.backgroundColor = UIColorWhite;
  contentView.layer.cornerRadius = 6;
  
  UILabel *label = [[UILabel alloc] init];
  label.numberOfLines = 0;
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.minimumLineHeight = 24;
  paragraphStyle.maximumLineHeight = 24;
  paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
  paragraphStyle.alignment = NSTextAlignmentLeft;
  
  paragraphStyle.paragraphSpacing = 16;
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"默认的布局是上下左右居中，可通过contentViewMargins、maximumContentViewWidth属性来调整宽高、上下左右的偏移。\n你现在可以试试旋转一下设备试试看。" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColorBlack, NSParagraphStyleAttributeName: paragraphStyle}];
  NSDictionary *codeAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Menlo" size:16], NSForegroundColorAttributeName: [UIThemeManager sharedInstance].currentTheme.themeCodeColor};
  
  NSString *pattern = @"\\[?[A-Za-z0-9_.]+\\s?[A-Za-z0-9_:.]+\\]?";
  NSError *error = nil;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
  [regex enumerateMatchesInString:attributedString.string options:NSMatchingReportCompletion range:NSMakeRange(0, attributedString.string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
    if (result.range.length > 0) {
      [attributedString addAttributes:codeAttributes range:result.range];
    }
  }];
  
  label.attributedText = attributedString;
  [contentView addSubview:label];
  
  UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(20, 20, 20, 20);
  CGFloat contentLimitWidth = CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding);
  CGSize labelSize = [label sizeThatFits:CGSizeMake(contentLimitWidth, CGFLOAT_MAX)];
  label.frame = CGRectMake(contentViewPadding.left, contentViewPadding.top, contentLimitWidth, labelSize.height);
  
  UIModalPresentationViewController *modalViewController = [[UIModalPresentationViewController alloc] init];
  modalViewController.contentView = contentView;
  [modalViewController showWithAnimated:YES completion:nil];
}

- (void)didSelectCellWithTitle:(NSString *)title {
  UIViewController *scene;
  if ([title isEqualToString:@"Fluorescent bar test"]) {
    scene = [[YGBHomeScene alloc] init];
  }
  
  if (scene) {
    [self.navigationController pushViewController:scene animated:YES];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifierNormal = @"cellNormal";
  UITableCellScene *cell = [tableView dequeueReusableCellWithIdentifier:identifierNormal];
  if (!cell) {
    cell = [[UITableCellScene alloc] initForTableView:self.tableView withStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierNormal];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
  cell.textLabel.font = UIFontMake(15);
  cell.detailTextLabel.font = UIFontMake(13);
  [cell updateCellAppearanceWithIndexPath:indexPath];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return TableViewCellNormalHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *title = nil;
  title = [self.dataSource objectAtIndex:indexPath.row];
  [self didSelectCellWithTitle:title];
}

@end
