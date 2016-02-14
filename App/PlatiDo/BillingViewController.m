//
//  BillingViewController.m
//  PlatiDo
//
//  Created by Smart Labs on 08.09.15.
//  Copyright (c) 2015 Valera Voroshilov. All rights reserved.
//

#import "BillingViewController.h"
#import "ChargeDescriptionViewController.h"
#import "DetailPaidBillViewController.h"
#import "BillingTableViewCell.h"
#import "ShortBillTableViewCell.h"
#import "UIColor+Additions.h"
#import "UIView+Screenshot.h"
#import "UIImage+MyBlur.h"
#import "OwnershipHelper.h"


@interface BillingViewController()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchContainerView;

@property (strong, nonatomic) NSArray *billsArray;
@property (strong, nonatomic) NSArray *paidBillsArray;

@property (strong, nonatomic) Charge *chargeForDescription;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBarButton;
@property (nonatomic ,strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) OwnershipHelper *ownershipHelper;
@property (nonatomic, strong) UILabel *warningLabel;

@property (nonatomic, getter=isFirstLoadingFinished) BOOL firstLoadingFinish;
//@property (nonatomic) BOOL ;

@end


@implementation BillingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
   // activityView.backgroundColor = [UIColor blackColor];
    activityView.center = self.view.center;
    [self.view addSubview:activityView];
    [self.view bringSubviewToFront:activityView];
    [activityView startAnimating];
    self.activityIndicator = activityView;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.tableView addSubview:self.refreshControl];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshData)
                  forControlEvents:UIControlEventValueChanged];
    [self refreshData];
    
    self.navigationItem.title = NSLocalizedString(@"Billing and Payment", nil);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.segmentControl.selectedSegmentIndex)
    {
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
    }
}

- (void)refreshData{
    [BillingRequestApi currentBillWithComBlock:^(id respObj, NSError *error){

        if (respObj)
        {
            self.billsArray = [self parseResponse:respObj];
            self.paidBillsArray = self.billsArray;  
        }
        [self.activityIndicator stopAnimating];
        [self.activityIndicator removeFromSuperview];
        [self.refreshControl endRefreshing];
        [self setFirstLoadingFinish:YES];
        [self.tableView reloadData];
    }];
    
    [BillingRequestApi historyBillWithComBlock:^(id respObj, NSError *error){
        
        if (error)
        {
            NSString *errorMessage = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"Failed to get the data.", nil), [error.userInfo objectForKey:@"NSLocalizedDescription"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(errorMessage, nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
            [alert show];
        }
        if (respObj)
        {
            self.paidBillsArray = self.billsArray;//[self parseResponse:respObj];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    
    if (self.ownershipHelper==nil){
        __weak typeof (self) weakSelf = self;
        self.ownershipHelper = [[OwnershipHelper alloc] initWithViewController:self];
        [self.ownershipHelper setCompletionBlock:^(OwnershipStatus status) {
            [weakSelf refreshData];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.backgroundView = [[UIView alloc] initWithFrame:self.tableView.frame];
    if (self.segmentControl.selectedSegmentIndex)
    {
        if ([self.paidBillsArray count]==0)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:self.tableView.frame];
            label.text = NSLocalizedString(@"Archived data are not available", nil);
            label.textColor = [UIColor colorWithHex:0x7E7E7E];
            label.textAlignment = NSTextAlignmentCenter;
            self.tableView.backgroundView = label;
        }
        return [self.paidBillsArray count];
    } else {
        if ([self.billsArray count]==0 && self.isFirstLoadingFinished)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:self.tableView.frame];
            label.text = NSLocalizedString(@"while no bill", @"Нет актуальных счетов");
            label.textColor = [UIColor colorWithHex:0x7E7E7E];
            label.textAlignment = NSTextAlignmentCenter;
            self.tableView.backgroundView = label;
        }
        return [self.billsArray count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentControl.selectedSegmentIndex)
    {
        return 44;
    }
    Bill *bill = [self.billsArray objectAtIndex:indexPath.row];
    int k = [bill.charges count]*27+125+142;
    return k;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentControl.selectedSegmentIndex)
    {
        ShortBillTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PaidBillCell" forIndexPath:indexPath];
        cell.bill = [self.billsArray objectAtIndex:indexPath.row];
        return cell;
    }
    
    BillingTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BillingCell" forIndexPath:indexPath];
    cell.bill = [self.billsArray objectAtIndex:indexPath.row];
    cell.parentViewController = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //DetailBill
    [self performSegueWithIdentifier:@"DetailBill" sender:nil];
}

- (IBAction)segmentControlValueChanged:(UISegmentedControl *)sender {
    
    if (self.segmentControl.selectedSegmentIndex)
    {
        self.tableView.allowsSelection = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    } else {
        self.tableView.allowsSelection = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
        [self.tableView reloadData];
}

- (void)showChargeDescriptionWithCharge:(Charge *)charge
{
    self.chargeForDescription = charge;
    [self performSegueWithIdentifier:@"ChargeDescription" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ChargeDescription"])
    {
        UIImage *screenShot = [self.navigationController.view screenshot];
        UIImage *blurImage  = [screenShot blurredImageWithRadius:17.5 iterations:2 tintColor:nil];
        
        ChargeDescriptionViewController *vc = segue.destinationViewController;
        vc.blurredImage = blurImage;
        vc.charge = self.chargeForDescription;
    }
    if ([segue.identifier isEqualToString:@"DetailBill"])
    {
        DetailPaidBillViewController *vc = segue.destinationViewController;
        vc.bill = [self.billsArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    }
    
}

- (IBAction)tapSearch:(UIBarButtonItem *)sender {
    
    self.searchContainerView.hidden = NO;
    //self.searchBarButton.style = UIBarButtonSystemItemCancel;
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel     target:self action:@selector(hideSearchMode)];
    [self.navigationItem setRightBarButtonItem:add];
    self.searchBarButton = add;
}

- (void)hideSearchMode
{
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch     target:self action:@selector(tapSearch:)];
    [self.navigationItem setRightBarButtonItem:add];
    self.searchBarButton = add;
    self.searchContainerView.hidden = YES;
    self.searchBarButton.style = UIBarButtonSystemItemSearch;
}

- (NSArray *)parseResponse:(id)respObj
{
    NSMutableArray *array = [NSMutableArray new];
    NSError *e;
    if ([respObj isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *dict in respObj)
        {
            Bill *bill = [[Bill alloc] initWithDictionary:dict error:&e];
            NSMutableArray *a = [NSMutableArray new];
            for (NSDictionary *d in bill.charges){
                Charge *charge = [[Charge alloc] initWithDictionary:d error:nil];
                [a addObject:charge];
            }
            bill.charges = a;
            [array addObject:bill];
        }
    }else{
        Bill *bill = [[Bill alloc] initWithDictionary:respObj error:&e];
        NSMutableArray *a = [NSMutableArray new];
        for (NSDictionary *d in bill.charges){
            NSError *er;
            Charge *charge = [[Charge alloc] initWithDictionary:d error:&er];
            [a addObject:charge];
        }
        bill.charges = a;
        [array addObject:bill];
    }
    
    return array;
}

@end
