//
//  YKButton.h
//  YKBuilding
//
//  Created by 肖子琦 on 2019/8/19.
//  Copyright © 2019 yunke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKLabel.h"

// 按钮状态
typedef NS_ENUM(NSInteger, YKButtonState)
{
    YKButtonStateNormal = 0,
    YKButtonStateHighlighted = 1,
    YKButtonStateDisabled = 2,
    YKButtonStateLoading = 3
};

// 按钮loading类型
typedef NS_ENUM(NSInteger, YKButtonLoadingType)
{
    YKButtonLoadingTypeDefault,
    YKButtonLoadingTypeLight
};

@class YKButton;

@protocol YKButtonDelegate <NSObject>

@optional
- (void)button:(YKButton *)button didTouchInside:(NSSet<UITouch *> *)touches;
- (void)button:(YKButton *)button didTouchUpInside:(NSSet<UITouch *> *)touches;
- (void)button:(YKButton *)button didTouchUpOutside:(NSSet<UITouch *> *)touches;

@end

@interface YKButton : UIView


@property (nonatomic, assign) BOOL disabled; // 禁用
@property (nonatomic, assign) BOOL highlighted; // 手动设置高亮
@property (nonatomic, assign) BOOL loading; // 加载中
@property (nonatomic, assign) CGFloat radius; // 圆角
@property (nonatomic, assign) CGFloat paddingHorizontal; // 左右内边距
@property (nonatomic, assign) CGFloat fontSize; // title字号
@property (nonatomic, assign) YKButtonLoadingType loadingType; // loading类型

@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UIImageView * loadingView;
@property (nonatomic, strong) YKLabel * titleLabel;
@property (nonatomic, strong) UIImageView * iconView;

@property (nonatomic, copy) NSString *id;
@property (nonatomic, weak) id<YKButtonDelegate> delegate;

+ (YKButton *)primaryButton; // 默认主题风格按钮
+ (YKButton *)primaryHollowButton; // 默认主题风格空心按钮
- (void)setTitle:(NSString *)title forState:(YKButtonState)state;
- (void)setTitleColor:(UIColor *)color forState:(YKButtonState)state;
- (void)setBackgroundColor:(UIColor *)color forState:(YKButtonState)state;
- (void)setBorderColor:(UIColor *)color forState:(YKButtonState)state;
- (void)setIconPath:(NSString *)icon forState:(YKButtonState)state;

@end
