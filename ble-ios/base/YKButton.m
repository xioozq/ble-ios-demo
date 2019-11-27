//
//  YKButton.m
//  YKBuilding
//
//  Created by 肖子琦 on 2019/8/19.
//  Copyright © 2019 yunke. All rights reserved.
//

#import "YKButton.h"

static NSString * const YKButtonLoadingImagePathDefault = @"icon_btnload";
static NSString * const YKButtonLoadingImagePathLight = @"icon_btnload_white";

@interface YKButton ()

@property (nonatomic, assign) BOOL highlightByEvent;

@property (nonatomic, strong) NSMutableDictionary * iconsDicForState;
@property (nonatomic, strong) NSMutableDictionary * titlesDicForState;
@property (nonatomic, strong) NSMutableDictionary * titleColorsDicForState;
@property (nonatomic, strong) NSMutableDictionary * bgColorsDicForState;
@property (nonatomic, strong) NSMutableDictionary * bdColorsDicForState;

@end

@implementation YKButton

+ (YKButton *)primaryButton
{
    YKButton *button = [[YKButton alloc] init];
    
    [button setBackgroundColor:[UIColor yk_parseColor:@"#E4B163"] forState:YKButtonStateNormal];
    [button setBackgroundColor:[UIColor yk_parseColor:@"#926A2D"] forState:YKButtonStateHighlighted];
    [button setTitleColor:[UIColor yk_parseColor:@"#3A404A"] forState:YKButtonStateNormal];
    [button setTitleColor:[UIColor yk_parseColor:@"#282D35"] forState:YKButtonStateHighlighted];
    button.loadingType = YKButtonLoadingTypeLight;
    
    return button;
}

+ (YKButton *)primaryHollowButton
{
    YKButton *button = [[YKButton alloc] init];
    
    [button setBorderColor:[UIColor yk_parseColor:@"#E4B163"] forState:YKButtonStateNormal];
    [button setBorderColor:[UIColor yk_parseColor:@"#996E2C"] forState:YKButtonStateHighlighted];
    [button setTitleColor:[UIColor yk_parseColor:@"#E4B163"] forState:YKButtonStateNormal];
    [button setTitleColor:[UIColor yk_parseColor:@"#996E2C"] forState:YKButtonStateHighlighted];
    
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        self.clipsToBounds = YES;
        
        self.bgView = [[UIView alloc] init];
        self.bgView.layer.masksToBounds = YES;
        self.bgView.layer.borderWidth = 1;
        self.radius = 4;
        self.iconView = [[UIImageView alloc] init];
        self.iconView.hidden = YES;
        self.loadingView = [UIImageView imageWithName: YKButtonLoadingImagePathDefault];
        self.loadingView.hidden = YES;
        self.titleLabel = [[YKLabel alloc] init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        _paddingHorizontal = 10;
        self.fontSize = 16;
        
        [self.bgView addSubview:self.iconView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.loadingView];
        [self addSubview:self.bgView];
        
        self.titlesDicForState = [NSMutableDictionary dictionaryWithCapacity:4];
        self.titleColorsDicForState = [NSMutableDictionary dictionaryWithCapacity:4];
        self.iconsDicForState = [NSMutableDictionary dictionaryWithCapacity:4];
        self.bgColorsDicForState = [NSMutableDictionary dictionaryWithCapacity:4];
        self.bdColorsDicForState = [NSMutableDictionary dictionaryWithCapacity:4];
        
        [YKNextRunloopRunner run:^{
            [self updateStyle];
        }];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize iconSize = CGSizeMake(14, 14); // 图标尺寸
    CGFloat iconMargin = 5; // 图标与文字距离
    
    self.bgView.frame = self.bounds;
    self.iconView.size = iconSize;
    self.iconView.top = (self.height - self.iconView.height) / 2;
    [self.titleLabel sizeToFit];
    self.titleLabel.height = self.fontSize + 2;
    self.titleLabel.top = (self.height - self.titleLabel.height) / 2;
    
    if (self.iconView.hidden)
    {
        // 没有图标， title占据整个按钮， 只留左右边距
        self.titleLabel.width = self.width - self.paddingHorizontal * 2;
        self.titleLabel.left = self.paddingHorizontal;
    }
    else
    {
        // 有图标， 加入图标和距离计算
        CGFloat titleMaxWidth = self.width - self.paddingHorizontal * 2 - iconSize.width - iconMargin;
        self.titleLabel.width = self.titleLabel.width > titleMaxWidth
        ? titleMaxWidth
        : self.titleLabel.width;
        CGFloat titleWithIconWidth = self.titleLabel.width + iconSize.width + iconMargin;
        self.iconView.left = self.width - titleWithIconWidth / 2 + self.paddingHorizontal;
        self.titleLabel.left = self.iconView.width + iconMargin;
    }
    
    self.loadingView.size = CGSizeMake(22, 22);
    self.loadingView.top = (self.height - self.loadingView.height) / 2;
    self.loadingView.left = (self.width - self.loadingView.width) / 2;
}

- (void)setRadius:(CGFloat)radius
{
    if (radius != _radius)
    {
        _radius = radius;
        self.layer.cornerRadius = radius;
        self.bgView.layer.cornerRadius = radius;
    }
}

- (void)setPaddingHorizontal:(CGFloat)paddingHorizontal
{
    if (paddingHorizontal != _paddingHorizontal)
    {
        _paddingHorizontal = paddingHorizontal;
        [self setNeedsLayout];
    }
}

- (void)setDisabled:(BOOL)disabled
{
    if (disabled != _disabled)
    {
        _disabled = disabled;
        [self updateStyle];
    }
}

- (void)setFontSize:(CGFloat)fontSize
{
    if (fontSize != _fontSize)
    {
        _fontSize = fontSize;
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [self setNeedsLayout];
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted != _highlighted)
    {
        _highlighted = highlighted;
        [self updateStyle];
    }
}

- (void)setHighlightByEvent:(BOOL)highlightByEvent
{
    if (highlightByEvent != _highlightByEvent)
    {
        _highlightByEvent = highlightByEvent;
        [self updateStyle];
    }
}

- (void)setLoading:(BOOL)loading
{
    if (loading != _loading)
    {
        _loading = loading;
        [self updateStyle];
        if (loading)
        {
            [self loadingAnimateStart];
        }
        else
        {
            [self loadingAnimateEnd];
        }
    }
}

- (void)loadingAnimateStart
{
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotateAnimation.duration = 1;
    rotateAnimation.repeatCount = HUGE_VALF;
    [self.loadingView.layer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
}

- (void)loadingAnimateEnd
{
    [self.loadingView.layer removeAllAnimations];
}

- (void)setLoadingType: (YKButtonLoadingType)type
{
    if (type != _loadingType)
    {
        _loadingType = type;
        if (type == YKButtonLoadingTypeLight)
        {
            self.loadingView.image = [UIImage imageNamed: YKButtonLoadingImagePathLight];
        }
        else
        {
            self.loadingView.image = [UIImage imageNamed: YKButtonLoadingImagePathDefault];
        }
    }
}

- (void)setTitle:(NSString *)title forState:(YKButtonState)state
{
    [self.titlesDicForState setValue:[title copy] forKey: [NSString stringWithFormat:@"%lu", state]];
    [self updateStyle];
}

- (void)setTitleColor:(UIColor *)color forState:(YKButtonState)state
{
    [self.titleColorsDicForState setValue:[color copy] forKey: [NSString stringWithFormat:@"%lu", state]];
    [self updateStyle];
}

- (void)setBackgroundColor:(UIColor *)color forState:(YKButtonState)state
{
    [self.bgColorsDicForState setValue:[color copy] forKey: [NSString stringWithFormat:@"%lu", state]];
    [self updateStyle];
}

- (void)setBorderColor:(UIColor *)color forState:(YKButtonState)state
{
    [self.bdColorsDicForState setValue:[color copy] forKey: [NSString stringWithFormat:@"%lu", state]];
    [self updateStyle];
}

- (void)setIconPath:(NSString *)icon forState:(YKButtonState)state
{
    [self.iconsDicForState setValue:[icon copy] forKey: [NSString stringWithFormat:@"%lu", state]];
    if (icon)
    {
        // 设置icon后， 打开显示， 重新布局
        self.iconView.hidden = NO;
        [self setNeedsLayout];
    }
    [self updateStyle];
}

- (id)getValueFrom:(NSDictionary *)dic forState:(YKButtonState)state
{
    // 根据字典获取对应状态值， 没有则降级为normal
    id value = [dic valueForKey:[NSString stringWithFormat:@"%lu", state]];
    return value
    ? value
    : [dic valueForKey:[NSString stringWithFormat:@"%lu", YKButtonStateNormal]];
}

- (NSString *)getTitleForState:(YKButtonState)state
{
    return [self getValueFrom:self.titlesDicForState forState:state];
}

- (UIColor *)getTitleColorForState:(YKButtonState)state
{
    return [self getValueFrom:self.titleColorsDicForState forState:state];
}

- (UIColor *)getBackgroundColorForState:(YKButtonState)state
{
    return [self getValueFrom:self.bgColorsDicForState forState:state];
}

- (UIColor *)getBorderColorForState:(YKButtonState)state
{
    return [self getValueFrom:self.bdColorsDicForState forState:state];
}

- (NSString *)getIconPathForState:(YKButtonState)state
{
    return [self getValueFrom:self.iconsDicForState forState:state];
}

- (void)updateStyle
{
    if (self.loading)
    {
        [self makeLoadingStyle];
    }
    else if (self.disabled)
    {
        [self makeDisabledStyle];
    }
    else if (self.highlighted || self.highlightByEvent)
    {
        [self makeHighlightedStyle];
    }
    else
    {
        [self makeNormalStyle];
    }
}

- (void)makeStyleForState: (YKButtonState)state
{
    UIColor *bdColor = [self getBorderColorForState:state];
    UIColor *bgColor = [self getBackgroundColorForState:state];
    UIColor *titleColor = [self getTitleColorForState:state];
    NSString *title = [self getTitleForState:state];
    NSString *icon = [self getIconPathForState:state];
    
    bgColor = bgColor ? bgColor : [UIColor clearColor];
    titleColor = titleColor ? titleColor : [UIColor clearColor];
    
    self.titleLabel.hidden = title ? NO: YES;
    self.iconView.hidden = icon ? NO : YES;
    self.loadingView.hidden = YES;
    self.bgView.backgroundColor = bgColor;
    self.bgView.layer.borderColor = bdColor ? bdColor.CGColor : bgColor.CGColor;
    self.titleLabel.text = title;
    self.titleLabel.textColor = titleColor;
    if (icon)
    {
        self.iconView.hidden = NO;
        self.iconView.image = [UIImage imageNamed:icon];
    }
    else
    {
        self.iconView.hidden = YES;
    }
}

- (void)makeLoadingStyle
{
    // loading 时， 样式为normal, 并隐藏icon和title, 打开loadingView
    UIColor *bdColor = [self getBorderColorForState:YKButtonStateNormal];
    UIColor *bgColor = [self getBackgroundColorForState:YKButtonStateNormal];
    
    self.bgView.backgroundColor = bgColor;
    self.bgView.layer.borderColor = bdColor ? bdColor.CGColor : bgColor.CGColor;
    self.iconView.hidden = YES;
    self.titleLabel.hidden = YES;
    self.loadingView.hidden = NO;
    return;
}

- (void)makeDisabledStyle
{
    [self makeStyleForState: YKButtonStateDisabled];
}

- (void)makeHighlightedStyle
{
    [self makeStyleForState:YKButtonStateHighlighted];
}

- (void)makeNormalStyle
{
    [self makeStyleForState: YKButtonStateNormal];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 点击触发高亮
    if (self.loading || self.disabled)
    {
        return;
    }
    self.highlightByEvent = YES;
    if ([self.delegate respondsToSelector:@selector(button:didTouchInside:)])
    {
        [self.delegate performSelector:@selector(button:didTouchInside:) withObject:self withObject:touches];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.loading || self.disabled)
    {
        return;
    }
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: mainWindow];
    CGRect rect = [self convertRect:self.bounds toView:mainWindow];
    
    if (CGRectContainsPoint(rect, point))
    {
        self.highlightByEvent = YES;
    }else
    {
        self.highlightByEvent = NO;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.loading || self.disabled)
    {
        return;
    }
    // 点击结束取消高亮， 派发事件
    if (self.highlightByEvent)
    {
        if ([self.delegate respondsToSelector:@selector(button:didTouchUpInside:)])
        {
            [self.delegate performSelector:@selector(button:didTouchUpInside:) withObject:self withObject:touches];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(button:didTouchUpOutside:)])
        {
            [self.delegate performSelector:@selector(button:didTouchUpOutside:) withObject:self withObject:touches];
        }
    }
    self.highlightByEvent = NO;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.loading || self.disabled)
    {
        return;
    }
    // 点击结束取消高亮
    self.highlightByEvent = NO;
}

@end
