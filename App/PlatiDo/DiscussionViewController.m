//
//  DiscussionViewController.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 09.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DiscussionViewController.h"
#import "UIColor+Additions.h"
#import "DisscutionTableViewCell.h"
#import "CommonDataProvider.h"
#import "DiscussionAPI.h"
#import "DiscussionDetail.h"
#import "MBProgressHUD.h"

@interface DiscussionViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *noActualLbl;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) DiscussionEntity *selectedItem;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation DiscussionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.tableView setContentInset:(UIEdgeInsets){8,0,0,0}];
    self.tableView.estimatedRowHeight = 412.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.tableView addSubview:self.refreshControl];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshData)
                  forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = nil;
    self.navigationItem.title = NSLocalizedString(@"Discussions", @"Обсуждения");
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x2B5ABB]}];
    
    UIImageView *imageBg = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
    [imageBg setImage:[UIImage imageNamed:@"blurBg"]];
    self.tableView.backgroundView = imageBg;
}

- (void)refreshData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DiscussionAPI getListcomBlock:^(NSArray *items, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.refreshControl endRefreshing];
        self.items = items;
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [self refreshData];
    if (CommonDataProviderInstance.createDiscuttionsAfterAppear){
        CommonDataProviderInstance.createDiscuttionsAfterAppear = NO;
        [self performSegueWithIdentifier:@"showNewDiscusForm" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"discussDetail"]){
        DiscussionDetail *discussionDetailController = segue.destinationViewController;
        discussionDetailController.discussion =  self.selectedItem ;
    }
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   self.selectedItem = self.items [indexPath.row];
   return indexPath;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DisscutionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DisscutionTableViewCellId"];
    [cell setDiscussion:self.items[indexPath.row]];
    return cell;
}

@end
