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

- (void)setTableFooterView:(UIView *)tableFooterView {
  ///< 保证一直存在tableFooterView，以去掉列表内容不满一屏时尾部的空白分割线
  if (!tableFooterView) {
    tableFooterView = [[UIView alloc] init];
  }
  [super setTableFooterView:tableFooterView];
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
  if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:touchesShouldCancelInContentView:)]) {
    return [self.delegate tableView:self touchesShouldCancelInContentView:view];
  }
  ///< 默认情况下只有当view是非UIControl的时候才会返回yes，这里统一对UIButton也返回yes
  ///< 原因是UITableView上面把事件延迟去掉了，但是这样如果拖动的时候手指是在UIControl上面的话，就拖动不了了
  if ([view isKindOfClass:[UIControl class]]) {
    if ([view isKindOfClass:[UIButton class]]) {
      return YES;
    } else {
      return NO;
    }
  }
  return YES;
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
