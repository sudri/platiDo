//
//  ToolbarWithDoneCancelBtns.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 18.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIToolbar+ToolbarTextfield.h"



@interface CustomInputView : UIView
- (id)initWithTarget:(id <ToolbarDoneCancelProtocol>)target;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIToolbar    *toolBar;
@end
