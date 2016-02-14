

#import <UIKit/UIKit.h>

@interface UIImage (ImageEffects)
+ (UIImage *)getSnapshotOld:(UIView*)view;
+ (UIImage *)getSnapshotView:(UIView*)view;
+ (UIImage *)getSnapshotView:(UIView*)view rect:(CGRect)rect;
- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;


- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;


- (UIImage *)fixOrientation;

@end
