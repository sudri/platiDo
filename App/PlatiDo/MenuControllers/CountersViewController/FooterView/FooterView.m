//
//  FooterView.m
//  ABooks
//
//  Created by home on 28.07.15.
//  Copyright (c) 2015 Roman Dmitriev. All rights reserved.
//

#import "FooterView.h"

#define ACTIVITY_SIZE 20.0
#define FOOTER_HEIGHT 40.0


@implementation FooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.activityIndicator = [[UIActivityIndicatorView alloc]
                                                       initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        self.activityIndicator.tag = 10;
        self.activityIndicator.frame = CGRectMake((CGRectGetWidth(frame) - ACTIVITY_SIZE) / 2, 5.0, ACTIVITY_SIZE, ACTIVITY_SIZE);
        
        self.activityIndicator.hidesWhenStopped = YES;
        [self addSubview:self.activityIndicator];
        
    }
    return self;
}

-(void)dealloc {
    
}

@end
