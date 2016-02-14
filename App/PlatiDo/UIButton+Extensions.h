//
//  UIButton+Extensions.h
//  CamOnRoad
//
//  Created by Valera Voroshilov on 18.07.14.
//  Copyright (c) 2014 Dmitry Doroschuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extensions)

@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;
- (UIImage*)fillImage:(UIImage*)image withColor:(UIColor*)color;
- (void)fillBtnbyColor:(UIColor*)color;
@end
