//
//  UIStatusLabel.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 03.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "UIStatusLabel.h"

@implementation UIStatusLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 8, 0, 8};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    size.width  += 16;
    size.height += 16;
    return size;
}

@end
