//
//  UITableSceneProtocols.h
//  Project
//
//  Created by jearoc on 2017/9/26.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UITableScene;

@protocol up_UITableViewDataSource
@optional
- (__kindof UITableViewCell *)tableView:(UITableView *)tableView cellWithIdentifier:(NSString *)identifier;
@end

@protocol UITableSceneDelegate <UITableViewDelegate>
@optional
/**
 * 自定义要在<i>- (BOOL)touchesShouldCancelInContentView:(UIView *)view</i>内的逻辑<br/>
 * 若delegate不实现这个方法，则默认对所有UIControl返回NO（UIButton除外，它会返回YES），非UIControl返回YES。
 */
- (BOOL)tableView:(UITableScene *)tableView touchesShouldCancelInContentView:(UIView *)view;
@end

@protocol UITableSceneDataSource <UITableViewDataSource, up_UITableViewDataSource>

@end
