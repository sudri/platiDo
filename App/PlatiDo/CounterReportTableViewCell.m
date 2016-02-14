//
//  CounterReportTableViewCell.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 10.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "CounterReportTableViewCell.h"
#import "ArchiveReportModel.h"
//#import "CounterReportItemView.h"
//#import "ArchiveCounterModel.h"

@implementation CounterReportTableViewCell{
    NSDateFormatter     * _formatter;
    NSDateComponents    * _components;
}

- (void)awakeFromNib {
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    _formatter = [[NSDateFormatter alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setArchiveReportModel:(ArchiveReportModel *)archiveReportModel{
    
    _archiveReportModel = archiveReportModel;
    
    _components     = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth| NSCalendarUnitYear fromDate:_archiveReportModel.date];
    NSInteger month = [_components month];
    NSInteger year  = [_components year];
    
    [_formatter setDateFormat:@"MMMM yyyy"];
    
    NSString *monthName = [[_formatter standaloneMonthSymbols] objectAtIndex:(month -1)];
    NSString *capitalisedMonth = [monthName stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                              withString:[[monthName substringToIndex:1] capitalizedString]];

//    NSLog(@"%@ %@", [formatter stringFromDate:_archiveReportModel.date],[NSString stringWithFormat:@"%@ %ld", monthName, (long)year] );
//    [formatter setDateStyle:NSDateFormatterFullStyle];
//    [self.dateLabel setText: [formatter stringFromDate:_archiveReportModel.date]];
//    [self.containerView clear];

    [self.dateLabel setText: [NSString stringWithFormat:@"%@ %ld", capitalisedMonth, (long)year]];

    if (_archiveReportModel.createdAtUserDate) {
        NSString *dateString = [NSDateFormatter localizedStringFromDate:_archiveReportModel.createdAtUserDate
                                                              dateStyle:NSDateFormatterMediumStyle
                                                              timeStyle:NSDateFormatterNoStyle];

        [self.dateOfUserReportLabel setText: dateString];
    }else{
        [self.dateOfUserReportLabel setText: @""];
    }

//    if ([_archiveReportModel.counters count] < [self.containerView.items count]) {
//        for (int k = (int)[_archiveReportModel.counters count]; k < [self.containerView.items count]; k++){
//            CounterReportItemView *reportView = self.containerView.items[k];
//            [reportView removeFromSuperview];
//            [self.containerView.items removeObject:reportView];
//        }
//        [self.containerView clear];
//    }
//    
//    for (int i = 0; i < [_archiveReportModel.counters count]; i++){
//        
//        if (i < [self.containerView.items count]) {
//            CounterReportItemView *reportView = self.containerView.items[i];
//            
//            ArchiveCounterModel *counter = _archiveReportModel.counters[i];
//            [reportView setArchiveCounterModel:counter];
//        }
//        else{
//            ArchiveCounterModel *counter = _archiveReportModel.counters[i];
//            CounterReportItemView *reportView =  [[[NSBundle mainBundle] loadNibNamed:@"CounterReportItemView"
//                                                                                owner:self
//                                                                              options:nil]
//                                                                            objectAtIndex:0];
//            
//            [reportView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 45)];
//            
//            [reportView setArchiveCounterModel:counter];
//            [self.containerView addItem:reportView];
//        }
//
//    }
}

@end
