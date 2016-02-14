//
//  UIImage+MyBlur.h
//  ThousandBooks
//
//  Created by home on 19.11.14.
//  Copyright (c) 2014 Fedor Semenchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@interface UIImage (bt_blurrEffect)

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

@end
