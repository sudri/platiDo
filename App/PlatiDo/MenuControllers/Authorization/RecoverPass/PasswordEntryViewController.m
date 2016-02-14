//
//  PasswordEntryViewController.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 24.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "PasswordEntryViewController.h"
#import "CurrentUser.h"
#import "FormHelper.h"
#import "AuthorizationAPI.h"
#import "AlertViewCustom.h"
#import "MBProgressHUD.h"

@interface PasswordEntryViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIView *bluredFormBgView;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *paswordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassField;
@property (strong, nonatomic) FormHelper *formHelper;
@end

@implementation PasswordEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formHelper = [[FormHelper alloc] init];
    [self.formHelper setScrollView:self.scrollView];
    [self.formHelper setScrollContentView:self.scrollContentView];
    [self.formHelper setRootView:self.view];
    [self.formHelper setFormView:self.bluredFormBgView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.formHelper registerMe];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.formHelper unregisterMe];
}

- (IBAction)nextBtnPressed:(id)sender {
    [self.formHelper reset];
    
    NSDictionary *dictionary = @{@"id":[CurrentUserInstance userId],
                                 @"phone":[CurrentUserInstance phoneNumber],
                                 @"verification_code":[CurrentUserInstance verificationCode],
                                 @"password":self.paswordField.text,
                                 @"password_confirm":self.confirmPassField.text};
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    [AuthorizationAPI recoverPass:dictionary comBlock:^(NSDictionary *user, NSError *error) {
        [MBProgressHUD  hideHUDForView:self.view animated:YES];
        if (error==nil){
            AlertViewCustom *alert = [[AlertViewCustom alloc] initCustomWithTitle:NSLocalizedString(@"Password refreshed", nil)
                                                                          message:NSLocalizedString(@"Use authorization", nil)
                                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)  otherButtonTitles:nil];
            [alert setCompletion:^(BOOL done, NSInteger idx) {
                _complitationBlock();
            }];
            [CurrentUserInstance setPinCode:@""];
            [CurrentUserInstance setIsPinEntryScreenShowed:NO];
            [alert performSelector:@selector(show) withObject:nil afterDelay:1.5];
        }
    }];
}

@end
