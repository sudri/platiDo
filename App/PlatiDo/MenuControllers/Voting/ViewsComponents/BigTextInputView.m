//
//  BigTextInputView.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 03.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//
#define MAXLENGTH_DESCRIPTION 200
#import "BigTextInputView.h"


@interface BigTextInputView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textContentH;

@end

@implementation BigTextInputView


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self initElements];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initElements];
    }
    return self;
}

- (void)initElements{
    
    [self addXibContent];
    self.sepH.constant = 0.5;
    [self updateTextViewAnim:NO];
    self.textView.returnKeyType = UIReturnKeyDone;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return textView.text.length + (text.length - range.length) <= MAXLENGTH_DESCRIPTION;
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@" view did begin editing %@", self);
}


- (void)edidtingTextDone{
    [self.textView resignFirstResponder];
}


- (void)addXibContent{
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"BigTextInputView" owner:self options:nil] firstObject];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:view];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(view);

    
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                  options:NSLayoutFormatAlignmentMask
                                                                  metrics:nil
                                                                    views:views]];
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                  options:NSLayoutFormatAlignmentMask
                                                                  metrics:nil
                                                                    views:views]];
}

- (void)updateTextViewAnim:(BOOL)isAnim{
    self.textContentH.constant = self.textView.contentSize.height;
    if (isAnim) {
        [UIView animateWithDuration:0.3 animations:^{
            [self setNeedsLayout];
            [self layoutIfNeeded];
        }];
    } else {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}


- (void)textViewDidChange:(UITextView *)textView{
    [self updateTextViewAnim:YES];
    if ([self.delegate respondsToSelector:@selector(changeTextBigTextInputView:)]){
        [self.delegate changeTextBigTextInputView:self];
    }
}

@end
