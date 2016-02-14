//
//  RegPageSecond.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 23.07.15.
//  Copyright (c) 2015 Valera Voroshilov. All rights reserved.
//

#import "RegPageSecond.h"
#import "ContainerViewController.h"
#import "UIView+Additional.h"
#import "UIColor+Additions.h"
#import "CurrentUser.h"
#import "AppDelegate.h"
#import "FormHelper.h"
#import "UIImageView+AFNetworking.h"
#import "RegistarationAPI.h"
#import "MBProgressHUD.h"
#import "AlertViewCustom.h"
#import "PhoneFormatter.h"


@interface RegPageSecond() <FormHelperProtocol>
@property (weak, nonatomic) IBOutlet UIView *companyBar;
// outlets
@property (weak, nonatomic) IBOutlet UIView *mainContentBackground;
@property (weak, nonatomic) IBOutlet UIImageView *yourCompanyImage;
@property (weak, nonatomic) IBOutlet UILabel *yourCompanyTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UILabel *mainContentBgTitle;


@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *surNameField;
@property (weak, nonatomic) IBOutlet UITextField *midNameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneBaseNumber;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel*warningMsgView;

// other
@property (strong, nonatomic) UIViewController *smsController;
@property (strong, nonatomic) NSArray *fields;
@property (strong, nonatomic) FormHelper *formHelper;
@end

@implementation RegPageSecond

- (void)viewDidLoad{
    [self initOtherData];
}


- (void)initOtherData{
    self.formHelper = [[FormHelper alloc] init];
    [self.formHelper setScrollView:self.scrollView];
    [self.formHelper setScrollContentView:self.scrollContentView];
    [self.formHelper setRootView:self.view];
    [self.formHelper setFormView:self.mainContentBackground];
    self.formHelper.delegate = self;
    
    UIStoryboard *storyboard  = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
    self.smsController = [storyboard instantiateViewControllerWithIdentifier:@"SmsRegistrationScreen"];
    self.fields = @[self.surNameField, self.nameField, self.midNameField, self.phoneBaseNumber];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    if([textField isEqual:self.phoneBaseNumber]) {
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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.yourCompanyImage setImage:nil];
    if ([CurrentUserInstance myCompany]!=nil){
        NSString *iconURL = [[CurrentUserInstance myCompany] valueForKey:@"icon"];
        [self.yourCompanyImage setImageWithURL:[NSURL URLWithString:iconURL]];
        [self.companyBar setHidden:NO];
        [self.warningMsgView setHidden:YES];
        self.mainContentBgTitle.text = @"Закончите регистрацию в";
    } else {
        self.mainContentBgTitle.text = @"Вы можете завершить регистрацию в системе и общаться с соседями по дому, пока мы ее подключаем:";
        [self.companyBar setHidden:YES];
        [self.warningMsgView setHidden:NO];
    }
    
    [self.formHelper registerMe];
}

- (void)viewWillDisappear:(BOOL)animated{
   [self.formHelper unregisterMe];
}


- (void)showSmsScreen:(BOOL)isShow {
    if (isShow){
        [self hideSubviews:YES];
        [self addChildViewController:self.smsController];
        [self.smsController didMoveToParentViewController:self];
        [self.smsController.view setFrame:self.view.bounds];
        [self.view addSubview:self.smsController.view];
    } else {
        [self hideSubviews:NO];
        [self.smsController removeFromParentViewController];
        [self.smsController didMoveToParentViewController:nil];
        [self.smsController.view removeFromSuperview];
    }
}


- (void) hideSubviews:(BOOL)isHide {
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * __nonnull obj, NSUInteger idx, BOOL * __nonnull stop) {
        [obj setHidden:isHide];
    }];
}


- (void) textFieldDidBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UITextFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:textField];
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:textField];
}

- (void) UITextFieldTextDidChange:(NSNotification*)notification{
    [self checkFieldsValidation];
}

- (void)checkFieldsValidation{

    if (self.phoneBaseNumber.text.length>0
        ){
        [self.nextBtn setEnabled:YES];
    } else {
        [self.nextBtn setEnabled:NO];
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

- (IBAction)cancelPressed:(id)sender {
    ContainerViewController *container = (ContainerViewController*)self.parentViewController;
    [container showPrevController];
}


- (IBAction)nextPressed:(id)sender {
    self.view.userInteractionEnabled = NO;
    [self.formHelper reset];

    NSDictionary *requestData = @{@"name":self.nameField.text ,
                                  @"surname":self.surNameField.text,
                                  @"mid_name":self.midNameField.text,
                                  @"phone":[NSString stringWithFormat:@"+7%@",self.phoneBaseNumber.text]};
    
    
    
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    [RegistarationAPI registerUserByData:requestData comBlock:^(NSDictionary *user, NSError *error) {
        
        [MBProgressHUD  hideAllHUDsForView:self.view animated:YES];

        if  (error==nil){
            CurrentUserInstance.name    = self.nameField.text;
            CurrentUserInstance.surname = self.surNameField.text;
            CurrentUserInstance.midName = self.midNameField.text;
            [CurrentUserInstance setPhoneNumber:[user valueForKey:@"phone"]];
            [CurrentUserInstance setUidUser:[user valueForKey:@"id"]];
            [CurrentUserInstance saveYourSelf];
             self.view.userInteractionEnabled = YES;
            [self.formHelper reset];
            [self showSmsScreen:YES];
            return ;
        }
   
        
        NSData *responseData = [error.userInfo valueForKey:@"com.alamofire.serialization.response.error.data"];
        
        NSString *myString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        if ([myString rangeOfString:@"phone_already_registered"].location != NSNotFound) {
            [CurrentUserInstance setPhoneNumber:[NSString stringWithFormat:@"+7%@",self.phoneBaseNumber.text]];
           
            AlertViewCustom *alert = [[AlertViewCustom alloc] initCustomWithTitle:NSLocalizedString(@"User already exist", nil)
                                                                          message:NSLocalizedString(@"Use authorization", nil)
                                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)  otherButtonTitles:nil];
            [alert setCompletion:^(BOOL done, NSInteger idx) {
                [shareAppDelegate showAuthorization];
            }];
            
            [alert show];
            return;
        }
        
    }];
}

@end
