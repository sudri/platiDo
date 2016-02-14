//
//  CustomButton.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 14.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "CustomButtonYellow.h"
#import "UIColor+Additions.h"

@implementation CustomButtonYellow

- (void)awakeFromNib{
    self.layer.cornerRadius = 2.5;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    [self setBackgroundImage:[UIColor imageWithColor:[UIColor colorWithHex:0xFFCA00 alpha:1]]
                    forState:UIControlStateNormal];
    
    [self setBackgroundImage:[UIColor imageWithColor:[UIColor colorWithHex:0xF8E28C alpha:0.8]]
                            forState:UIControlStateDisabled];
    
    self.layer.borderColor = [UIColor colorWithHex:0xD6C364].CGColor;
    self.layer.borderWidth = 0.5;
}

@end
