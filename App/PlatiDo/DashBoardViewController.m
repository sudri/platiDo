//
//  DashBoardViewController.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 27.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DashBoardViewController.h"
#import "DashboardCounter.h"
#import "DashBoardTableViewCell.h"
#import "UIImage+ImageEffects.h"
#import "UIColor+Additions.h"
#import "DashboardData.h"
#import "DashboardAPI.h"
#import "DashboardItem.h"
#import "NotificationViewController.h"
#import "AppDelegate.h"
#import "SwipeMenuController.h"
#import "CurrentUser.h"
#import "CommonDataProvider.h"

@interface DashBoardViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgMainImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSArray *dataItems;
@property (nonatomic ,strong) UIRefreshControl *refreshControl;
@end

@implementation DashBoardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setContentInset:(UIEdgeInsets){8,0,0,0}];
  
    [self.activityIndicator startAnimating];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.tableView addSubview:self.refreshControl];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshData)
                  forControlEvents:UIControlEventValueChanged];
    [self refreshData];
    
    
    UIColor *color = [UIColor colorWithHex:0x0F2C86 alpha:0.35];
    self.bgMainImage.image = [self.bgMainImage.image applyBlurWithRadius:10 tintColor:color saturationDeltaFactor:1.8 maskImage:nil];
    
    
    UIView *imageTitle = [[UIView alloc] initWithFrame:(CGRect){0,0, 130,28}];
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [imageTitle addSubview:titleView];
    [titleView setFrame:imageTitle.bounds];
    self.navigationItem.titleView = imageTitle;
    
    
    
    UIBarButtonItem *notificationsButton = [[UIBarButtonItem alloc]
                                            initWithImage:[UIImage imageNamed:@"mail"]
                                            style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(notificationButtonTapped)];
    
    self.navigationItem.rightBarButtonItem = notificationsButton;
    
}



- (void)notificationButtonTapped{
    [shareAppDelegate showMenuSequeByName:@"showMessages"];
}


- (void)refreshData{
    [DashboardAPI dashboardInfocomBlock:^(DashboardData *data, NSError *error) {
        [self.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];

        self.dataItems = [self packDataItemsFrom:data];
        [self.tableView reloadData];
    }];
}


- (NSArray*)packDataItemsFrom:(DashboardData*)data{
    NSMutableArray *result = [@[] mutableCopy];
    /// я не знаю как лучше (((
   
    if (CurrentUserInstance.ownershipStatus == OwnershipStatusNotconfirm || data.metersReport){
        DashboardItem *item = [DashboardItem new];
        item.type  = DashboardItemMetersReport;
        item.isHaveAccess = data.accessRights.metersReport;
        [result addObject:item];
    }

    if (CurrentUserInstance.ownershipStatus == OwnershipStatusNotconfirm ||  data.bills){
        DashboardItem *item = [DashboardItem new];
        item.isHaveAccess = data.accessRights.bills;
        item.type  = DashboardItembill;
        [result addObject:item];
    }
  
    
   // if (data.dashboardDiscussions!=nil){
        DashboardItem *item2 = [DashboardItem new];
        item2.data  = data.dashboardDiscussions;
        item2.type  = DashboardItemDiscussions;
        item2.count = data.counters.discussions;
        [result addObject:item2];
   // }

   // if (data.dashboardVotings!=nil){
        DashboardItem *item3 = [DashboardItem new];
        item3.data  = data.dashboardVotings;
        item3.type  = DashboardItemVotings;
        item3.count = data.counters.votings;
        [result addObject:item3];
  //  }

  //  if (data.dashboardRequests!=nil){
        DashboardItem *item5   = [DashboardItem new];
        
        item5.data  = data.dashboardRequests;
        item5.type  = DashboardItemRequests;
        item5.count = data.counters.requests;
        [result addObject:item5];
   // }
    
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DashBoardTableViewCell *dashCell = [tableView dequeueReusableCellWithIdentifier:@"DashBoardCell"];
    [dashCell setItem:self.dataItems[indexPath.row]];
    return dashCell;
    
}

- (NSString*)segueIdentifierByItemType:(DashboardItemType)type{

    switch (type) {
        case DashboardItembill:
            return @"showBIlls";
            break;
        case DashboardItemDiscussions:
            return @"showDiscussions";
            break;
        case DashboardItemVotings:
            return @"showVoting";
            break;
        case DashboardItemRequests:
            return @"showRequests";
            break;
        case DashboardItemMetersReport:
            return @"showMeters";
            break;
    }
    return nil;
}


- (void)attachflagsToSegue:(NSString*)segue cellDataItem:(DashboardItem*) dashItem{
    
    switch (dashItem.type) {
        case DashboardItembill:
            break;
        case DashboardItemMetersReport:
            break;
        case DashboardItemDiscussions:
            CommonDataProviderInstance.createDiscuttionsAfterAppear = YES;
            break;
        case DashboardItemVotings:
            CommonDataProviderInstance.createVoteAfterAppear    = YES;
            break;
        case DashboardItemRequests:
            CommonDataProviderInstance.createRequestAfterAppear = YES;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DashBoardTableViewCell *dashCell = (DashBoardTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    SwipeMenuController *swipeMenuCon = (SwipeMenuController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    
    NSString *segue = [self segueIdentifierByItemType:dashCell.item.type ];
    [self.view setUserInteractionEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view setUserInteractionEnabled:YES];
        if (dashCell.item.isNeedCreateRecord){
            [self attachflagsToSegue:segue cellDataItem:dashCell.item];
        }
        [swipeMenuCon.leftMasterController performSegueWithIdentifier:segue sender:self];
    });
}

@end
