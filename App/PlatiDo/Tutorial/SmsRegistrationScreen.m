//
//  SmsRegistrationScreen.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 19.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "SmsRegistrationScreen.h"
#import "UIView+Additional.h"
#import "UIColor+Additions.h"
#import "RegistarationAPI.h"
#import "CurrentUser.h"
#import "TermsPopUp.h"
#import "MBProgressHUD.h"
#import "RegPageSecond.h"
#import "PhoneFormatter.h"

@interface SmsRegistrationScreen () <FormHelperProtocol>
@property (weak, nonatomic) IBOutlet UIView *mainContentBackground;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *smsField;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIButton *sendSmsAgainBtn;

@property (strong, nonatomic) TermsPopUp *termsAlert;
@property (strong, nonatomic) FormHelper *formHelper;
@end

@implementation SmsRegistrationScreen

- (void)viewDidLoad{
    [self initOtherData];
    [self startTimerToEnableSMSRequest];
}

- (void)startTimerToEnableSMSRequest{
     self.sendSmsAgainBtn.enabled = NO;
    [NSTimer scheduledTimerWithTimeInterval:10
                                     target:self
                                   selector:@selector(setCanRequestSms)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)setCanRequestSms{
    self.sendSmsAgainBtn.enabled = YES;
}

- (IBAction)sendAgainPressed:(id)sender {
    [self startTimerToEnableSMSRequest];
    
    [self.formHelper reset];
    
    NSDictionary *requestData =  @{@"id":[CurrentUserInstance uidUser],
                                   @"phone":[CurrentUserInstance phoneNumber],
                                   @"verification_code":@"0000"};
    
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    [RegistarationAPI verifyUser:requestData ComBlock:^(NSDictionary *user, NSError *error) {
        [MBProgressHUD  hideAllHUDsForView:self.view animated:YES];
    }];
}


- (void)initOtherData{
    
    self.formHelper = [[FormHelper alloc] init];
    [self.formHelper setScrollView:self.scrollView];
    [self.formHelper setScrollContentView:self.scrollContentView];
    [self.formHelper setRootView:self.view];
    [self.formHelper setFormView:self.mainContentBackground];
    self.formHelper.delegate = self;
    
    UIStoryboard *sb  = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
    self.termsAlert   = [sb instantiateViewControllerWithIdentifier:@"TermsPopUp"];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    if([textField isEqual:self.smsField]) {
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
    if (self.smsField.text.length>0){
        [self.nextBtn setEnabled:YES];
    } else {
        [self.nextBtn setEnabled:NO];
    }
}


- (IBAction)nextPressed:(id)sender {
    [self.formHelper reset];
    
    NSDictionary *requestData =  @{@"id":[CurrentUserInstance uidUser],
                                   @"phone":[CurrentUserInstance phoneNumber],
                                   @"verification_code":self.smsField.text};
    
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    [RegistarationAPI verifyUser:requestData ComBlock:^(NSDictionary *user, NSError *error) {
        [MBProgressHUD  hideAllHUDsForView:self.view animated:YES];
        if (error==nil){
            [self hideSubviews:YES];
            
            [CurrentUserInstance setTempToken:[user valueForKey:@"_temp_token"]];
            [CurrentUserInstance saveYourSelf];
            
            __weak typeof (self) weakSelf= self;
            [self.termsAlert setComplitationBlock:^{
                 [weakSelf hideSubviews:NO];
            }];
   
            [self addChildViewController:self.termsAlert];
            [self.termsAlert didMoveToParentViewController:self];
            [self.view addSubview:self.termsAlert.view];
            
        } else {
           [self.smsField shakeAnimation];
        }
    }];
}

- (void)hideSubviews:(BOOL)isHide{
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * __nonnull obj, NSUInteger idx, BOOL * __nonnull stop) {
        [obj setHidden:isHide];
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.formHelper reset];
    [self.formHelper registerMe];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.formHelper unregisterMe];
}


@end
