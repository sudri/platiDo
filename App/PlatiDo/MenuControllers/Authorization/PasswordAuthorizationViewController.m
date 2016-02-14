//
//  PasswordAuthorizationScreenViewController.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 22.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "PasswordAuthorizationViewController.h"
#import "FormHelper.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "CurrentUser.h"
#import "UIColor+Additions.h"
#import "AuthorizationAPI.h"
#import "RegistarationAPI.h"
#import "PhoneFormatter.h"

@interface PasswordAuthorizationViewController ()

//outlets
@property (weak, nonatomic)     IBOutlet UIView *bgView;
@property (weak, nonatomic)     IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic)     IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic)     IBOutlet UIView *scrollContentView;
@property (weak, nonatomic)     IBOutlet UIView *bluredFormBgView;

@property (weak, nonatomic)     IBOutlet UITextField *phoneField;
@property (weak, nonatomic)     IBOutlet UITextField *passwordField;
@property (weak, nonatomic)     IBOutlet UIButton    *btnNext;

//other
@property (strong, nonatomic)  NSArray *fields;
@property (strong, nonatomic)  FormHelper *formHelper;
@property (strong, nonatomic)  JKLLockScreenViewController *pinScreen;
@end

@implementation PasswordAuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.formHelper = [[FormHelper alloc] init];
    [self.formHelper setScrollView:self.scrollView];
    [self.formHelper setScrollContentView:self.scrollContentView];
    [self.formHelper setRootView:self.view];
    [self.formHelper setFormView:self.bluredFormBgView];

    self.fields = @[self.phoneField, self.passwordField];
    
    [self hideSubviews:YES];
    [self checkPinOrAuth];
}

- (void)checkPinOrAuth{
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    [RegistarationAPI userMeGetComBlock:^(NSDictionary *user, NSError *error) {
        [MBProgressHUD  hideHUDForView:self.view animated:YES];
       
        if (error==nil){
            [CurrentUserInstance refreshUserWithDictionary:user];
            if ([CurrentUserInstance pinCode].length>0) {
                [self showVerifyScreenPin];
                return;
            }
        }
        [self showAuth];
    }];
}

- (void)showNewScreenPin{
    self.pinScreen = [[JKLLockScreenViewController alloc] initWithNibName:NSStringFromClass([JKLLockScreenViewController class]) bundle:nil];
    [self.pinScreen setDelegate:self];
    [self.pinScreen setDataSource:self];
    if (self.pinScreen.parentViewController==nil){
        self.pinScreen.titleLabelText  = @"Быстаря авторизация";
        self.pinScreen.detailLabelText = @"Задайте 4 х значный ПИН для быстрого доступа";
        self.pinScreen.cancelBtnText   = @"Не сейчас";
        [self.pinScreen updateTitles];
        [self hideSubviews:YES];
        [self.pinScreen setLockScreenMode:LockScreenModeNew];
        [self showViewController:self.pinScreen];
    }
}

- (void)showVerifyScreenPin{
    self.pinScreen = [[JKLLockScreenViewController alloc] initWithNibName:NSStringFromClass([JKLLockScreenViewController class]) bundle:nil];
    [self.pinScreen setDelegate:self];
    [self.pinScreen setDataSource:self];
    if ( self.pinScreen.parentViewController==nil){
        [self hideSubviews:YES];
        self.pinScreen.titleLabelText = NSLocalizedString(@"Quick access", nil);
        self.pinScreen.detailLabelText = @"";
        [self.pinScreen updateTitles];
        [self.pinScreen setLockScreenMode:LockScreenModeNormal];
        [self showViewController:self.pinScreen];
    }
}


////
// задали пин код
- (void)unlockWasSuccessfulLockScreenViewController:(JKLLockScreenViewController *)lockScreenViewController pincode:(NSString *)pincode {
    [self removeViewController:self.pinScreen];
    [CurrentUserInstance setIsPinEntryScreenShowed:YES];
    [CurrentUserInstance setPinCode:pincode];
    [CurrentUserInstance saveYourSelf];
    [shareAppDelegate showMainMenu];
}

// отмена задания пароля
- (void)unlockWasCancelledLockScreenViewController:(JKLLockScreenViewController *)lockScreenViewController{
    [CurrentUserInstance setIsPinEntryScreenShowed:YES];
    [shareAppDelegate showMainMenu];
}

// переход к авторизации
- (void)unlockWasRequestLoginAuthViewController:(JKLLockScreenViewController *)lockScreenViewController{
    [self showAuth];
    [CurrentUserInstance setIsPinEntryScreenShowed:YES];
}

- (void)unlockWasFailureLockScreenViewController:(JKLLockScreenViewController *)lockScreenViewController{
    [self showAuth];
    [CurrentUserInstance setIsPinEntryScreenShowed:YES];
}

// пытался разлочить с таким пин кодом
- (BOOL)lockScreenViewController:(JKLLockScreenViewController *)lockScreenViewController pincode:(NSString *)pincode {
    return [[CurrentUserInstance pinCode] isEqualToString:pincode];
}

- (void)hideSubviews:(BOOL)isHide {
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * __nonnull obj, NSUInteger idx, BOOL * __nonnull stop) {
     
        [obj setHidden:isHide];
        [self.bgImageView setHidden:NO];
    }];
}

- (void)showViewController:(UIViewController*)controller {
    [controller.view setFrame:self.view.bounds];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    [self.view addSubview:controller.view];
}

- (void)removeViewController:(UIViewController*)controller {
    [controller removeFromParentViewController];
    [controller didMoveToParentViewController:nil];
    [controller.view removeFromSuperview];
}

- (void)showAuth{
    [self removeViewController:self.pinScreen];
    [self hideSubviews:NO];
 
    self.phoneField.text = CurrentUserInstance.phoneNumberShort;

}

- (void)viewWillAppear:(BOOL)animated {
   [self.formHelper registerMe];
}

- (void)viewWillDisappear:(BOOL)animated {
   [self.formHelper unregisterMe];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    if([textField isEqual:self.phoneField]) {
        if (range.length == 1) {
            self.phoneField.text = [PhoneFormatter formatPhoneNumber:totalString deleteLastChar:YES];
        } else {
            self.phoneField.text = [PhoneFormatter formatPhoneNumber:totalString deleteLastChar:NO ];
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
    if (self.phoneField.text.length>0 &&
        self.passwordField.text.length>0 ){
        [self.btnNext setEnabled:YES];
    } else {
        [self.btnNext setEnabled:NO];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:[self.fields lastObject]]){
        [textField resignFirstResponder];
    } else {
        NSInteger idx = [self.fields indexOfObject:textField];
        if (idx+1<self.fields.count){
            [self.fields[idx+1]  becomeFirstResponder];
        }
    }
    return YES;
}


- (IBAction)nextBtnPressed:(id)sender {
    [self.formHelper reset];
    
    NSString *phone = [NSString stringWithFormat:@"+7%@",self.phoneField.text];
    NSDictionary *params = @{ @"phone": phone,
                              @"password": self.passwordField.text
                            };
    
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    [AuthorizationAPI authUser:params comBlock:^(NSDictionary *user, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error==nil) {
            //[CurrentUserInstance resetUser];
            [CurrentUserInstance refreshUserWithDictionary:user];
            
//            [CurrentUserInstance setToken:[user valueForKey:@"_auth_token"]];
//            [CurrentUserInstance setName:[user valueForKey:@"name"]];
//            [CurrentUserInstance setSurname:[user valueForKey:@"surname"]];
//            [CurrentUserInstance setMidName:[user valueForKey:@"mid_name"]];
//            [CurrentUserInstance setPhoneNumber:[user valueForKey:@"phone"]];
//            
//            [CurrentUserInstance setTown:[user valueForKey:@"city"]];
//            [CurrentUserInstance setStreet:[user valueForKey:@"street"]];
//            [CurrentUserInstance setBuilding:[user valueForKey:@"building_number"]];
//            [CurrentUserInstance setPartBuilding:[user valueForKey:@"building_part"]];
//            [CurrentUserInstance setOwnershipStatus:[[user valueForKey:@"is_ownership_confirmed"] intValue]];
            
            [CurrentUserInstance saveYourSelf];
            
            if (![CurrentUserInstance isPinEntryScreenShowed]){
                [self showNewScreenPin];
            } else {
                [shareAppDelegate showMainMenu];
            }
        }
    }];
}


- (IBAction)registerPressed:(id)sender {
     [shareAppDelegate showTutorial];
}

@end
