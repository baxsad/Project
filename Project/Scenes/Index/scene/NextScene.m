//
//  NextScene.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "NextScene.h"

@interface SSCollectionCell : UICollectionViewCell
@property(nonatomic, strong, readonly) UILabel *contentLabel;
@end

@implementation SSCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.layer.cornerRadius = 3;
    
    _contentLabel = [[UILabel alloc] initWithFont:UIFontLightMake(100) textColor:UIColorWhite];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.contentLabel];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self.contentLabel sizeToFit];
  self.contentLabel.center = CGPointMake(CGRectGetWidth(self.contentView.bounds) / 2, CGRectGetHeight(self.contentView.bounds) / 2);
}
@end

@interface NextScene ()<UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionViewPagingLayout *collectionViewLayout;
@end

@implementation NextScene

- (void)viewDidLoad {
  [super viewDidLoad];
  self.titleView.title = @"搜索";
}

- (void)initCollectionView
{
  [super initCollectionView];
  
  self.collectionViewLayout = [[UICollectionViewPagingLayout alloc] initWithStyle:UICollectionViewPagingLayoutStyleDefault];
  [self.collectionView setCollectionViewLayout:self.collectionViewLayout animated:NO completion:nil];
  [self.collectionView registerClass:[SSCollectionCell class] forCellWithReuseIdentifier:@"cell"];
  self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
  self.collectionViewLayout.sectionInset = UIEdgeInsetsMake(36, 36, 36, 36);
  self.collectionViewLayout.allowsMultipleItemScroll = NO;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  SSCollectionCell *cell = (SSCollectionCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
  cell.contentLabel.text = [NSString stringWithNSInteger:indexPath.item];
  cell.backgroundColor = [UIColor randomColor];
  [cell setNeedsLayout];
  return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CGSize size = CGSizeMake(CGRectGetWidth(collectionView.bounds) - UIEdgeInsetsGetHorizontalValue(self.collectionViewLayout.sectionInset), CGRectGetHeight(collectionView.bounds) - UIEdgeInsetsGetVerticalValue(self.collectionViewLayout.sectionInset) - self.navigationBarMaxYInViewCoordinator);
  return size;
}

@end
