//
//  YKLabel.m
//  YKBuilding
//
//  Created by 肖子琦 on 2019/8/19.
//  Copyright © 2019 yunke. All rights reserved.
//

#import "YKLabel.h"

@implementation YKLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.textInsets = UIEdgeInsetsZero;
    }
    
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect: UIEdgeInsetsInsetRect(rect, self.textInsets)];
}

- (void)setFontSize: (CGFloat)fontSize
{
    self.font = [UIFont systemFontOfSize:fontSize];
}

- (void)setTextColorWithString: (NSString *)color
{
    self.textColor = [UIColor yk_parseColor:color];
}

@end
