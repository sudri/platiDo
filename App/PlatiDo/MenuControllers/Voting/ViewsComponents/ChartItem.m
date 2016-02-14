//
//  ChartItem.m
//  ChartsTest
//
//  Created by Valera Voroshilov on 02.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "ChartItem.h"
#import "UIImage+ImageEffects.h"
#import "UIColor+Additions.h"


@interface ChartItem ()
@property (nonatomic, strong) UIView  *progressView;
@property (nonatomic, strong) UIView  *bgView;
@end

@implementation ChartItem
{
    CGFloat _procent;
}

- (id)init{
    self = [super init];
    if (self){
        
        self.title = [[UILabel alloc] init];
        self.title.numberOfLines = 0;
        [self.title setText:@"Сайт рыбатекст поможет дизайнеру."];
        self.title.font = [UIFont fontWithName:@"SF UI Display Regular" size:15];
        [self addSubview:self.title];
        
        self.bgView = [[UIView alloc] init];
        [self.bgView setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:self.bgView];
        
        self.progressView = [[UIView alloc] init];
        [self.progressView setBackgroundColor:[UIColor randomcolor]];
        [self addSubview:self.progressView];
        
        [self addConstraitsCustom];
        
        self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
        self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
        self.title.translatesAutoresizingMaskIntoConstraints = NO;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        _procent = random()%100;
        
    }
    return self;
}




- (void)setProcend:(NSInteger)procend{
     _procent = procend;
     [self updateMask];
}

- (void)layoutSubviews{
    [super layoutSubviews];
     [self updateMask];
}

- (void)updateMask{
    CALayer *mask  = [CALayer layer];
    UIImage *bgimg = (id)[UIImage getSnapshotOld:self.bgView].CGImage;
    mask.contents  = bgimg;
    mask.frame     = CGRectMake(0, 0, 0, self.progressView.bounds.size.height);
    self.progressView.layer.mask = mask;
    self.progressView.layer.masksToBounds = YES;
    mask.anchorPoint = CGPointMake(0, 0.5);
    
    CGFloat progressW =  self.progressView.bounds.size.width/100*_procent;
    
    CABasicAnimation *a = [CABasicAnimation animationWithKeyPath:@"bounds"];
    a.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 0, self.progressView.bounds.size.height)];
    a.toValue   = [NSValue valueWithCGRect:CGRectMake(0, 0, progressW, self.progressView.bounds.size.height)];
    a.duration  = 1.0;
    a.timingFunction  = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    a.fillMode  = kCAFillModeForwards;
    a.removedOnCompletion = NO;
    [mask addAnimation:a forKey:@"hideMask1"];
}


- (void)addConstraitsCustom{
//    
//    self.title
//    
//    self.bgView
//    
//    self.progressView
//    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.title
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.title
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:10]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.title
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:-10]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bgView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.title
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:10]];
    
    ////////////////////////////
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bgView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:10]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bgView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:-10]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bgView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:15]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bgView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:-5]];
    
    ////////////////////
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:10]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:10]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:-10]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:15]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:-5]];

}


@end
