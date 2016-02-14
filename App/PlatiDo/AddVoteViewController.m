//
//  AddVoteViewController.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 03.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "AddVoteViewController.h"
#import "VoteItemsContainer.h"
#import "BigTextInputView.h"
#import "FormHelper.h"
#import "UIView+Additional.h"
#import "VoteEntity.h"
#import "PhotoCollectionViewDataSource.h"
#import "CustomInputView.h"
#import "VotesAPI.h"
#import "InputUserRequestTextField.h"
#import "MBProgressHUD.h"

@interface AddVoteViewController () <FormHelperProtocol, BigTextInputViewProtocol, UITextFieldDelegate, PhotoCollectionViewDataSourceProtocol, UIPickerViewDataSource, UIPickerViewDelegate, ToolbarDoneCancelProtocol>

@property (weak, nonatomic) IBOutlet BigTextInputView *voteTitleTextView;
@property (weak, nonatomic) IBOutlet UIButton *createVoteBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bluredFormBgView;
@property (weak, nonatomic) IBOutlet VoteItemsContainer *itemsContainer;
@property (weak, nonatomic) IBOutlet UITextField *timeLeftField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHconstrait;
@property (weak, nonatomic) IBOutlet UITextField *timeLimit;

@property (strong, nonatomic)  FormHelper *formHelper;
@property (strong, nonatomic)  NSArray *timePickerValues;
@property (strong, nonatomic)  CustomInputView *inputView;

@property (strong, nonatomic)  PhotoCollectionViewDataSource *photoDataSource;


@end

@implementation AddVoteViewController

- (IBAction)backBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self checkValidation];
    
     self.photoDataSource = [[PhotoCollectionViewDataSource alloc] initWithDelegate:self];
     self.collectionView.delegate =  self.photoDataSource;
     self.collectionView.dataSource =  self.photoDataSource;
    
    self.voteTitleTextView.delegate = self;
    
    self.formHelper = [[FormHelper alloc] init];
    self.formHelper.delegate = self;
    [self.formHelper setScrollView:self.scrollView];
    [self.formHelper setScrollContentView:self.scrollContentView];
    [self.formHelper setFormView:self.bluredFormBgView];
    [self.formHelper setRootView:self.view];
    
    self.itemsContainer.isNumerate = YES;
    self.voteTitleTextView.textView.placeholder = @"Ваш вопрос";
    self.voteTitleTextView.textView.text = @"";
    
    [self addVariant:self];
    [self addVariant:self];
    
    [self.scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize)) options:0 context:nil];
 
    
    self.inputView = [[CustomInputView alloc] initWithTarget:self];
    self.inputView.picker.delegate   = self;
    self.inputView.picker.dataSource = self;
    self.timeLeftField.inputView     = self.inputView;
    _timePickerValues = @[@"12", @"24", @"36", @"48"];
    [self.inputView.picker selectRow:0 inComponent:0 animated:NO];
    [self donePickerTapped:self];
    
    [self collectionViewSetVisible:NO];
}

- (void)collectionViewSetVisible:(BOOL)isVisible{
    self.collectionViewHconstrait.constant = isVisible? 60:0;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setNeedsDisplay];
        [self.view layoutIfNeeded];
    }];
}


- (IBAction)btnCreatePressed:(id)sender {
    VoteEntity *voteEntity = [VoteEntity  new];
    voteEntity.creationDate = [NSDate date];
    voteEntity.images = self.photoDataSource.attachmentImages;
    voteEntity.title = self.voteTitleTextView.textView.text;
    
    
    for (InputUserRequestTextField *variant in self.itemsContainer.items){
        [voteEntity.arrayVariants addObject:variant.text];
    }
    
   // [self.provider.items addObject:voteEntity];
    NSString *timeLeft = self.timePickerValues[[self.inputView.picker selectedRowInComponent:0]];
    

    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:voteEntity.arrayVariants options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    

    NSDictionary *parameters = @{@"title":voteEntity.title,
                                 @"questions":jsonString,
                                 @"expires_in":@([timeLeft integerValue]),
                                 @"images":self.photoDataSource.attachmentImages
                                 };
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    [VotesAPI createVote:parameters comBlock:^(BOOL sucess, NSError *error) {
        if (sucess){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}


- (void)changeTextBigTextInputView:(BigTextInputView*)textView{
    [self checkValidation];
}


- (void)checkValidation{
   self.createVoteBtn.enabled = NO;
    if (self.itemsContainer.items.count>=2){
        InputUserRequestTextField *var1 = self.itemsContainer.items[0];
        InputUserRequestTextField *var2 = self.itemsContainer.items[1];
        if (self.voteTitleTextView.textView.text>0 &&
            var1.text.length>0 &&
            var2.text.length>0 &&
            self.timeLeftField.text.length>0) {
            self.createVoteBtn.enabled = YES;
        }
    }
}


- (IBAction)addImageBtnPressed:(id)sender {
   [self.photoDataSource showPhotoFrom:self PickerwithComblock:^(UIImage *image) {
       NSLog(@"photo %@", image);
   }];
}

#pragma mark pickerView
- (void)donePickerTapped:(id)sender{
    NSInteger row  = [self.inputView.picker selectedRowInComponent:0];
    self.timeLeftField.text = [NSString stringWithFormat:@"%@ %@", _timePickerValues[row], NSLocalizedString(@"hours", nil)];
    [self.timeLeftField resignFirstResponder];
    [self checkValidation];
}


- (void)cancelPickerTapped:(id)sender{
    [self.timeLeftField resignFirstResponder];
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _timePickerValues.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@ %@", _timePickerValues[row], NSLocalizedString(@"hours", nil)];
}


- (void)viewWillAppear:(BOOL)animated{
    [self.voteTitleTextView becomeFirstResponder];
    [self.formHelper registerMe];
}

- (void)viewWillDisappear:(BOOL)animated{
     [self.formHelper unregisterMe];
}

- (void)dealloc{
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)didFinishEditingBigTextView:(BigTextInputView*)textView{
    [self checkValidation];
}

- (IBAction)addVariant:(id)sender {
    InputUserRequestTextField *item = [[InputUserRequestTextField alloc] initWithFrame:(CGRect){0,0,self.view.bounds.size.width, 35}];
    item.returnKeyType = UIReturnKeyDone;
    item.delegate = self;
    [item addConstraint:[NSLayoutConstraint constraintWithItem:item
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                       constant:35]];
  
    [self.itemsContainer addItem:item];
    
    for (InputUserRequestTextField *field in self.itemsContainer.items){
        field.returnKeyType = UIReturnKeyNext;
    }
    InputUserRequestTextField *fieldLast = [self.itemsContainer.items lastObject];
    fieldLast.returnKeyType = UIReturnKeyDone;
    
    item.placeholder = @"Вариант ответа";
    item.text = @"";
    [item becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger lengthLimit = 150;
 
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= lengthLimit;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSInteger index = [self.itemsContainer.items indexOfObject:textField];
    if (![[self.itemsContainer.items lastObject] isEqual:textField]){
      
        index++;
        InputUserRequestTextField *field = self.itemsContainer.items [index];
        [field becomeFirstResponder];
    } else {
        InputUserRequestTextField *field = self.itemsContainer.items [index];
        [field resignFirstResponder];
    }
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self checkValidation];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.scrollView && [keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
        [self.formHelper updateVisibleWithAnim:NO];
    }
}

- (UIView*)viewPreferToVisible {
    for (BigTextInputView *view in self.itemsContainer.items){
       UIView *result = [view findViewThatIsFirstResponder];
        if (result !=nil){
            return view;
        }
    }
    return nil;
}

@end
