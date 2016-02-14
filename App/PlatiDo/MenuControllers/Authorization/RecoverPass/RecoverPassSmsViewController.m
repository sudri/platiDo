//
//  RecoverPassSmsViewController.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 24.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "RecoverPassSmsViewController.h"
#import "FormHelper.h"
#import "CurrentUser.h"
#import "AuthorizationAPI.h"
#import "MBProgressHUD.h"
#import "PhoneFormatter.h"

@interface RecoverPassSmsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIView *bluredFormBgView;

@property (weak, nonatomic) IBOutlet UITextField *smsTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (strong, nonatomic) FormHelper *formHelper;
@end

@implementation RecoverPassSmsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.formHelper = [[FormHelper alloc] init];
    [self.formHelper setScrollView:self.scrollView];
    [self.formHelper setScrollContentView:self.scrollContentView];
    [self.formHelper setRootView:self.view];
    [self.formHelper setFormView:self.bluredFormBgView];
    [self checkFieldsValidation];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.formHelper registerMe];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.formHelper unregisterMe];
}

- (void)checkFieldsValidation{
    if (self.smsTextField.text.length>0){
        [self.nextBtn setEnabled:YES];
    } else {
        [self.nextBtn setEnabled:NO];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    if([textField isEqual:self.smsTextField]) {
        if (range.length == 1) {
            textField.text = [PhoneFormatter formatSMSNumber:totalString deleteLastChar:YES];
        } else {
            textField.text = [PhoneFormatter formatSMSNumber:totalString deleteLastChar:NO];
        }
        [self  checkFieldsValidation];
        return false;
    }
    
    return YES;
}

- (IBAction)nextBtnPressed:(id)sender {
    NSDictionary *params = @{@"phone":[CurrentUserInstance phoneNumber],
                             @"verification_code":self.smsTextField.text};
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    
    [AuthorizationAPI verifySMSCodeToRecover:params comBlock:^(NSString *userId, NSError *error) {
        [MBProgressHUD  hideHUDForView:self.view animated:YES];
        
        if (error==nil) {
            [CurrentUserInstance setUserId:userId];
            [CurrentUserInstance setVerificationCode:self.smsTextField.text];
           _complitationBlock();
        }
    }];
}

@end
