//
//  ConfirmRightsViewController.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 13.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "ConfirmRightsViewController.h"
#import "ConfirmRightsAPI.h"
#import "FormHelper.h"
#import "MBProgressHUD.h"
#import "AlertViewCustom.h"
#import "CustomInputView.h"
#import "ErrorProcessing.h"

@interface ConfirmRightsViewController () <FormHelperProtocol>


@property (weak, nonatomic) IBOutlet UIView *formView;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *flatNumber;
@property (weak, nonatomic) IBOutlet UITextField *flatArea;
@property (strong, nonatomic)  FormHelper *formHelper;
@end

@implementation ConfirmRightsViewController


- (IBAction)nextBtnPressed:(id)sender {
    [self.formHelper reset];
    
    self.flatArea.text = [self.flatArea.text  stringByReplacingOccurrencesOfString:@"," withString:@"."];
    NSDictionary *params = @{@"apartment_number":@([self.flatNumber.text integerValue]),
                             @"apartment_area": @([self.flatArea.text floatValue])};
    
    
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    [ConfirmRightsAPI sendFlatInfo:params comblock:^(NSDictionary *responce, NSError *error) {
         [MBProgressHUD  hideHUDForView:self.view animated:YES];
         NSString *alertTitle = @"";
         NSString *alertMessage = @"";
        
        if (responce!=nil){
            if ([[responce valueForKey:@"_message"] isEqualToString:@"apartment_ownership_confirmed"]){
                CurrentUserInstance.ownershipStatus = OwnershipStatusConfirm;
                alertTitle = NSLocalizedString(@"Success", @"Успешно");
                alertMessage = NSLocalizedString(@"Appartment Confirmed", @"Квартира подтверждена");
            } else {
                CurrentUserInstance.ownershipStatus = OwnershipStatusNotconfirm;
                alertTitle = NSLocalizedString(@"Not Success", @"Не Успешно");
                alertMessage = NSLocalizedString(@"Appartment not confirm", @"Права НЕ подтверждены возможно ошибка сервиса");
            }
            
            AlertViewCustom *alert = [[AlertViewCustom alloc] initCustomWithTitle:alertTitle
                                                                          message:alertMessage
                                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)  otherButtonTitles:nil];
            [alert setCompletion:^(BOOL done, NSInteger idx) {
                if (self.completionBlock)
                {
                    self.completionBlock(CurrentUserInstance.ownershipStatus);
                }
            }];
            
            [alert show];
            
            [CurrentUserInstance saveYourSelf];
        } else {
          //  [[ErrorProcessing new] processError:error];
        }
    }];
    
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


- (void)checkFieldsValidation{
    self.btnNext.enabled = NO;
    
    if (self.flatNumber.text.length>0 &&
        self.flatArea.text.length>0) {
        self.btnNext.enabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.formHelper = [[FormHelper alloc] init];
    self.formHelper.delegate = self;
    [self.formHelper setScrollView:self.scrollView];
    [self.formHelper setScrollContentView:self.scrollContentView];
    [self.formHelper setRootView:self.view];
    [self.formHelper setFormView:self.formView];
  
    [self checkFieldsValidation];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.formHelper registerMe];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.formHelper unregisterMe];
}


@end
