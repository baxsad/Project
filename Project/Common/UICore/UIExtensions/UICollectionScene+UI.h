//
//  UICollectionScene+UI.h
//  Project
//
//  Created by jearoc on 2017/9/27.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "UICollectionScene.h"

@interface UICollectionScene (UI)
- (void)renderGlobalStyle;
- (void)clearsSelection;
- (void)reloadDataKeepingSelection;
- (NSIndexPath *)indexPathForItemAtView:(id)sender;
- (BOOL)itemVisibleAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForFirstVisibleCell;
@end