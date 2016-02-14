//
//  UIToolbar+ToolbarTextfield.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 18.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolbarDoneCancelProtocol <NSObject>
- (void)donePickerTapped:(id)sender;
- (void)cancelPickerTapped:(id)sender;
@end

@interface UIToolbar (ToolbarTextfield)
+ (id)ToolbarDoneCancelWithTarget:(id <ToolbarDoneCancelProtocol>)target;
@end
