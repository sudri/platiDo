//
//  MagicPinLabel.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 26.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "MagicPinLabel.h"

@implementation MagicPinLabel{
    UILabel *lbl;
    UIView  *caretka;
    UIView  *circle;
}

- (id)initWithCoder:(nonnull NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        lbl = [[UILabel alloc] initWithFrame:self.bounds];
        lbl.text = @"";
        lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lbl];
        
        caretka = [[UIView alloc] initWithFrame:(CGRect){0, self.frame.size.height-2, self.frame.size.width, 2}];
        [caretka setBackgroundColor:[UIColor darkGrayColor]];
        [self addSubview:caretka];
        
        CGRect rect = CGRectInset(self.bounds, 3, 3);
        
        circle  = [[UIView alloc] initWithFrame:rect];
        [circle setBackgroundColor:[UIColor darkGrayColor]];
        [circle.layer setCornerRadius:rect.size.height/2];
        [circle setAlpha:0];
         circle.transform =  CGAffineTransformMakeScale(0.2, 0.2);
        [self addSubview:circle];
    }
    return self;
}

- (void)setNumber:(NSString*)str{
    [lbl setText:str];
  
    [UIView animateWithDuration:0.2 animations:^() {
       [caretka setAlpha:0];
        caretka.transform = CGAffineTransformMakeScale(0.2, 0.2);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^() {
            [circle setAlpha:1];
            lbl.transform = CGAffineTransformMakeScale(0.2, 0.2);
            circle.transform = CGAffineTransformMakeScale(1.3, 1.3);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^() {
                circle.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
        }];
    });
}

@end
