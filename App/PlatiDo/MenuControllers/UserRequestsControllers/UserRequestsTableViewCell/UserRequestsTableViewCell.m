//
//  ApplicationTableViewCell.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 28.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "UserRequestsTableViewCell.h"
#import "DateManager.h"
#import "UIColor+Additions.h"

@implementation UserRequestsTableViewCell{

    NSDictionary *_statuses;
}
- (void)awakeFromNib {
 
    [self setSelectionStyle: UITableViewCellSelectionStyleNone];

    [self.currentStatusLabel.layer setCornerRadius:3];
    [self.currentStatusLabel setClipsToBounds:YES];
    
    _statuses = @{[@(UserRequestNew) stringValue]           : @0xF99B9B,
                  [@(UserRequestProcessing) stringValue]    : @0xFAB959,
                  [@(UserRequestComplete) stringValue]      : @0x95C479,
                  [@(UserRequestUndefined) stringValue]     : @0x4A6AAC
                  };

    [self.currentStatusLabel intrinsicContentSize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCurrentUserRequestModel:(UserRequestModel *)currentUserRequestModel{

    _currentUserRequestModel = currentUserRequestModel;
    DateManager *dateManager = [DateManager new];

    [self.titleLabel    setText:_currentUserRequestModel.subject];
    [self.commentsLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)[_currentUserRequestModel.comments count]]];
    [self.dateLabel     setText:[dateManager getDateOfUserReguest:_currentUserRequestModel.createdAt]];
    
    [self.currentStatusLabel setText:_currentUserRequestModel.statusText];
   
    UserRequestStateType state = _currentUserRequestModel.status;
    NSInteger color         = [[_statuses valueForKey:[NSString stringWithFormat:@"%ld",(long)state]] integerValue];
    
    [self.currentStatusLabel setBackgroundColor:[UIColor colorWithHex:color]];
}

@end
