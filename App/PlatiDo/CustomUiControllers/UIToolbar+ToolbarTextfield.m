//
//  UIToolbar+ToolbarTextfield.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 18.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "UIToolbar+ToolbarTextfield.h"

@implementation UIToolbar (ToolbarTextfield)
+ (id)ToolbarDoneCancelWithTarget:(NSObject*)target{
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,200,44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *barButtonDone      = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil)
                                                                           style:UIBarButtonItemStylePlain target:target action:@selector(donePickerTapped:)];
    
    UIBarButtonItem *barButtonCancel    = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                           style:UIBarButtonItemStylePlain target:target action:@selector(cancelPickerTapped:)];
    
    UIBarButtonItem* flexSpace          = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                         target:nil action:nil];
    barButtonDone.tintColor     = [UIColor redColor];
    barButtonCancel.tintColor   = [UIColor redColor];
    
    [toolBar setItems:[NSArray arrayWithObjects:barButtonCancel, flexSpace, barButtonDone, nil] animated:YES];
    return toolBar;
}
@end
