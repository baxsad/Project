//
//  NSData+Resolve.m
//  IDool
//
//  Created by jearoc on 2017/8/2.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "NSData+Resolve.h"

@implementation NSData (Resolve)

- (NSArray<NSData *> *)resolve:(NSError **)error
{
  if (self.length < 29) {
    *error = [NSError errorWithDomain:@"Data is too short" code:-100 userInfo:nil];
    return nil;
  }else if(self.length > 15560){
    *error = [NSError errorWithDomain:@"Data is too bigg" code:100 userInfo:nil];
    return nil;
  }else{
    NSUInteger begin = 0;
    BOOL next = YES;
    NSMutableArray *v= [NSMutableArray array];
    while (next) {
      if (begin == 0) {
        [v addObject:[self subdataWithRange:NSMakeRange(begin, 12)]];
        begin += 12;
      }else if((self.length - begin) <= 16){
        [v addObject:[self subdataWithRange:NSMakeRange(begin, self.length - begin)]];
        next = NO;
      }else{
        [v addObject:[self subdataWithRange:NSMakeRange(begin, 16)]];
        begin += 16;
      }
    }
    return [v copy];
  }
}

@end
