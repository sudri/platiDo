//
//  CountersViewController.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 09.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "CountersViewController.h"
#import "CounterReportTableViewCell.h"
#import "InputCounterTableViewCell.h"
#import "CounterReportModel.h"
#import "MBProgressHUD.h"

#import "DetailArchiveCountersViewController.h"
#import "CountersReportsLoader.h"
#import "ArchiveReportModel.h"
#import "UIView+Additional.h"
#import "AlertViewCustom.h"
#import "OwnershipHelper.h"
#import "AppDelegate.h"
#import "FooterView.h"

#define EMPTY_CELL_HEIGHT       90.0
#define FOOTER_HEIGHT           60.0

@interface CountersViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>{

    CountersReportsLoader *_counterReportLoader;
}

@property (weak, nonatomic) IBOutlet UILabel                    * infoLabel;
@property (weak, nonatomic) IBOutlet UITableView                * tableView;

@property (weak, nonatomic) IBOutlet UISegmentedControl         * segmentController;

@property (weak, nonatomic) IBOutlet UIView                     * bottomView;
@property (weak, nonatomic) IBOutlet UIButton                   * sendReportsButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView    * activityIndicator;

@property (nonatomic, strong) OwnershipHelper                   * ownershipHelper;
@property (strong, nonatomic) FooterView                        * footerView;

@end

@implementation CountersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"Counters", nil)];
    [self.infoLabel setHidden:YES];
    
    self.tableView.estimatedRowHeight   = EMPTY_CELL_HEIGHT;
    self.tableView.rowHeight            = UITableViewAutomaticDimension;
    [self.bottomView setHidden:YES];

    self.sendReportsButton.layer.cornerRadius = 3;
    self.sendReportsButton.clipsToBounds = YES;

    _counterReportLoader = [CountersReportsLoader new];
    
//    [CountersReportsLoader resetUserCountersInputComBlock:^(NSError *error) {
//        
//    }];
   
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidesWhenStopped:YES];
    
    [self loadInputCounters];
    
    self.footerView = [[FooterView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), 50)];
}

#pragma mark - Load Data

- (void)loadInputCounters{
    [_counterReportLoader getCountersForInputComBlock:^(NSError *error) {
    
        [self.activityIndicator stopAnimating];
        if (!error) {
          
            [UIView transitionWithView:self.tableView duration:0.35f options:UIViewAnimationOptionTransitionCrossDissolve  animations:^(void){
                 [self.tableView reloadData];
             }
            completion:^(BOOL finished) {
                if (self.segmentController.selectedSegmentIndex == InputUserCountersReportsIndex && _counterReportLoader.countersInputs.count > 0) {
                    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
                    [self.bottomView setHidden:NO];
                }
            }];
        }
        
        if (_counterReportLoader.countersInputs.count == 0) {
            [self.infoLabel setHidden:NO];
        }
    }];
}

- (void)loadArchiveCountersReports{
    
    if (_counterReportLoader.isAllArchiveCountersReportsLoaded) {
        return;
    }
    if (_counterReportLoader.countersReports.count >= 10) {
        [self.footerView.activityIndicator  setHidden:NO];
        [self.footerView.activityIndicator  startAnimating];
    }

    [_counterReportLoader getArchiveCountersReportComBlock:^(NSError *error) {
        [self.activityIndicator stopAnimating];
        if (!error) {
            
            if (_counterReportLoader.countersReports.count > 10) {
                [self.tableView reloadData];
                if (self.segmentController.selectedSegmentIndex == ArchiveUserCounterReportsIndex) {
                    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, -FOOTER_HEIGHT, 0.0f);
                    [self.bottomView setHidden:YES];
                }
            }else{
                [UIView transitionWithView:self.tableView duration:0.35f options:UIViewAnimationOptionTransitionCrossDissolve  animations:^(void){
                    [self.tableView reloadData];
                }
                completion:^(BOOL finished) {
                    if (self.segmentController.selectedSegmentIndex == ArchiveUserCounterReportsIndex) {
                        self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, -FOOTER_HEIGHT, 0.0f);
                        [self.bottomView setHidden:YES];
                    }
                }];
            }

            [self.footerView.activityIndicator  setHidden:YES];
            [self.footerView.activityIndicator  stopAnimating];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.ownershipHelper==nil){
        __weak typeof (self) weakSelf = self;
        self.ownershipHelper = [[OwnershipHelper alloc] initWithViewController:self];
        [self.ownershipHelper setCompletionBlock:^(OwnershipStatus status) {
            if (status == OwnershipStatusConfirm){
                [weakSelf loadInputCounters];
            }
        }];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


#pragma mark -  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.segmentController.selectedSegmentIndex == InputUserCountersReportsIndex) {
        return  _counterReportLoader.countersInputs.count;
    }else{
        return  _counterReportLoader.countersReports.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.segmentController.selectedSegmentIndex == InputUserCountersReportsIndex) {
        InputCounterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputCounterTableViewCell"];
        CounterReportModel *currentCounter =  _counterReportLoader.countersInputs[indexPath.row];
        [cell setCurrentCounter:currentCounter];
        return cell;
    }else{
        CounterReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CounterReportTableViewCell"];
        ArchiveReportModel *currentReport = _counterReportLoader.countersReports[indexPath.row];
        [cell setArchiveReportModel:currentReport];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.segmentController.selectedSegmentIndex == InputUserCountersReportsIndex) {
        
        InputCounterTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell callKeyboard];
        [self.tableView setContentOffset:CGPointMake(0, CGRectGetMinY(cell.frame)) animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.segmentController.selectedSegmentIndex == ArchiveUserCounterReportsIndex) {

        if ((indexPath.row == [_counterReportLoader.countersReports count] - 1)) {
            
            AppDelegate * appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            if (appDelegate.netStatus == NotReachable){
                
            }
            else{
                [self loadArchiveCountersReports];
            }
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (_counterReportLoader.isAllArchiveCountersReportsLoaded || self.segmentController.selectedSegmentIndex == InputUserCountersReportsIndex) {
        return [UIView new];
    }else{
        return self.footerView;
    }

}


#pragma mark - Keyboard

- (void)notificationKeyboardWillShow:(NSNotification *)notification {
    
    if (self.segmentController.selectedSegmentIndex == InputUserCountersReportsIndex) {
        for (int i = 0; i < _counterReportLoader.countersInputs.count; i++){
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            InputCounterTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

            if ([cell findViewThatIsFirstResponder]) {
                [self.tableView setContentOffset:CGPointMake(0, CGRectGetMinY(cell.frame)) animated:YES];
            }
        }
    }
}

- (void)notificationKeyboardWillHide:(NSNotification *)notification {
    
}


#pragma mark - ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    if (self.segmentController.selectedSegmentIndex == InputUserCountersReportsIndex) {

        for (int i = 0; i < _counterReportLoader.countersInputs.count; i++){
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            InputCounterTableViewCell *cell = (InputCounterTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            if ([cell.userCommentTextField isFirstResponder]) {
                [cell setUserCommentTextFieldWhenScrolling];
            }

            [cell.mainNumbersTextField resignFirstResponder];
            [cell.userCommentTextField resignFirstResponder];
        }
    }
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"DetailArchiveReportSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        ArchiveReportModel *currentReport = _counterReportLoader.countersReports[indexPath.row];

        DetailArchiveCountersViewController *vc = segue.destinationViewController;
        [vc setCurrentArchiveModel:currentReport];
    }
}

#pragma mark - User Actions

- (IBAction)sendReportsTapped:(id)sender {
    
    for (CounterReportModel *report in _counterReportLoader.countersInputs){
        if (!report.userValue){
            [AlertViewCustom errorReportsSend];
            return;
        }
    }
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (CounterReportModel *report in _counterReportLoader.countersInputs){
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)[report.userValue integerValue]]
                 forKey:[NSString stringWithFormat:@"%ld", (long)[report.counterID integerValue]]];
    }
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    [CountersReportsLoader sendUserReports:dict comBlock:^(id responseObject, NSError *error) {
        [MBProgressHUD  hideHUDForView:self.view animated:YES];

        if (!error) {
            [AlertViewCustom userReportsSendSuccessfully];
            [_counterReportLoader.countersInputs removeAllObjects];
            [self.tableView reloadData];
            [self.infoLabel setHidden:NO];
            [self.bottomView setHidden:YES];
        }
    }];
}

- (IBAction)segmentDidValueChange:(id)sender {
    [self.infoLabel setHidden:YES];
    if (self.segmentController.selectedSegmentIndex == InputUserCountersReportsIndex) {
        
        if (_counterReportLoader.countersInputs.count == 0) {
            
            [self.activityIndicator startAnimating];
            [self loadInputCounters];
        }else{
            self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
            [self.bottomView setHidden:NO];
        }
    }
    else{
        if (_counterReportLoader.countersReports.count == 0) {
            
            [self.activityIndicator startAnimating];
            [self loadArchiveCountersReports];
        }
        
        self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, -FOOTER_HEIGHT, 0.0f);
        [self.bottomView setHidden:YES];
    }
    [self.tableView reloadData];
}

@end
