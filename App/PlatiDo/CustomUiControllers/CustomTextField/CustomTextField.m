//
//  CustomTextField.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 14.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (void)awakeFromNib{
    self.borderStyle = UITextBorderStyleRoundedRect;
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.layer setBorderWidth:1.0];
    [self.layer setCornerRadius:2.0];
}
@end
