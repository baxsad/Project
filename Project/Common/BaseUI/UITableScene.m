//
//  UITableScene.m
//  Project
//
//  Created by jearoc on 2017/9/21.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "UITableScene.h"

@implementation UITableScene

- (instancetype)init
{
  if (self = [super init]) {
    [self setup];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    [self setup];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
  if (self = [super initWithFrame:frame style:style]) {
    [self setup];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  if (self = [super initWithCoder:aDecoder]) {
    [self setup];
  }
  return self;
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

@end
