//
//  NSData+Resolve.h
//  IDool
//
//  Created by jearoc on 2017/8/2.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Resolve)

- (NSArray<NSData *> *)resolve:(NSError **)error;

@end
