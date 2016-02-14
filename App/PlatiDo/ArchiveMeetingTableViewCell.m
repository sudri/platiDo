//
//  ArchiveMeetingTableViewCell.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 29.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "ArchiveMeetingTableViewCell.h"
#import "Meeting.h"

@implementation ArchiveMeetingTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCurrentMeeting:(Meeting *)currentMeeting{

    _currentMeeting = currentMeeting;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMMM HH:mm"];

    [self.titleLabel setText:_currentMeeting.title];
    [self.dateLabel setText:[formatter stringFromDate:_currentMeeting.startsAt]];
}

@end
