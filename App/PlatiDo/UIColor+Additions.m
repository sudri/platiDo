

#import "UIColor+Additions.h"


@implementation UIColor (Additions)

+ (UIColor *)colorWithHex:(NSInteger)hexNumber
{
    return [self colorWithHex:hexNumber alpha:1.0];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIColor *)colorWithHex:(NSInteger)hexNumberInFormat0xRRGGBB alpha:(CGFloat)alpha
{
    return [self colorWithRed:(CGFloat)((hexNumberInFormat0xRRGGBB >> 16) & 0xFF) / 255.0
                        green:(CGFloat)((hexNumberInFormat0xRRGGBB >>  8) & 0xFF) / 255.0
                         blue:(CGFloat)((hexNumberInFormat0xRRGGBB >>  0) & 0xFF) / 255.0
                        alpha:alpha];
}

+ (UIColor*)randomcolor{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}


- (UIColor *)shadowWithLevel:(CGFloat)level
{
    CGFloat r, g, b, a;
    return ([self getRed:&r green:&g blue:&b alpha:&a] ? [UIColor colorWithRed:(r * (1.0 - level))
                                                                         green:(g * (1.0 - level))
                                                                          blue:(b * (1.0 - level)) alpha:a] : self);
}

- (UIColor *)highlightWithLevel:(CGFloat)level
{
    CGFloat r, g, b, a;
    return ([self getRed:&r green:&g blue:&b alpha:&a] ? [UIColor colorWithRed:(r * (1.0 - level) + level)
                                                                         green:(g * (1.0 - level) + level)
                                                                          blue:(b * (1.0 - level) + level) alpha:a] : self);
}

- (NSString *)getHexColor
{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    return [NSString stringWithFormat:@"%02x%02x%02x", (unsigned int)(255 * components[0]), (unsigned int)(255 * components[1]), (unsigned int)(255 * components[2])];
}

@end
