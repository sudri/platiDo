//
//  InputUserRequestTextField.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 01.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "InputUserRequestTextField.h"
#import "UIColor+Additions.h"

@implementation InputUserRequestTextField{
      CGSize _viewsize;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self initElements];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initElements];
    }
    return self;
}

- (void)initElements{
    UIView *bottomBorder = [UIView new];
    [bottomBorder setFrame: CGRectMake(0.0f, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 0.5f)];
    bottomBorder.backgroundColor = [UIColor colorWithHex:0x9A9A9A];
    bottomBorder.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth ;
    [self addSubview:bottomBorder];
    
    self.borderStyle = UITextBorderStyleNone;
    self.backgroundColor = [UIColor clearColor];
    _viewsize = (CGSize) {20, 20};
}

//- (CGRect)rightViewRectForBounds:(CGRect)bounds{
//    NSLog(@"op");
//    CGRect rez = bounds;
//    rez.origin.x = CGRectGetMaxX(bounds) - _viewsize.width-5;
//    rez.size.width = _viewsize.width;
//    rez = CGRectInset(rez, 0, 5);
//    return rez;
//}

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    CGRect rez = bounds;
    rez.origin.x = 15;
    rez.size.width =  rez.size.width - _viewsize.width - 20;
    return rez;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rez = bounds;
    rez.origin.x = 15;
    rez.size.width =  rez.size.width - _viewsize.width - 20;
    return rez;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect rez = bounds;
    rez.origin.x = 15;
    rez.size.width =  rez.size.width - _viewsize.width - 20;
    return rez;
}

- (CGRect)rectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 0, 4);
}

@end
