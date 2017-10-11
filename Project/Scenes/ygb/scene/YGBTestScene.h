//
//  YGBTestScene.h
//  Project
//
//  Created by jearoc on 2017/10/10.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "SSUIListViewController.h"
#import "YGBBLESocket.h"

@interface YGBTestScene : SSUIListViewController{
  @public
  YGBBLESocket *socket;
}

@property(strong,nonatomic)CBPeripheral *currPeripheral;
@end
