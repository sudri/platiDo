//
//  RatingViewController.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 07.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "RatingViewController.h"
#import "UserRequestModel.h"

#import "RateView.h"

#import "AddUserRequestApi.h"
#import "InputUserRequestTextField.h"
#import "UIColor+Additions.h"
#import "MBProgressHUD.h"

#define MAXLENGTH_DESCRIPTION 250

@interface RatingViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet RateView                       *ratingView;
@property (weak, nonatomic) IBOutlet UIView                         *contentView;

@property (weak, nonatomic) IBOutlet UIImageView                    *blurredImageView;

@property (weak, nonatomic) IBOutlet InputUserRequestTextField      *commentTextField;
@property (weak, nonatomic) IBOutlet UIButton                       *closeRequestButton;
@property (weak, nonatomic) IBOutlet UIButton                       *cancelButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint             *popupVerticalAligmentConstrit;

@end

@implementation RatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

    self.contentView.layer.borderColor = [UIColor colorWithHex:0xAAAAAA].CGColor;
    self.contentView.layer.borderWidth = 0.5f;
    self.contentView.layer.cornerRadius = 3;
    self.contentView.layer.masksToBounds = YES;

    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.contentView.bounds];
    self.contentView.layer.masksToBounds = NO;
    self.contentView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    self.contentView.layer.shadowOpacity = 0.3f;
    self.contentView.layer.shadowPath = shadowPath.CGPath;

    self.closeRequestButton.layer.cornerRadius = 3;
    self.closeRequestButton.clipsToBounds = YES;

    [[UITextField appearance] setTintColor:[UIColor darkGrayColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - Setters

-(void)setCurrentUserRequestModel:(UserRequestModel *)currentUserRequestModel{

    _currentUserRequestModel = currentUserRequestModel;
}

- (void)setBlurredImage:(UIImage *)blurredImage{
    _blurredImage = blurredImage;
    self.blurredImageView.image = _blurredImage;
}

#pragma mark - User Actions

- (IBAction)closeRequestTapped:(id)sender {
    
    NSString *review = (self.commentTextField.text.length > 0) ? self.commentTextField.text : @"";
    
    NSDictionary *dict = @{@"id"        : [_currentUserRequestModel.reqId stringValue],
                           @"rating"    : [NSString stringWithFormat:@"%lu", (unsigned long)self.ratingView.currentRating],
                           @"review"    : review};
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];

    [AddUserRequestApi closeUserRequest:dict comBlock:^(id responseObject, NSError *error) {
        [MBProgressHUD  hideHUDForView:self.view animated:YES];
        if (!error) {
            [self.delegate performSelector:@selector(userRequestClosed) withObject:nil];
            [self performSelector:@selector(cancelTapped:)withObject:self];
        }
#warning TODO: User Request errors processing
        
    }];
}

- (IBAction)cancelTapped:(id)sender {
    
    [self dismissKeyboard];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - TextField Delegate

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= MAXLENGTH_DESCRIPTION || returnKey;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self dismissKeyboard];
    return YES;
}

#pragma mark - Keyboard

- (void)notificationKeyboardWillShow:(NSNotification *)notification {
    
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    CGFloat animationDuration  =  [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGFloat bottomSide = CGRectGetHeight(self.view.frame) -  CGRectGetHeight(self.contentView.frame)  - CGRectGetMinY(self.contentView.frame);
    
    if (bottomSide <= CGRectGetHeight(keyboardFrameBeginRect) ) {
        
        [UIView animateWithDuration:animationDuration animations:^{
            
            self.popupVerticalAligmentConstrit.constant = -(CGRectGetHeight(keyboardFrameBeginRect) - bottomSide + 30);
            [self.view  layoutIfNeeded];
        }];
    }
}

- (void)notificationKeyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* keyboardInfo = [notification userInfo];
    CGFloat animationDuration  =  [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (self.popupVerticalAligmentConstrit.constant != 0) {
        
        [UIView animateWithDuration:animationDuration animations:^{
            
            self.popupVerticalAligmentConstrit.constant = 0;
            [self.view  layoutIfNeeded];
        }];
    }
}


-(void)dismissKeyboard {
    [self.commentTextField resignFirstResponder];
}

@end
