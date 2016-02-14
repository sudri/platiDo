//
//  RateView.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 07.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "RateView.h"

@implementation RateView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

-(void)awakeFromNib{
    
    self.currentRating = 0;
    for (int i = 0; i < self.stars.count; i++) {
        UIButton *currentStar = self.stars[i];
        [currentStar setAdjustsImageWhenHighlighted:NO];
    }

}

- (IBAction)starTapped:(id)sender {
    
    UIButton *star      = (UIButton *)sender;
    self.currentRating  = star.tag;
    
    for (int i = 0; i < self.stars.count; i++) {
        if (i < star.tag) {
            UIButton *currentStar = self.stars[i];
            [currentStar setBackgroundImage:[UIImage imageNamed:@"star_full"] forState:UIControlStateNormal];
        }
        else{
        
            UIButton *currentStar = self.stars[i];
            [currentStar setBackgroundImage:[UIImage imageNamed:@"star_empty"] forState:UIControlStateNormal];

        }
    }
}

@end
