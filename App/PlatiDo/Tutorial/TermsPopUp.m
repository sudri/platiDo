//
//  TermsPopUp.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 23.07.15.
//  Copyright (c) 2015 Valera Voroshilov. All rights reserved.
//

#import "TermsPopUp.h"
#import "CurrentUser.h"
#import "AppDelegate.h"
#import "RegistarationAPI.h"
#import "MBProgressHUD.h"


@interface TermsPopUp ()
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *formRoot;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;

@property (strong, nonatomic)  FormHelper *formHelper;
@end

@implementation TermsPopUp

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.formHelper = [[FormHelper alloc] init];
    [self.formHelper setScrollView:self.scrollView];
    [self.formHelper setScrollContentView:self.scrollContentView];
    [self.formHelper setRootView:self.view];
    [self.formHelper setFormView:self.formRoot];
    
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self.formHelper registerMe];
}

- (void)viewWillDisappear:(BOOL)animated{
   [self.formHelper unregisterMe];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UITextFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:textField];
}

- (void)checkFieldsValidation{
    if (self.password.text.length>0 &&
        self.password.text.length>0){
        [self.registerBtn setEnabled:YES];
    } else {
        [self.registerBtn setEnabled:NO];
    }
}

- (void)UITextFieldTextDidChange:(NSNotification*)notification{
    [self checkFieldsValidation];
}


- (IBAction)nextBtnPresse:(id)sender {
    [self.formHelper reset];
    NSDictionary *data = @{
                           @"password":self.password.text,
                           @"password_confirm":self.confirmPassword.text
                           };

    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    
    
    [RegistarationAPI userMePost:data token:[CurrentUserInstance tempToken] comBlock:^(NSDictionary *user, NSError *error) {
        if (error == nil){
            [CurrentUserInstance setToken:[user valueForKey:@"_auth_token"]];
            [CurrentUserInstance saveYourSelf];
            NSDictionary *dictionary = @{@"city":[CurrentUserInstance tempTownCode],
                                         @"street":[CurrentUserInstance street],
                                         @"building_number":[CurrentUserInstance building],
                                         @"building_part":[CurrentUserInstance partBuilding]};
            
            [RegistarationAPI userAddressValidation:dictionary
                                           comBlock:^(id responseObject, NSError *error) {
                                                         [MBProgressHUD  hideAllHUDsForView:self.view animated:YES];
                                                         if (error == nil){
                                                             [shareAppDelegate showMainMenu];
                                                         } else {
                                                          // some error
                                                         }
                                                     }];
        }

    }];
}


@end
