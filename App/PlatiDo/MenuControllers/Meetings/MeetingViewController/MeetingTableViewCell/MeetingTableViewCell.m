//
//  MeetingTableViewCell.m
//  PlatiDo
//
//  Created by Smart Labs on 08.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "MeetingTableViewCell.h"
#import "UIColor+Additions.h"
#import "MeetingQuestion.h"

@interface MeetingTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *organizerLabel;

@end

@implementation MeetingTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor colorWithHex:0xFFFFFF alpha:0.8];
}

- (void)setMeeting:(Meeting *)meeting
{
    _meeting = meeting;
    self.title.text = meeting.title;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMMM"];
    self.dateLabel.text = [formatter stringFromDate:meeting.createdAt];
    
    [formatter setDateFormat:@"HH:mm"];
    self.timeLabel.text = [formatter stringFromDate:meeting.createdAt];
    self.questionsLabel.text = [_meeting getQuestionsInOrderedString];
}

@end
