//
//  DetailMeetingTableViewCell.h
//  PlatiDo
//
//  Created by Smart Labs on 08.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meeting.h"
#import "CustomButtonYellow.h"
#import "HeaderDisCommentTableViewCell.h"

@interface DetailMeetingTableViewCell : UITableViewCell

@property (strong, nonatomic) Meeting *meeting;
@property (strong, nonatomic) NSString *quorum;
@property (weak, nonatomic) IBOutlet CustomButtonYellow *button;
@property (weak, nonatomic) id <HeaderDisCommentTableViewCellProtocol> delegate;
- (void)startActivity;
- (void)stopActivity;
- (void)hideLoadComponents:(BOOL)isHide;
@end
