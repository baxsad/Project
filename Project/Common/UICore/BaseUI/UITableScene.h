//
//  UITableScene.h
//  Project
//
//  Created by jearoc on 2017/9/21.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableSceneProtocols.h"

@interface UITableScene : UITableView
@property(nonatomic, weak) id<UITableSceneDelegate> delegate;
@property(nonatomic, weak) id<UITableSceneDataSource> dataSource;
@end
