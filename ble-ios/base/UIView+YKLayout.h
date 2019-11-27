//
//  UIView+YKLayout.h
//  YKBuilding
//
//  Created by XIAOLI on 2018/6/11.
//  Copyright © 2018年 CoinSea. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XLSetBorderColor(view, color) \
(view).layer.borderColor = (color).CGColor; \
(view).layer.borderWidth = 1.0;

typedef NS_ENUM(NSInteger, YKLayoutAlignment)
{
    YKLayoutAlignmentCenter,
    YKLayoutAlignmentLeft,
    YKLayoutAlignmentRight
};

@interface UIView (YKLayout)
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGSize size;

@end
