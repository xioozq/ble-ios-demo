//
//  YKNextRunloopRunner.h
//  YKBuilding
//
//  Created by XIAOLI on 2018/6/15.
//  Copyright © 2018年 CoinSea. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  生成一个Autorelease对象，在此对象销毁执行dealloc时执行 block 操作。
 *
 *  注意：
 *  使用者在栈中使用此方法，由于栈结构的特性，所以在同一个栈中，对象的销毁也是遵循，先进后出的规则。
 */

@interface YKNextRunloopRunner : NSObject
+ (void)run:(void (^)(void))block;

@end
