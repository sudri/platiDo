//
//  InputCounterTableViewCell.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 14.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "InputCounterTableViewCell.h"
#import "CounterReportModel.h"
#import "NSString+Validation.h"
#import "UIColor+Additions.h"
#import "CountersReportsLoader.h"
#import "NSString+Brackets.h"

#define MAXLENGTH_COUNTER        5
#define MAXLENGTH_USER_COMMENT   35

@implementation InputCounterTableViewCell{

    BOOL _isCommentTextFieldEditingNow;
}

- (void)awakeFromNib {
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.activityIndicator setHidden:YES];
    _isCommentTextFieldEditingNow = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCurrentCounter:(CounterReportModel *)currentCounter{
    
    _currentCounter = currentCounter;

    [self.counterTitle setText:_currentCounter.title ];
    [self.counterMetricsTitle setText:_currentCounter.metrics];
    [self.counterImageView setImage:[UIImage imageNamed:[_currentCounter getIconForType]]];
    
    if (_currentCounter.subtitle.length > 0){
        [self.userCommentTextField setText:[_currentCounter.subtitle stringWithBreckets]];
    }
}

- (void)callKeyboard{

    [self.mainNumbersTextField becomeFirstResponder];
}

#pragma mark - User Report Text Field  Change

- (IBAction)editUserReportValue:(UITextField *)sender {
    
    NSString *text = sender.text;
    if (text.length > 0) {
        
        if (![text isAllDigits]) {
            [self.mainNumbersTextField setTextColor:[UIColor redColor]];
        }else{
            [self.mainNumbersTextField setTextColor:[UIColor colorWithHex:0x353535]];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            _currentCounter.userValue = [formatter numberFromString:text];
        }
    }else{
        _currentCounter.userValue = nil;
        [self.mainNumbersTextField setTextColor:[UIColor colorWithHex:0x353535]];
    }
}

#pragma mark - TextField Delegate

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength            = [textField.text length];
    NSUInteger replacementLength    = [string length];
    NSUInteger rangeLength          = range.length;
     
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    if (textField == self.userCommentTextField) {
        return newLength <= MAXLENGTH_USER_COMMENT || returnKey;
    }
    return newLength <= MAXLENGTH_COUNTER || returnKey;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if (textField == self.userCommentTextField) {
        [self sendComment];
    }
    return YES;
}

- (IBAction)commentTextFieldDidBeginEditing:(id)sender {

    self.userCommentTextField.text = [self.userCommentTextField.text stringDeleteBreckets];
    [self.changeCommentButton setImage:[UIImage imageNamed:@"galka"] forState:UIControlStateNormal];
    _isCommentTextFieldEditingNow = YES;
}

- (IBAction)commentTextFieldDidEndEditing:(id)sender {
   
    self.userCommentTextField.text = [self.userCommentTextField.text stringWithBreckets];
    [self.changeCommentButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    _isCommentTextFieldEditingNow = NO;
}

- (IBAction)counterReportTextFieledDidBeginEditing:(id)sender {
    
    NSMutableString *resultForCounterReport =[[NSMutableString alloc] initWithString:self.mainNumbersTextField.text] ;
    NSMutableIndexSet *mutableIndexSet = [[NSMutableIndexSet alloc] init];
    
    for (int i = 0; i < [self.mainNumbersTextField.text length]; i++) {
        if ([[self.mainNumbersTextField.text substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"0"]) {
//            self.mainNumbersTextField.text = [self.mainNumbersTextField.text stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@""];
            [mutableIndexSet addIndex:i];
        }
        else{
            break;
        }
    }
    [resultForCounterReport deleteCharactersInRange:NSMakeRange(0, [mutableIndexSet count])];
    [self.mainNumbersTextField setText:resultForCounterReport];
}

- (IBAction)counterReportTextFieldDidEndEditing:(id)sender {
    
    if ([self.mainNumbersTextField.text length] > 0) {
        self.mainNumbersTextField.text = [self.currentCounter counterValueWithZeroForRightMetric:self.mainNumbersTextField.text];
    }
}

- (void)setUserCommentTextFieldWhenScrolling{
    [self.userCommentTextField setText:[self.currentCounter.subtitle stringWithBreckets]];
}

#pragma mark - User Actions

- (void)sendComment{
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    NSDictionary *dict = @{@"id"    : self.currentCounter.counterID,
                           @"label" : [self.userCommentTextField.text stringDeleteBreckets]};
    [CountersReportsLoader sendCounterLabel:dict comBlock:^(id responseObject, NSError *error) {
        [self.activityIndicator setHidden:YES];
        [self.activityIndicator stopAnimating];
        if (!error) {
            [self.currentCounter setSubtitle:self.userCommentTextField.text];
        }
    }];
    [self.userCommentTextField resignFirstResponder];
}

- (IBAction)changeCommentTapped:(id)sender {
    
    if (_isCommentTextFieldEditingNow) {
        [self sendComment];
        
    }else{
        [self.userCommentTextField becomeFirstResponder];
    }
}

@end
