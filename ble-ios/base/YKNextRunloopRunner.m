//
//  YKNextRunloopRunner.m
//  YKBuilding
//
//  Created by XIAOLI on 2018/6/15.
//  Copyright © 2018年 CoinSea. All rights reserved.
//

#import "YKNextRunloopRunner.h"

@interface YKNextRunloopRunner ()
@property (nonatomic, copy) void (^block)(void);

@end

@implementation YKNextRunloopRunner

- (void)dealloc
{
    if (_block) { _block(); }
    [_block release]; _block = nil;
    
    [super dealloc];
}

- (YKNextRunloopRunner *)initRunnerWithBlock:(void (^)(void))block
{
    self = [super init];
    if (self)
    {
        self.block = block;
    }
    
    return self;
}

+ (YKNextRunloopRunner *)runnerWithBlock:(void (^)(void))block
{
    return [[[self alloc] initRunnerWithBlock:block] autorelease];
}

+ (void)run:(void (^)(void))block
{
    YKNextRunloopRunner * runner = [self runnerWithBlock:block];
    [runner class];
}

@end
