//
//  AddUserRequestViewController.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 31.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "AddUserRequestViewController.h"
#import "AddUserRequestApi.h"
#import "UserRequestTypeModel.h"
#import "UIPlaceHolderTextView.h"
#import "InputUserRequestTextField.h"
#import "AnimationModel.h"
#import "UIColor+Additions.h"
#import "MBProgressHUD.h"
#import "AlertViewCustom.h"
#import "UserRequestModel.h"
#import "PhotoCollectionViewDataSource.h"
#import "UIButton+Extensions.h"
#import "OwnershipHelper.h"
#import "FormHelper.h"
#import "CustomInputView.h"

#define MAXLENGTH_SUBJECT       100
#define MAXLENGTH_DESCRIPTION   500
#define COLLECTION_VIEW_NORMAL_HEIGHT 51.0

@interface AddUserRequestViewController ()<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, PhotoCollectionViewDataSourceProtocol, ToolbarDoneCancelProtocol>{
    NSArray         *_userRequestTypes;
    AnimationModel  *_animationModel;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHconstrait;

@property (weak, nonatomic) IBOutlet InputUserRequestTextField      *chooseRequestTypeTextField;
@property (weak, nonatomic) IBOutlet InputUserRequestTextField      *problemSubjectTextField;

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView          *problemDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton                       *sendProblemButton;

@property (strong, nonatomic) UserRequestTypeModel                  *selectedModel;

@property (weak, nonatomic) IBOutlet UICollectionView               *collectionView;
@property (strong, nonatomic) PhotoCollectionViewDataSource         *photoDataSource;


@property (strong, nonatomic)  FormHelper                           *formHelper;
@property (strong, nonatomic)  CustomInputView *inputView;
@end

@implementation AddUserRequestViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.formHelper = [[FormHelper alloc] init];
    [self.formHelper setScrollContentView:self.view];
    [self.formHelper setRootView:self.view];

    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"back"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(backVC)];
    
    
    self.photoDataSource            = [[PhotoCollectionViewDataSource alloc] initWithDelegate:self];
    self.collectionView.delegate    =  self.photoDataSource;
    self.collectionView.dataSource  =  self.photoDataSource;

    self.navigationItem.leftBarButtonItem = backButton;

    [self.problemDescriptionTextView setPlaceholder:NSLocalizedString(@"Input description of the problem", nil)];
    [self.problemDescriptionTextView setPlaceholderColor:[UIColor colorWithHex:0xCECECE]];
    [self.problemDescriptionTextView setBackgroundColor:[UIColor whiteColor]];
    
    _userRequestTypes = [[NSArray alloc]initWithArray:[UserRequestTypeModel getArrayOfUserRequestTypes]];
    self.selectedModel = nil;
    _animationModel = [[AnimationModel alloc] initWithViewsArray:@[self.problemSubjectTextField, self.chooseRequestTypeTextField]];
    

    self.inputView = [[CustomInputView alloc] initWithTarget:self];
    self.inputView.picker.delegate   = self;
    self.inputView.picker.dataSource = self;
    
    self.sendProblemButton.layer.cornerRadius = 3;
    self.sendProblemButton.clipsToBounds = YES;
    [self textFieldsStyles];
    
    //self.problemSubjectTextField.rightView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_image"]];
}



- (void)textFieldsStyles{
    
    self.chooseRequestTypeTextField.inputView = self.inputView;;
    
    self.chooseRequestTypeTextField.rightViewMode = UITextFieldViewModeAlways;
    self.chooseRequestTypeTextField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"textfield_rect"]];
    
    self.problemSubjectTextField.rightViewMode = UITextFieldViewModeAlways;
    
    UIButton *addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addImageButton setImage:[UIImage imageNamed:@"add_image"] forState:UIControlStateNormal];
    [addImageButton addTarget:self action:@selector(addImageBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [addImageButton setHitTestEdgeInsets:UIEdgeInsetsMake(-20, -20, -20, -20)];
    [addImageButton sizeToFit];
    
    self.problemSubjectTextField.rightView = addImageButton;

    self.collectionViewHconstrait.constant =  0;
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.formHelper registerMe];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.formHelper unregisterMe];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - PhotoCollectionViewDataSourceProtocol

- (void)collectionViewSetVisible:(BOOL)isVisible{
    
    self.collectionViewHconstrait.constant = isVisible ? COLLECTION_VIEW_NORMAL_HEIGHT : 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setNeedsDisplay];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - User Actions

- (void)addImageBtnPressed:(id)sender {
    [self.photoDataSource showPhotoFrom:self PickerwithComblock:^(UIImage *image) {
        NSLog(@"photo %@", image);
    }];
}

- (void)backVC{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)donePickerTapped:(id)sender{
    NSInteger row                           = [self.inputView.picker selectedRowInComponent:0];
    UserRequestTypeModel *urtModel          = _userRequestTypes[row];
    self.selectedModel                      = urtModel;
    self.chooseRequestTypeTextField.text    = urtModel.label;
    
    [self.chooseRequestTypeTextField resignFirstResponder];
    
}

- (void)cancelPickerTapped:(id)sender{
    [self.chooseRequestTypeTextField resignFirstResponder];
}

- (IBAction)sendProblemTapped:(id)sender {
    
    if (self.selectedModel == nil || [self.problemSubjectTextField.text length] < 6) {
        [_animationModel shakeTF];
    }else{
        NSString *descr = (self.problemDescriptionTextView.text > 0) ? self.problemDescriptionTextView.text : @"";
        NSDictionary *params = @{@"type"        : self.selectedModel.value,
                                 @"subject"     : self.problemSubjectTextField.text,
                                 @"description" : descr};
        
        [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
        [AddUserRequestApi addUserRequest:params comBlock:^(id responceObject, NSError *error) {
            [MBProgressHUD  hideHUDForView:self.view animated:YES];
            if (!error) {
                [self.problemSubjectTextField       setText:@""];
                [self.problemDescriptionTextView    setText:@""];
                [AlertViewCustom userRequestSendSuccessfully];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NEED_LIST_OF_USER_REQUESTS object:nil];
                
                [self performSelector:@selector(backVC) withObject:nil afterDelay:.5];
            }
#warning TODO: User Request errors processing
        }];
    }
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= MAXLENGTH_SUBJECT || returnKey;
}

#pragma mark - TextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return textView.text.length + (text.length - range.length) <= MAXLENGTH_DESCRIPTION;
}

#pragma mark pickerView data source

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _userRequestTypes.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    UserRequestTypeModel *urtModel = _userRequestTypes[row];
    return urtModel.label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
   
//    UserRequestTypeModel *urtModel          = _userRequestTypes[row];
//    self.selectedModel                      = urtModel;
//    self.chooseRequestTypeTextField.text    = urtModel.label;
//    
//    [self.chooseRequestTypeTextField resignFirstResponder];
}



@end
