//
//  UIView+Screenshot.m
//  ThousandBooks
//
//  Created by home on 19.11.14.
//  Copyright (c) 2014 Fedor Semenchenko. All rights reserved.
//

#import "UIView+Screenshot.h"

@implementation UIView (bt_screenshot)

-(UIImage *)screenshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 1);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
