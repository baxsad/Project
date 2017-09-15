//
//  UIResponder+ResponderChain.m
//  Project
//
//  Created by jearoc on 2017/9/15.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "UIResponder+ResponderChain.h"

@implementation UIResponder (ResponderChain)
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
  [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}
@end
