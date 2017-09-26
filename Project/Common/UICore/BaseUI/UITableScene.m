//
//  UITableScene.m
//  Project
//
//  Created by jearoc on 2017/9/21.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "UITableScene.h"
#import "UITableScene+UI.h"

@implementation UITableScene

@dynamic delegate;
@dynamic dataSource;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
  if (self = [super initWithFrame:frame style:style]) {
    [self didInitialized];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    [self didInitialized];
  }
  return self;
}

- (void)didInitialized {
  [self renderGlobalStyle];
}

- (void)dealloc {
  self.delegate = nil;
  self.dataSource = nil;
}

// 保证一直存在tableFooterView，以去掉列表内容不满一屏时尾部的空白分割线
- (void)setTableFooterView:(UIView *)tableFooterView {
  if (!tableFooterView) {
    tableFooterView = [[UIView alloc] init];
  }
  [super setTableFooterView:tableFooterView];
}

#pragma mark - setup

- (void)setup
{
  self.backgroundColor = TableViewBackgroundColor;
  if (@available(iOS 11,*)) {
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
  }
}

#ifdef DEBUG

- (void)setContentOffset:(CGPoint)contentOffset {
  [super setContentOffset:contentOffset];
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
  [super setContentOffset:contentOffset animated:animated];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
  [super setContentInset:contentInset];
}

#endif

@end
