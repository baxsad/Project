//
//  IndexScene.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "IndexScene.h"
#import "NextScene.h"

@interface IndexScene ()
@property(nonatomic, strong) UIBubbleView *bubbleView;
@end

@implementation IndexScene

- (void)viewDidLoad {
  [super viewDidLoad];
  self.titleView.needsLoadingView = YES;
  
}

- (void)initSubviews
{
  [super initSubviews];
  self.bubbleView = [[UIBubbleView alloc] init];
  self.bubbleView.padding = UIEdgeInsetsMake(12, 12, 12, 12);
  self.bubbleView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
  self.bubbleView.minimumItemSize = CGSizeMake(69, 29);// 以2个字的按钮作为最小宽度
  [self.view addSubview:self.bubbleView];
  
  NSArray<NSString *> *suggestions = @[@"小海绵 手",
                                       @"等等正面照",
                                       @"周莹沈星移拥吻",
                                       @"没有卓伟 事情变得好突然",
                                       @"景区玻璃栈道碎了",
                                       @"别再哭了关晓彤",
                                       @"张翰怼娜扎粉丝",
                                       @"鹿晗掉粉",
                                       @"鹿晗关晓彤",
                                       @"陈翔哭了",
                                       @"热剧安利",
                                       @"胡歌 重庆",
                                       @"陈赫点赞"];
  for (NSInteger i = 0; i < suggestions.count; i++) {
    SSUIGhostButton *button = [[SSUIGhostButton alloc] init];
    button.ghostColor = [UIThemeManager sharedInstance].currentTheme.themeTintColor;
    [button setTitle:suggestions[i] forState:UIControlStateNormal];
    button.titleLabel.font = UIFontMake(14);
    button.contentEdgeInsets = UIEdgeInsetsMake(6, 20, 6, 20);
    [self.bubbleView addSubview:button];
  }
}

- (void)needLayoutSubviews
{
  [super needLayoutSubviews];
  UIEdgeInsets padding = UIEdgeInsetsMake(self.navigationBarMaxYInViewCoordinator + 36, 24, 36, 24);
  CGFloat contentWidth = CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
  CGSize floatLayoutViewSize = [self.bubbleView sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
  self.bubbleView.frame = CGRectMake(padding.left, padding.top, contentWidth, floatLayoutViewSize.height);
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
  [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
  self.title = @"Examples";
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
