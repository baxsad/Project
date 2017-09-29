//
//  NextScene.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "NextScene.h"

@interface SSCollectionCell : UICollectionViewCell

@end

@implementation SSCollectionCell

@end

@interface NextScene ()

@end

@implementation NextScene

- (void)viewDidLoad {
  [super viewDidLoad];
  self.titleView.title = @"搜索";
}

- (void)initCollectionView
{
  [super initCollectionView];
  
  //self.collectionViewInitialContentInset = UIEdgeInsetsMake(0, 0, 0, 0);
  //self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  layout.itemSize = CGSizeMake(100, 60);
  layout.minimumLineSpacing = 10;
  layout.minimumInteritemSpacing = 10;
  [self.collectionView setCollectionViewLayout:layout animated:NO completion:nil];
  [self.collectionView registerClass:[SSCollectionCell class] forCellWithReuseIdentifier:@"SSCollectionCell"];
}
  
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  NSLog(@"%@",self.collectionView);
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  SSCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SSCollectionCell" forIndexPath:indexPath];
  
  cell.contentView.backgroundColor = UIColorRed;
  return cell;
}

@end
