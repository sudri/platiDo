//
//  ApplicationTableViewCell.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 28.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UserRequestModel.h"
#import "UIStatusLabel.h"

@interface UserRequestsTableViewCell : UITableViewCell

@property (strong, nonatomic) UserRequestModel      * currentUserRequestModel;

@property (weak, nonatomic) IBOutlet UILabel        * titleLabel;

@property (weak, nonatomic) IBOutlet UILabel        * statusLabel;
@property (weak, nonatomic) IBOutlet UIStatusLabel  * currentStatusLabel;

@property (weak, nonatomic) IBOutlet UIImageView    * photosImageView;
@property (weak, nonatomic) IBOutlet UILabel        * photosLabel;

@property (weak, nonatomic) IBOutlet UIImageView    * commetsImageView;
@property (weak, nonatomic) IBOutlet UILabel        * commentsLabel;

@property (weak, nonatomic) IBOutlet UILabel        * dateLabel;

@end
