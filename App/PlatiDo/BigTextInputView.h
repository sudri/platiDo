//
//  BigTextInputView.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 03.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"
@class BigTextInputView;

@protocol BigTextInputViewProtocol <NSObject>

@required
- (void)changeTextBigTextInputView:(BigTextInputView*)textView;
@end

@interface BigTextInputView : UIView
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *textView;
@property (weak, nonatomic)  id <BigTextInputViewProtocol> delegate;
- (void)updateTextViewAnim:(BOOL)isAnim;
@end
