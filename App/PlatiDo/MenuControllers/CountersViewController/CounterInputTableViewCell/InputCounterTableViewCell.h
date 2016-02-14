//
//  InputCounterTableViewCell.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 14.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CounterReportModel;

@interface InputCounterTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) CounterReportModel    *currentCounter;

@property (weak, nonatomic) IBOutlet UILabel        *counterTitle;
@property (weak, nonatomic) IBOutlet UILabel        *counterMetricsTitle;

@property (weak, nonatomic) IBOutlet UIImageView    *counterImageView;

@property (weak, nonatomic) IBOutlet UITextField    *mainNumbersTextField;
@property (weak, nonatomic) IBOutlet UITextField    *userCommentTextField;

@property (weak, nonatomic) IBOutlet UIButton       *changeCommentButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void)callKeyboard;
- (void)setUserCommentTextFieldWhenScrolling;

@end
