//
//  SendPhoneForPassViewController.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 24.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "SendPhoneForPassViewController.h"
#import "AuthorizationAPI.h"
#import "FormHelper.h"
#import "CurrentUser.h"
#import "MBProgressHUD.h"
#import "PhoneFormatter.h"


@interface SendPhoneForPassViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIView *bluredFormBgView;
@property (weak, nonatomic) IBOutlet UITextField *phonefield;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (strong, nonatomic) FormHelper *formHelper;
@end

@implementation SendPhoneForPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.formHelper = [[FormHelper alloc] init];
    [self.formHelper setScrollView:self.scrollView];
    [self.formHelper setScrollContentView:self.scrollContentView];
    [self.formHelper setRootView:self.view];
    [self.formHelper setFormView:self.bluredFormBgView];
     [self  checkFieldsValidation];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.formHelper registerMe];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.formHelper unregisterMe];
}


- (void)checkFieldsValidation{
    if (self.phonefield.text.length>0
        ){
        [self.nextBtn setEnabled:YES];
    } else {
        [self.nextBtn setEnabled:NO];
    }
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

- (void)UITextFieldTextDidChange:(NSNotification*)notification{
    [self checkFieldsValidation];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    if([textField isEqual:self.phonefield]) {
        if (range.length == 1) {
            textField.text = [PhoneFormatter formatPhoneNumber:totalString deleteLastChar:YES];
        } else {
            textField.text = [PhoneFormatter formatPhoneNumber:totalString deleteLastChar:NO ];
        }
        [self  checkFieldsValidation];
        return false;
    }
    
    return YES;
}



- (IBAction)nextBtnPressed:(id)sender {
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    NSString *phone = [NSString stringWithFormat:@"+7%@",self.phonefield.text];
    [AuthorizationAPI getRecoverPassCode:phone comBlock:^(NSDictionary *user, NSError *error) {
          [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error==nil){
               [CurrentUserInstance setPhoneNumber:phone];
               _complitationBlock();
        }
    }];
}

@end
