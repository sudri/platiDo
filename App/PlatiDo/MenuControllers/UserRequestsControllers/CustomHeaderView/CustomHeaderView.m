//
//  CustomHeaderView.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 04.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "CustomHeaderView.h"
#import "UIStatusLabel.h"
#import "UserRequestModel.h"
#import "DateManager.h"
#import "UIColor+Additions.h"

@implementation CustomHeaderView{
    
    NSDictionary    *_statuses;
    DateManager     *_dateManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _dateManager = [DateManager new];

        _statuses = @{[@(UserRequestNew) stringValue]           : @0xF99B9B,
                      [@(UserRequestProcessing) stringValue]    : @0xFAB959,
                      [@(UserRequestComplete) stringValue]      : @0x95C479,
                      [@(UserRequestUndefined) stringValue]     : @0x4A6AAC
                      };
        
        [self.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
        [self.layer setShadowOffset:CGSizeMake(0.0, 1.0)];
        [self.layer setShadowOpacity:0.5];
        [self.layer setShadowRadius:2.0];

    }
    return self;
}

-(void)setCurrentUserRequestModel:(UserRequestModel *)currentUserRequestModel{

    [self layoutIfNeeded];

    _currentUserRequestModel = currentUserRequestModel;
    
    [self.currentStatusLabel.layer setCornerRadius:3];
    [self.currentStatusLabel setClipsToBounds:YES];
    [self.currentStatusLabel intrinsicContentSize];
    
    UserRequestStateType state  = _currentUserRequestModel.status;
    NSInteger color             = [[_statuses valueForKey:[NSString stringWithFormat:@"%ld",(long)state]] integerValue];
    
    [self.titleLabel            setText:_currentUserRequestModel.subject];
    [self.dateLabel             setText:[_dateManager getDateOfUserReguest:_currentUserRequestModel.createdAt]];
    [self.currentStatusLabel    setText:_currentUserRequestModel.statusText];
    [self.currentStatusLabel    setBackgroundColor:[UIColor colorWithHex:color]];
    
  
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:_currentUserRequestModel.reqDescription];
    [string addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:@"SFUIText-Regular" size:15.0]
                  range:NSMakeRange(0,[string length])];

    CGFloat height = [self textViewHeightForAttributedText:string
                                                  andWidth:CGRectGetWidth(self.problemDescription.frame)];
    
    [self.problemDescription setAttributedText:string];
    
    CGRect frame = self.frame;
    
    frame.size.height = CGRectGetHeight(self.frame) + (height - CGRectGetHeight(self.problemDescription.frame));
    self.frame = frame;
}

- (CGFloat)textViewHeightForAttributedText:(NSAttributedString *)text andWidth:(CGFloat)width{
    UITextView *textView = [[UITextView alloc] init];
    [textView setAttributedText:text];
    CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

@end
