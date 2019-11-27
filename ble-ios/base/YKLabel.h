//
//  YKLabel.h
//  YKBuilding
//
//  Created by 肖子琦 on 2019/8/19.
//  Copyright © 2019 yunke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKLabel : UILabel

@property (nonatomic, assign) UIEdgeInsets textInsets;

- (void)setFontSize: (CGFloat)fontSize;
- (void)setTextColorWithString: (NSString *)color;

@end
