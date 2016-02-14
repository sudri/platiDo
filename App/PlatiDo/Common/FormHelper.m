//
//  FromHelper.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 21.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "FormHelper.h"
#import "UIView+Additional.h"

@implementation FormHelper
{
    CGPoint _startTouchPoint;
    CGSize keyboardSize;
    UIPanGestureRecognizer *_panGesture;
}

- (id)init{
    self = [super init];
    if (self){
         _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    }
    return self;
}

- (void)panHandler:(UIPanGestureRecognizer*)panGest{

    if (panGest.state == UIGestureRecognizerStateBegan) {
        [self reset];
    }
    
}


- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)deregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


- (void)reset{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    [[self.rootView findViewThatIsFirstResponder] resignFirstResponder];
}


- (void)registerMe {
    [self registerForKeyboardNotifications];
}


- (void)unregisterMe {
    [self deregisterFromKeyboardNotifications];
}


- (void)keyboardWasShown:(NSNotification *)notification {

    NSDictionary* info = [notification userInfo];
    
    keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [self updateVisibleWithAnim:YES];
    
    if ([self.delegate respondsToSelector:@selector(scrollDidUp)]){
        [self.delegate scrollDidUp];
    }
    
    [self.scrollContentView addGestureRecognizer:_panGesture];
}

- (void)updateVisibleWithAnim:(BOOL)isAnim{
    UIView *viewToUp ;
    
    if (self.formView == nil && [self.delegate respondsToSelector:@selector(viewPreferToVisible)]){
        viewToUp = [self.delegate viewPreferToVisible];
    } else {
        viewToUp = self.formView;
    }
    
    if (viewToUp == nil ) return;
    

    CGRect convertedRect = [self.scrollContentView convertRect:[viewToUp  frame] fromView:[viewToUp  superview]];
    convertedRect.origin.y += self.scrollView.frame.origin.y;
    CGPoint buttonMaxPoint = (CGPoint){0,CGRectGetMaxY(convertedRect)};
    
    CGFloat marginOffset = 5.0;
    buttonMaxPoint.y += marginOffset;
    
    CGRect visibleRect   = self.rootView.bounds;
    
    visibleRect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(visibleRect, buttonMaxPoint)){
        CGPoint scrollPoint = CGPointMake(0.0, buttonMaxPoint.y - visibleRect.size.height+marginOffset);
        [self.scrollView setContentOffset:scrollPoint animated:isAnim];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    keyboardSize = CGSizeZero;
    
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    if ([self.delegate respondsToSelector:@selector(scrollDidDown)]){
        [self.delegate scrollDidDown];
    }
    [self.scrollContentView removeGestureRecognizer:_panGesture];
}

@end
