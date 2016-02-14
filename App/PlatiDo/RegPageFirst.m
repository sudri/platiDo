//
//  RegPageFirst.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 21.07.15.
//  Copyright (c) 2015 Valera Voroshilov. All rights reserved.
//

#import "RegPageFirst.h"
#import "ContainerViewController.h"
#import "UIView+Additional.h"
#import "UIColor+Additions.h"
#import "RegistarationAPI.h"
#import "SearchPlaceController.h"
#import "CurrentUser.h"
#import "FormHelper.h"
#import "MBProgressHUD.h"
#import "PhoneFormatter.h"
#import "AppDelegate.h"
#import "CustomInputView.h"

@interface RegPageFirst () <ToolbarDoneCancelProtocol>

@property (weak, nonatomic)     IBOutlet UIView *contentView;
@property (weak, nonatomic)     IBOutlet UIView *mainContentBackground;
@property (weak, nonatomic)     IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic)     IBOutlet UITextField  *cityTxtField;
@property (weak, nonatomic)     IBOutlet UIView *streetPopUpView;
@property (weak, nonatomic)     IBOutlet UILabel *streetLabel;
@property (weak, nonatomic)     IBOutlet UITextField *homeTxtField;
@property (weak, nonatomic)     IBOutlet UITextField *partTextField;
@property (weak, nonatomic)     IBOutlet UIButton *btnNext;

//other
@property (strong, nonatomic)  NSArray *fields;
@property (strong, nonatomic)  NSDictionary *selectedCity;
@property (strong, nonatomic)  NSArray *cities;
@property (strong, nonatomic)  SearchPlaceController *searchController;
@property (strong, nonatomic)  FormHelper *formHelper;
@property (strong, nonatomic)  CustomInputView *inputView;
@end

@implementation RegPageFirst

#pragma mark View Controller Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeViews];
    [self initOtherData];
    [self checkFieldsValidation];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.formHelper registerMe];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.formHelper unregisterMe];
}


#pragma customize views
- (void)initOtherData{
    
    self.formHelper = [[FormHelper alloc] init];
    [self.formHelper setScrollView:self.scrollView];
    [self.formHelper setScrollContentView:self.contentView];
    [self.formHelper setRootView:self.view];
    [self.formHelper setFormView:self.mainContentBackground];
    self.formHelper.delegate = self;
    
    self.fields = @[self.cityTxtField, self.homeTxtField, self.partTextField];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
    self.searchController = [storyboard instantiateViewControllerWithIdentifier:@"SearchPlaceController"];
    
    self.inputView = [[CustomInputView alloc] initWithTarget:self];
    self.inputView.picker.delegate   = self;
    self.inputView.picker.dataSource = self;
    self.cityTxtField.inputView = self.inputView;

    
    [self.cityTxtField setEnabled:NO];
    [RegistarationAPI getCitiezComBlock:^(NSArray *objects, NSError *error) {
        [self.cityTxtField setEnabled:YES];
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:@[@{@"label":@" ",
                                                                          @"value":@"empty"}]];
        [array addObjectsFromArray:objects];
         self.cities = array;
        [self.inputView.picker reloadAllComponents];
    }];
}


- (void)customizeViews{
    [self.streetPopUpView.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.streetPopUpView.layer setBorderWidth:1.0];
    [self.streetPopUpView.layer setCornerRadius:2.0];
}


#pragma mark pickerView data source
- (void)donePickerTapped:(id)sender{
    NSInteger row = [self.inputView.picker selectedRowInComponent:0];
    
    NSDictionary *cityInfo = self.cities[row];
    self.selectedCity      = cityInfo;
    self.cityTxtField.text = [cityInfo valueForKey:@"label"];
    [self.cityTxtField resignFirstResponder];
    [self checkFieldsValidation];
    [self.cityTxtField resignFirstResponder];
}

- (void)cancelPickerTapped:(id)sender{
    [self.cityTxtField resignFirstResponder];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.cities.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *city = self.cities[row];
    return [city valueForKey:@"label"];
}

- (void)userDidFinishSelectCity:(NSTimer*)timer{
     NSDictionary *cityInfo = [timer.userInfo valueForKey:@"selectedCity"];
    
    self.selectedCity      = cityInfo;
    self.cityTxtField.text = [cityInfo valueForKey:@"label"];
    [self.cityTxtField resignFirstResponder];
    [self checkFieldsValidation];
}

#pragma mark fields editing

- (void)checkFieldsValidation{
    if (self.cityTxtField.text.length>0 &&
        ![self.streetLabel.text isEqualToString:NSLocalizedString(@"Street", nil)] &&
        self.homeTxtField.text.length>0
        ){
        [self.btnNext setEnabled:YES];
    } else {
        [self.btnNext setEnabled:NO];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    if([textField isEqual:self.homeTxtField]) {
        if (range.length == 1) {
            textField.text = [PhoneFormatter formatBuildNumber:totalString deleteLastChar:YES];
        } else {
            textField.text = [PhoneFormatter formatBuildNumber:totalString deleteLastChar:NO ];
        }
        [self  checkFieldsValidation];
        return false;
    }
    
    if([textField isEqual:self.partTextField]) {
        if (range.length == 1) {
            textField.text = [PhoneFormatter formatPartNumber:totalString deleteLastChar:YES];
        } else {
            textField.text = [PhoneFormatter formatPartNumber:totalString deleteLastChar:NO ];
        }
        [self  checkFieldsValidation];
        return false;
    }
    
    return YES;
}


#pragma mark Actions
- (IBAction)alreadyRegisteredBtnPressed:(id)sender {
    [shareAppDelegate showAuthorization];
}


- (IBAction)showStretList:(id)sender {
    [self.formHelper reset];
    __weak typeof(self) weakSelf = self;
    [self.searchController setComplitationBlock:^(NSString *street) {
        if (street.length>0){
            weakSelf.streetLabel.text = street;
            [weakSelf.streetLabel setTextColor:[UIColor blackColor]];
        } else {
            weakSelf.streetLabel.text = NSLocalizedString(@"Street", nil);
            [weakSelf.streetLabel setTextColor:[UIColor lightGrayColor]];
        }
        [weakSelf checkFieldsValidation];
    }];
    
    [self presentViewController:self.searchController animated:YES completion:nil];
}


- (IBAction)nextBtnPressed:(id)sender {
    [self.formHelper reset];
    NSDictionary *parameters = @{
                                 @"city":[self.selectedCity valueForKey:@"value"],
                                 @"street": self.streetLabel.text,
                                 @"building_number": self.homeTxtField.text,
                                 @"building_part": self.partTextField.text
                                 };
    
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];

    [RegistarationAPI getCompanyByAdress:parameters ComBlock:^(NSDictionary *company, NSError *error) {
        
        [CurrentUserInstance resetUser];
        
        [CurrentUserInstance setTown:[self.selectedCity valueForKey:@"label"]];
        [CurrentUserInstance setTempTownCode:[self.selectedCity valueForKey:@"value"]];
        [CurrentUserInstance setStreet:self.streetLabel.text];
        [CurrentUserInstance setBuilding:self.homeTxtField.text];
        [CurrentUserInstance setPartBuilding:self.partTextField.text];
   
        [MBProgressHUD  hideAllHUDsForView:self.view animated:YES];
        if (error==nil){
            [[CurrentUser sharedInstance] setMyCompany:company];
        } else {
            [[CurrentUser sharedInstance] setMyCompany:nil];
        }
        
        ContainerViewController *container = (ContainerViewController*)self.parentViewController;
        [container showNextController];
    }];
}
@end
