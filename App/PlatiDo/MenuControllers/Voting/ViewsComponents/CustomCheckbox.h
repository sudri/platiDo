//
//  CustomCheckbox.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 01.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCheckbox : UIView

- (void)setSelected:(BOOL)selected;
@property (strong, nonatomic) UILabel *title;
@property (assign, nonatomic, readonly) BOOL isSelected;
@end
