//
//  UserCommentTableViewCell.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 04.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "UserCommentTableViewCell.h"
#import "Comment.h"
#import "DateManager.h"
#import "UIColor+Additions.h"

@implementation UserCommentTableViewCell

- (void)awakeFromNib {
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)setCurComment:(Comment *)curComment{

    _curComment = curComment;
    
    DateManager *dateManager = [DateManager new];

    [self.commentTextView   setText:_curComment.text];
    [self.createByLabel     setText:_curComment.createdBy];
    [self.dateLabel         setText:[dateManager getDateOfUserReguest:_curComment.createdAt]];
    if (_curComment.creatorType != CommentCreatorTypeUser) {
        [self.createByLabel setTextColor:[UIColor colorWithHex:0x5B8D20]];
    }
}

@end
