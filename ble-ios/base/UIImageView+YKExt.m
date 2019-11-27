//
//  UIImageView+YKExt.m
//  ble-ios
//
//  Created by 肖子琦 on 2019/11/26.
//  Copyright © 2019 yunke. All rights reserved.
//

#import "UIImageView+YKExt.h"


@implementation UIImageView (YKExt)

+ (instancetype)imageWithName:(NSString *)name {
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:name];
    return imageView;
};

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return self;
}

@end
