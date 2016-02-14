//
//  VoteItemsContainer.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 01.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "VoteItemsContainer.h"
#import "UIColor+Additions.h"

@interface VoteItemsContainer ()
@property (nonatomic, strong) NSLayoutConstraint *bottom;

@end

@implementation VoteItemsContainer

- (void)addItem:(UIView*)view{
    if (_items == nil){
        _items = [[NSMutableArray alloc] init];
    }
    
 
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel *numlabel = [[UILabel alloc] init];
    [numlabel setTextColor:[UIColor colorWithHex:0x0F2C86]];
    [self addSubview:view];
    if (self.isNumerate){
        numlabel.text= [NSString stringWithFormat:@"%d.",_items.count+1];
        [numlabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:view];

        
        numlabel.translatesAutoresizingMaskIntoConstraints = NO;
        numlabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:numlabel];
        
        [numlabel addConstraint:[NSLayoutConstraint constraintWithItem:numlabel
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1
                                                              constant:21]];
        
        [numlabel addConstraint:[NSLayoutConstraint constraintWithItem:numlabel
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeHeight
                                                            multiplier:1
                                                              constant:20]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:numlabel
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1
                                                          constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:numlabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:10]];// top offset property number
        
        
    }

    
    if (self.items.count>0){
        UIView *viewLast = [self.items lastObject];
        [self removeConstraint:self.bottom];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.isNumerate?numlabel:self
                                                         attribute:self.isNumerate?NSLayoutAttributeRight:NSLayoutAttributeLeft
                                                        multiplier:1
                                                          constant:0]];
     
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1
                                                          constant:0]];
        
        self.bottom = [NSLayoutConstraint constraintWithItem:view
                                                   attribute:NSLayoutAttributeBottom
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeBottom
                                                  multiplier:1
                                                    constant:0];
        
        [self addConstraint:self.bottom];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:viewLast
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:self.offsetItems]]; // offset property items
        
        
    } else  {
    
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.isNumerate?numlabel:self
                                                         attribute:self.isNumerate?NSLayoutAttributeRight:NSLayoutAttributeLeft
                                                        multiplier:1
                                                          constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1
                                                          constant:0]];
        
        self.bottom = [NSLayoutConstraint constraintWithItem:view
                                                   attribute:NSLayoutAttributeBottom
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeBottom
                                                  multiplier:1
                                                    constant:0];
        
        [self addConstraint:self.bottom];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:0]];
    }
    
    [self.items addObject:view];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)clear{
    for (UIView* subView in self.items){
        [subView removeFromSuperview];
    }
    [self.items removeAllObjects];
}

@end
