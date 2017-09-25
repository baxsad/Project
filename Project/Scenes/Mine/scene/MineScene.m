//
//  MineScene.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "MineScene.h"
#import "HintsScene.h"

@interface MineScene ()

@end

@implementation MineScene

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
  [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
  self.title = @"實驗室";
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

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
