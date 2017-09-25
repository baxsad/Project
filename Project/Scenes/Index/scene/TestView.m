//
//  TestView.m
//  Project
//
//  Created by jearoc on 2017/9/1.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "TestView.h"

@interface TestObject : NSObject

@end

@implementation TestObject

- (void)buttonClick
{
  NSLog(@"3333");
}

@end

@interface TestView ()

@property(nonatomic, strong) TestObject*object;

@end

@implementation TestView

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    
//    UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
//    [self addSubview:button];
//    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//      [self buttonClick];
//    }];
//
//    self.object = [TestObject new];
    
  }
  return self;
}

- (void)buttonClick
{
  NSLog(@"3333");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
  if (sel == NSSelectorFromString(@"buttonClick")) {
    return NO;
  }
  return YES;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
  if (aSelector == NSSelectorFromString(@"buttonClick")) {
    return self;
  }
  return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
  return nil;
}

- (void)doesNotRecognizeSelector:(SEL)aSelector
{
  
}

@end
