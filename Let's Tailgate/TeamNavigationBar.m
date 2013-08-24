//
//  TeamNavigationBar.m
//  Let's Tailgate
//
//  Created by Nick Shepherd on 8/24/13.
//  Copyright (c) 2013 Grey Bull Studios. All rights reserved.
//

#import "TeamNavigationBar.h"

@implementation TeamNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

/**
- (void)drawRect:(CGRect)rect {
    UIColor *color = [self colorWithHexString:@"333333"];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColor(context, CGColorGetComponents( [color CGColor]));
    CGContextFillRect(context, rect);
    
    for (id subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [(UIButton *)subView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [(UIButton *)subView setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
        }
    }
    
}
 **/

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect barFrame = self.frame;
    self.frame = barFrame;
}


-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


@end
