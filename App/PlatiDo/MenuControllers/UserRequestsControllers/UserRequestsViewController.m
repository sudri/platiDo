//
//  ApplicationsViewController.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 28.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "UserRequestsViewController.h"
#import "UserRequestsTableViewCell.h"
#import "UserRequestsLoader.h"
#import "UserRequestModel.h"
#import "UserRequestTypeModel.h"
#import "UIColor+Additions.h"
#import "DetailUserRequestViewController.h"
#import "MBProgressHUD.h"
#import "CurrentUser.h"
#import "OwnershipHelper.h"
#import "CommonDataProvider.h"

#define HEIGHT_HEADER_SECTION 40.0

@interface UserRequestsViewController ()<UITableViewDelegate, UITableViewDataSource>{

    UserRequestsLoader *_userRequestsLoader;
}

@property (nonatomic, strong) UIRefreshControl * refreshControl;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) OwnershipHelper * ownershipHelper;

@end

@implementation UserRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [UserRequestsLoader getUserRequestTypesComBlock:^(NSArray *userRequestTypes, NSError *error) {
        if (userRequestTypes.count > 0) {
            [UserRequestTypeModel saveArrayInDefaults:userRequestTypes];
        }
    }];
    
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    _userRequestsLoader = [[UserRequestsLoader alloc] init];
    [self loadAllRequests];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needUpdateOfUserRequests) name:NEED_LIST_OF_USER_REQUESTS object:nil];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    [self loadAllRequests];
}

- (void)loadAllRequests{

    [_userRequestsLoader getApplicationsComBlock:^(NSError *error) {        
        [self.refreshControl endRefreshing];
        if (!error) {
            [UIView transitionWithView:self.tableView
                              duration:0.35f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^(void)
             {
                 [self.tableView reloadData];
             }
                            completion:nil];
        }
        
        self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];

    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
    
    if (CommonDataProviderInstance.createRequestAfterAppear){
        CommonDataProviderInstance.createRequestAfterAppear = NO;
        [self performSegueWithIdentifier:@"ShowAddRequest" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - User Actions

- (void)needUpdateOfUserRequests{
    [self loadAllRequests];
}

#pragma mark -  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  
    if (_userRequestsLoader.myRequests.count > 0 && _userRequestsLoader.actualUserRequests.count > 0) {
        return 2;
    }
    if (_userRequestsLoader.myRequests.count > 0){
        return 1;
    }
    if (_userRequestsLoader.actualUserRequests.count > 0){
        return 1;
    }
    return  0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
   
    if (_userRequestsLoader.myRequests.count > 0 && _userRequestsLoader.actualUserRequests.count > 0) {
        if (section == 0) {
            return NSLocalizedString(@"My requests", nil);
        }
        else{
            return NSLocalizedString(@"Actual requests", nil);
        }
    }
    if (_userRequestsLoader.myRequests.count > 0){
        return NSLocalizedString(@"My requests", nil);
    }
    if (_userRequestsLoader.actualUserRequests.count > 0){
        return NSLocalizedString(@"Actual requests", nil);
    }
    return  nil;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (_userRequestsLoader.myRequests.count > 0 && _userRequestsLoader.actualUserRequests.count > 0) {

        if (section == 0) {
            return [_userRequestsLoader.myRequests count];
            //return 2;
            
        }
        if (section == 1) {
            return [_userRequestsLoader.actualUserRequests count];
            //return 2;
        }
    }else{
    
        if (_userRequestsLoader.myRequests.count > 0){
            return [_userRequestsLoader.myRequests count];
        }
        if (_userRequestsLoader.actualUserRequests.count > 0){
            return [_userRequestsLoader.actualUserRequests count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UserRequestsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserRequestsTableViewCell"];
    UserRequestModel *currentRequest;
    if (_userRequestsLoader.myRequests.count > 0 && _userRequestsLoader.actualUserRequests.count > 0) {

        if (indexPath.section == 0) {
            currentRequest = _userRequestsLoader.myRequests[indexPath.row];
            [cell setCurrentUserRequestModel:currentRequest];
        }
        if (indexPath.section == 1) {
            currentRequest = _userRequestsLoader.actualUserRequests[indexPath.row];
            [cell setCurrentUserRequestModel:currentRequest];
        }
    }else{
    
        if (_userRequestsLoader.myRequests.count > 0){
            currentRequest = _userRequestsLoader.myRequests[indexPath.row];
            [cell setCurrentUserRequestModel:currentRequest];
        }
        if (_userRequestsLoader.actualUserRequests.count > 0){
            currentRequest = _userRequestsLoader.actualUserRequests[indexPath.row];
            [cell setCurrentUserRequestModel:currentRequest];
        }
    }

    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return HEIGHT_HEADER_SECTION;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor colorWithHex:0xECFDFF];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithHex:0x0F2C86]];
}

#pragma mark - Prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"DetailUserRequest"]) {
    
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        UserRequestModel *currentRequest;
        if (_userRequestsLoader.myRequests.count > 0 && _userRequestsLoader.actualUserRequests.count > 0) {

            if (indexPath.section == 0) {
                currentRequest= _userRequestsLoader.myRequests[indexPath.row];
            }
            if (indexPath.section == 1) {
                currentRequest = _userRequestsLoader.actualUserRequests[indexPath.row];
            }
        }else{
            if (_userRequestsLoader.myRequests.count > 0){
                currentRequest = _userRequestsLoader.myRequests[indexPath.row];
            }
            if (_userRequestsLoader.actualUserRequests.count > 0){
                currentRequest = _userRequestsLoader.actualUserRequests[indexPath.row];
            }
        }
        
        DetailUserRequestViewController *vc = [segue destinationViewController];
        [vc setCurrentUserRequestModel:currentRequest];
    }
}

#pragma mark - TO DO

//Коваль сделал какие то хуевые иконки. Разобраться с иконками в навигейшен баре

@end
