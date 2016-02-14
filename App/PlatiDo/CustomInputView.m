//
//  ToolbarWithDoneCancelBtns.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 18.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "CustomInputView.h"


@implementation CustomInputView

- (id)initWithTarget:(id <ToolbarDoneCancelProtocol>)target{
    self = [super init];
    if (self){
        self.picker = [[UIPickerView alloc] init];
        [self.picker setShowsSelectionIndicator:YES];
        self.picker.backgroundColor = [UIColor whiteColor];
        
        self.toolBar = [UIToolbar ToolbarDoneCancelWithTarget:target];
        self.toolBar.userInteractionEnabled  = YES;
        [self setFrame:self.picker.bounds];
        [self addSubview:self.picker];
        [self addSubview:self.toolBar];
        
    }
    return self;
}

- (void)layoutSubviews{
    CGRect rect = self.picker.bounds;
    rect.size.width = self.superview.bounds.size.width;
    [self.picker setFrame:rect];
    [self.toolBar setFrame:(CGRect){0,0,CGRectGetWidth(self.superview.bounds), 44}];
}


@end
