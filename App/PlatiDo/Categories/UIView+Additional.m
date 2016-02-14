//
//  UIView+Additional.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 22.07.15.
//  Copyright (c) 2015 Valera Voroshilov. All rights reserved.
//

#import "UIView+Additional.h"

@implementation UIView (Additional)

- (UIView *)findViewThatIsFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findViewThatIsFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}

- (void)drawShadow{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
   // [self setBackgroundColor:[UIColor whiteColor]];
    self.layer.shadowRadius =  2;
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.layer.shadowOpacity = 0.3f;
    self.layer.shadowPath = shadowPath.CGPath;
}


- (void)shakeAnimation {
    
    CAKeyframeAnimation * shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    [shake setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [shake setDuration:1];
    [shake setValues:@[ @(-20), @(20), @(-20), @(20), @(-10), @(10), @(-5), @(5), @(0) ]];
    
    [self.layer addAnimation:shake forKey:@"shake"];
}
@end
