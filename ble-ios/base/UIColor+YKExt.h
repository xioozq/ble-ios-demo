//
//  UIColorw+YKExt.h
//  ble-ios
//
//  Created by 肖子琦 on 2019/8/22.
//  Copyright © 2019 yunke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (YKExt)

+ (UIColor *)yk_hexColor:(NSString*)hexColor;
+ (UIColor *)yk_rgbColor:(NSString*)rgbColor;
+ (UIColor *)yk_parseColor:(NSString*)color;

@end

NS_ASSUME_NONNULL_END
