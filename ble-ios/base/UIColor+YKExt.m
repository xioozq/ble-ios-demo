//
//  UIColorw+YKExt.m
//  ble-ios
//
//  Created by 肖子琦 on 2019/8/22.
//  Copyright © 2019 yunke. All rights reserved.
//

#import "UIColor+YKExt.h"


@implementation UIColor (UIColor_YKExt)

+ (UIColor*)yk_parseColor:(NSString*)color
{
    if ([color hasPrefix:@"#"])
    {
        return [UIColor yk_hexColor:color];
    }
    
    if ([color hasPrefix:@"rgb"])
    {
        return [UIColor yk_rgbColor:color];
    }
    
    return [UIColor blackColor];
}

+ (UIColor*)yk_hexColor:(NSString*)hexColor
{
    unsigned int red, green, blue, alpha;
    NSRange range;
    range.length = 2;
    @try {
        if ([hexColor hasPrefix:@"#"])
        {
            hexColor = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
        }
        range.location = 0;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
        range.location = 2;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
        range.location = 4;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
        
        if ([hexColor length] > 6) {
            range.location = 6;
            [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&alpha];
        }
        else
        {
            alpha = 255;
        }
    }
    @catch (NSException * e) {
        //        [MAUIToolkit showMessage:[NSString stringWithFormat:@"颜色取值错误:%@,%@", [e name], [e reason]]];
        //        return [UIColor blackColor];
    }
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:(float)(alpha/255.0f)];
}

+ (UIColor*)yk_rgbColor:(NSString*)rgbColor
{
    NSError *matchError;
    
    NSString *patternRGBA = @"rgba\\([\\s]?+(\\d+)[\\s]?+,[\\s]?+(\\d+)[\\s]?+,[\\s]?+(\\d+)[\\s]?+,[\\s]?+(\\d+(\\.\\d+)?)[\\s]?+\\)";
    NSString *patternRGB  = @"rgb\\([\\s]?+(\\d+)[\\s]?+,[\\s]?+(\\d+)[\\s]?+,[\\s]?+(\\d+)[\\s]?+\\)";
    NSRegularExpression *regexpRGBA = [[NSRegularExpression alloc] initWithPattern:patternRGBA options:0 error:&matchError];
    NSRegularExpression *regexpRGB  = [[NSRegularExpression alloc] initWithPattern:patternRGB  options:0 error:&matchError];
    
    unsigned int red = 0, green = 0, blue = 0;
    float alpha = 1.0f;

    NSArray<NSTextCheckingResult *> *matchesRGBA = [regexpRGBA matchesInString:rgbColor options:NSMatchingReportCompletion range:NSMakeRange(0, rgbColor.length)];
    NSArray<NSTextCheckingResult *> *matchesRGB  = [regexpRGB  matchesInString:rgbColor options:NSMatchingReportCompletion range:NSMakeRange(0, rgbColor.length)];
    NSArray<NSTextCheckingResult *> *matches;
    
    if (matchesRGBA.count)
    {
        matches = matchesRGBA;
    }
    else if (matchesRGB.count)
    {
        matches = matchesRGB;
    }
    
    if (matches)
    {
        NSRange matchRange = matches[0].range;
        NSString *matchString = [rgbColor substringWithRange:matchRange];
        
        red = (unsigned int)[matchString substringWithRange:[matches[0] rangeAtIndex:1]].integerValue;
        green = (unsigned int)[matchString substringWithRange:[matches[0] rangeAtIndex:2]].integerValue;
        blue = (unsigned int)[matchString substringWithRange:[matches[0] rangeAtIndex:3]].integerValue;
        alpha = matchesRGBA.count ? (float)[matchString substringWithRange:[matches[0] rangeAtIndex:4]].floatValue : 1.0f;
    }
    
//    NSLog(@"r:%d g:%d b:%d a:%f", red, green, blue, alpha);
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:(float)(alpha)];
}

@end
