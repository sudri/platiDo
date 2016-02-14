//
//  VotingViewController.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 01.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "VotingViewController.h"
#import "VotingTableViewCell.h"
#import "UIColor+Additions.h"
#import "UIImage+ImageEffects.h"
#import "AddVoteViewController.h"
#import "CommonDataProvider.h"
#import "VotesAPI.h"
#import <MBProgressHUD.h>


@interface VotingViewController () <UITableViewDataSource, UITableViewDelegate, VotingTableViewCellProtocol>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *noActualLbl;
@property (strong, nonatomic) NSMutableArray *votesItems;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation VotingViewController

- (void)viewDidLoad{
    [self.tableView setContentInset:(UIEdgeInsets){10,0,0,0}];
    
    self.tableView.estimatedRowHeight = 420.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.navigationItem.titleView = nil;
//    self.navigationItem.title = @"Опросы";
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self
                            action:@selector(refreshData)
                  forControlEvents:UIControlEventValueChanged];
}




- (void)refreshData{
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    [VotesAPI getListcomBlock:^(NSArray *items, NSError *error) {
        [MBProgressHUD  hideHUDForView:self.view animated:YES];
        [self.refreshControl endRefreshing];
        self.votesItems = [items mutableCopy];
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [self refreshData];
    [self.tableView reloadData];
    if (CommonDataProviderInstance.createVoteAfterAppear){
        CommonDataProviderInstance.createVoteAfterAppear = NO;
        [self performSegueWithIdentifier:@"ShowAddVote" sender:self];
    }
}

- (void)didTapOnVoteIncell:(VotingTableViewCell*)cell{
 
    NSDictionary *params = @{@"voting_id":@([cell.voteEntity.votingId integerValue]),
                             @"question_id":@([cell.selectedQuestion[@"id"] integerValue])
                             };
    [VotesAPI voteParameters:params comBlock:^(VoteEntity *updatedVote, NSError *error) {
        if (updatedVote!=nil){
            NSInteger oldIndex = [self.votesItems indexOfObject:cell.voteEntity];
            [self.votesItems replaceObjectAtIndex:oldIndex withObject:updatedVote];
            [self.tableView beginUpdates];
            [cell setVoteEntity:updatedVote];
            [self.tableView endUpdates];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self.noActualLbl setHidden:self.votesItems.count>0?YES:NO];
    return self.votesItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VotingTableViewCell *cell = (VotingTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"VotingTableViewCell"];
    cell.delegate = self;
    [cell setVoteEntity:self.votesItems[indexPath.row]];
    return cell;
}

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender{
    if  ([segue.identifier isEqualToString:@"ShowAddVote"]){
        AddVoteViewController *addVoteController = segue.destinationViewController;
       // addVoteController.provider =  self.votesItems;
    }
}

@end
