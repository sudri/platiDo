//
//  AlertView.m
//  CamOnRoad
//
//  Created by Valera Voroshilov on 11.07.14.
//  Copyright (c) 2014 Dmitry Doroschuk. All rights reserved.
//

#import "AlertViewCustom.h"

@implementation AlertViewCustom

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
    }
    return self;
}

- (id)initCustomWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
    
    self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    
    if (self) {
        for (NSString *buttonTitle in otherButtonTitles) {
            [self addButtonWithTitle:buttonTitle];
        }
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (self.completion) {
        self.completion(buttonIndex==self.cancelButtonIndex, buttonIndex);
        self.completion = nil;
    }
}

+ (void)internetConnectionError{
    NSString *title     = NSLocalizedString(@"Error", nil);
    NSString *message   = NSLocalizedString(@"Internet connection error", nil);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                              otherButtonTitles:nil];
    [alertView show];
}

+ (void)userRequestSendSuccessfully{

    NSString *title     = NSLocalizedString(@"Success", nil);
    NSString *message   = NSLocalizedString(@"Your request successfully sended", nil);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                              otherButtonTitles:nil];
    [alertView show];
}

+ (void)userRequestClosedSuccessfully{
    
    NSString *title     = NSLocalizedString(@"Success", nil);
    NSString *message   = NSLocalizedString(@"Your request successfully closed", nil);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                              otherButtonTitles:nil];
    [alertView show];
}

+ (void)userReportsSendSuccessfully{
    
    NSString *title     = NSLocalizedString(@"Success", nil);
    NSString *message   = NSLocalizedString(@"Your reports successfully sended", nil);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                              otherButtonTitles:nil];
    [alertView show];
    
}

+ (void)errorReportsSend{
    
    NSString *title     = NSLocalizedString(@"Error", nil);
    NSString *message   = NSLocalizedString(@"You need to input all counters report", nil);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                              otherButtonTitles:nil];
    [alertView show];
    
}

@end
