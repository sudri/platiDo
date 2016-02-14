//
//  DetailArchiveCountersViewController.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 30.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DetailArchiveCountersViewController.h"
#import "VoteItemsContainer.h"
#import "ArchiveReportModel.h"
#import "CounterReportItemView.h"
#import "ArchiveCounterModel.h"

@interface DetailArchiveCountersViewController ()

@property (weak, nonatomic) IBOutlet VoteItemsContainer * containerView;
@property (weak, nonatomic) IBOutlet UILabel *paymentDateLabel;

@end

@implementation DetailArchiveCountersViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"back"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(backVC)];
    
    self.navigationItem.leftBarButtonItem = backButton;

    
    NSDateFormatter  *formatter  = [[NSDateFormatter alloc] init];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth| NSCalendarUnitYear fromDate:_currentArchiveModel.date];
    NSInteger month = [components month];
    NSInteger year  = [components year];
    
    [formatter setDateFormat:@"MMMM yyyy"];
    
    NSString *monthName = [[formatter standaloneMonthSymbols] objectAtIndex:(month -1)];
    NSString *capitalisedMonth = [monthName stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                    withString:[[monthName substringToIndex:1] capitalizedString]];
    [self setTitle:[NSString stringWithFormat:@"%@ %ld", capitalisedMonth, (long)year]];
//    [self.dateLabel setText: [NSString stringWithFormat:@"%@ %ld", monthName, (long)year]];
    
    [self.containerView clear];
    for (int i = 0; i < [_currentArchiveModel.counters count]; i++){
        
        ArchiveCounterModel *counter = _currentArchiveModel.counters[i];
        CounterReportItemView *reportView =  [[[NSBundle mainBundle] loadNibNamed:@"CounterReportItemView"
                                                                            owner:self
                                                                          options:nil]
                                              objectAtIndex:0];
        
        [reportView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 45)];
        
        [reportView setArchiveCounterModel:counter];
        [self.containerView addItem:reportView];
    }

    if (_currentArchiveModel.createdAtUserDate) {
        NSString *dateString = [NSDateFormatter localizedStringFromDate:_currentArchiveModel.createdAtUserDate
                                                              dateStyle:NSDateFormatterFullStyle
                                                              timeStyle:NSDateFormatterNoStyle];
        
        [self.paymentDateLabel setText: dateString];
    }else{
        [self.paymentDateLabel setText: NSLocalizedString(@"Date of registration not available", nil)];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backVC{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setCurrentArchiveModel:(ArchiveReportModel *)currentArchiveModel{
  
    _currentArchiveModel = currentArchiveModel;
}

@end
