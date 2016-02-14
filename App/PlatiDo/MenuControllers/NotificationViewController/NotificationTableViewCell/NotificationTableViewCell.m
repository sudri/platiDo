//
//  NotificationTableViewCell.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 27.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "NotificationTableViewCell.h"

@implementation NotificationTableViewCell

- (void)awakeFromNib {
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
