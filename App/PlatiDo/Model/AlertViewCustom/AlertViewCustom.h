//
//  AlertView.h
//  CamOnRoad
//
//  Created by Valera Voroshilov on 11.07.14.
//  Copyright (c) 2014 Dmitry Doroschuk. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AlertViewCustom : UIAlertView

@property (copy, nonatomic) void (^completion)(BOOL isCancel, NSInteger btnIdx);

- (id)initCustomWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;

+ (void)userRequestSendSuccessfully;
+ (void)internetConnectionError;
+ (void)userRequestClosedSuccessfully;
+ (void)userReportsSendSuccessfully;
+ (void)errorReportsSend;

@end


