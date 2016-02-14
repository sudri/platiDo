




//
//  CustomCheckbox.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 01.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "CustomCheckbox.h"
@interface CustomCheckbox ()

@property (strong, nonatomic) UIImageView *image;
@end

@implementation CustomCheckbox
{
    BOOL _selected;
}

- (id)init{
    self = [super init];
    if (self){
        
        _selected = NO;
        [self createSubviews];
        [self addCustomConstraits];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (BOOL)isSelected{
    return _selected;
}

- (void)setSelected:(BOOL)selected{
     _selected = selected;
    [self.image setImage:[UIImage imageNamed:_selected?@"fillCheckbox":@"OvalCheckBox"]];
}

- (void)createSubviews{

    self.title = [[UILabel alloc] init];
    self.title.numberOfLines = 0;
    self.title.translatesAutoresizingMaskIntoConstraints = NO;
    self.title.font = [UIFont fontWithName:@"SFUIText-Light" size:15];
    [self.title setText:@""];
    [self addSubview:self.title];
    
    self.image = [[UIImageView alloc] init];
    self.image.translatesAutoresizingMaskIntoConstraints = NO;
    [self.image setImage:[UIImage imageNamed:@"OvalCheckBox"]];
    [self addSubview:self.image];

}

- (void)addCustomConstraits{
   
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.image
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:15]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.image
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
  
    
    
    [self.image addConstraint:[NSLayoutConstraint constraintWithItem:self.image
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1
                                                            constant:25]];
    
    [self.image addConstraint:[NSLayoutConstraint constraintWithItem:self.image
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1
                                                            constant:25]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.image
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.title
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:-5]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.title
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:-5]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.title
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:10]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.title
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.title
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:-10]];
}


@end
