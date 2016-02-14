//
//  CustomButtonOpaque.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 30.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "CustomButtonOpaque.h"

@implementation CustomButtonOpaque
- (void)awakeFromNib{

    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    
    [self setBackgroundImage:[[UIImage imageNamed:@"frameBtn"]
                              resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 10)]
                    forState:UIControlStateNormal];
}

@end
