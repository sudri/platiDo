//
//  ArchiveMeetingTableViewCell.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 29.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Meeting;

@interface ArchiveMeetingTableViewCell : UITableViewCell

@property (strong, nonatomic) Meeting *currentMeeting;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
