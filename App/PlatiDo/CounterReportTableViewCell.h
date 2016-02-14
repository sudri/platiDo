//
//  CounterReportTableViewCell.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 10.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArchiveReportModel;

@interface CounterReportTableViewCell : UITableViewCell

@property (strong, nonatomic) ArchiveReportModel        * archiveReportModel;

@property (weak, nonatomic) IBOutlet UILabel            * dateLabel;
@property (weak, nonatomic) IBOutlet UILabel            * dateOfUserReportLabel;
//@property (weak, nonatomic) IBOutlet VoteItemsContainer * containerView;

@end
