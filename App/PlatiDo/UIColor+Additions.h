

#import <UIKit/UIKit.h>

@interface UIColor (Additions)

+ (UIColor *)colorWithHex:(NSInteger)hexNumber;
+ (UIColor *)colorWithHex:(NSInteger)hexNumberInFormat0xRRGGBB alpha:(CGFloat)alpha;
+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIColor *)shadowWithLevel:(CGFloat)level;
- (UIColor *)highlightWithLevel:(CGFloat)level;
- (NSString *)getHexColor;
+ (UIColor*)randomcolor;

@end
