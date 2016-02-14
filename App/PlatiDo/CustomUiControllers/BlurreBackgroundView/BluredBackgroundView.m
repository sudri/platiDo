//
//  BluredBackgroundView.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 17.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "BluredBackgroundView.h"

@interface BluredBackgroundView ()

@end

@implementation BluredBackgroundView
{
    UIView *_bg;
}


- (void)awakeFromNib{
    [self setBackgroundColor:[UIColor clearColor]];
    [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.layer setBorderWidth:1.0];
    [self.layer setCornerRadius:2.0];
   
    
    _bg  = [[UIView alloc] initWithFrame:self.bounds];
    [_bg setBackgroundColor:[UIColor whiteColor]];
    _bg.alpha = 0.97;
    
    [self addSubview:_bg];
    [self sendSubviewToBack:_bg];

    self.clipsToBounds = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_bg setFrame:self.bounds];
}

@end
