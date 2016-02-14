//
//  CustomHeaderView.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 04.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIStatusLabel;
@class UserRequestModel;

@interface CustomHeaderView : UIView

@property (strong, nonatomic) UserRequestModel   * currentUserRequestModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstrait;

@property (weak, nonatomic) IBOutlet UILabel        * titleLabel;

@property (weak, nonatomic) IBOutlet UILabel        * statusLabel;
@property (weak, nonatomic) IBOutlet UILabel        * dateLabel;
@property (weak, nonatomic) IBOutlet UIStatusLabel  * currentStatusLabel;
@property (weak, nonatomic) IBOutlet UITextView     * problemDescription;

@end
