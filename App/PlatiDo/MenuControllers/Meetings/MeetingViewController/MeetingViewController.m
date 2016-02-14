//
//  MeetingViewController.m
//  PlatiDo
//
//  Created by Smart Labs on 14.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "MeetingViewController.h"
#import "DetailMeetingViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MeetingTableViewCell.h"
#import "ArchiveMeetingTableViewCell.h"
#import "DetailArchiveMeetingViewController.h"
#import "MeetingLoader.h"
#import "Meeting.h"

#import "UIColor+Additions.h"

@interface MeetingViewController ()

@property (weak, nonatomic) IBOutlet  UILabel           * warningLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl * segmentControl;
@property (weak, nonatomic) IBOutlet UITableView        * tableView;

@property (strong , nonatomic) MeetingLoader * meetingLoader;
@end

@implementation MeetingViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.meetingLoader = [[MeetingLoader alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Meetings", nil);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    
    [self.warningLabel setHidden:YES];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [imageView setImage:[UIImage imageNamed:@"blurBg"]];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    
    [self loadActiveMeetings];
}

#pragma mark - Loader

- (void)loadActiveMeetings{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.meetingLoader loadMeetingsWithType:LoadMeetingsTypeActive withComblock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            [self.tableView reloadData];
        }
        if (self.meetingLoader.activeMeetings.count == 0) {
            [self.warningLabel  setText: NSLocalizedString(@"No information about current meetings", nil)];
            [self.warningLabel setHidden:NO];
        }
    }];
}

- (void)loadArchiveMeetings{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.meetingLoader loadMeetingsWithType:LoadMeetingsTypeArchive withComblock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            [self.tableView reloadData];
        }
        
        if (self.meetingLoader.archiveMeetings.count == 0) {
            [self.warningLabel  setText: NSLocalizedString(@"No information about past meetings", nil)];
            [self.warningLabel setHidden:NO];
        }
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    if (self.segmentControl.selectedSegmentIndex == MeetingsSelectedTypeActive){
        return [self.meetingLoader.activeMeetings count];
    }else{
        return [self.meetingLoader.archiveMeetings count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (self.segmentControl.selectedSegmentIndex == MeetingsSelectedTypeActive){
        MeetingTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MeetingTableViewCell" forIndexPath:indexPath];
        [cell setMeeting: [self.meetingLoader.activeMeetings objectAtIndex:indexPath.row]];
        return cell;
    }else{
        ArchiveMeetingTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ArchiveMeetingTableViewCell" forIndexPath:indexPath];
        [cell setCurrentMeeting:[self.meetingLoader.archiveMeetings objectAtIndex:indexPath.row]];
        return cell;
    }
}

#pragma mark - Segment Controll


- (IBAction)segmentControlChangedValue:(UISegmentedControl *)sender {
    
    [self.warningLabel setHidden:YES];
    if (self.segmentControl.selectedSegmentIndex == MeetingsSelectedTypeActive){
        if ([self.meetingLoader.activeMeetings count] == 0) {
            [self loadActiveMeetings];
        }
    }else{
        if ([self.meetingLoader.archiveMeetings count] == 0) {
            [self loadArchiveMeetings];
        }
    }
    [self.tableView reloadData];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailMeetingViewController"]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        DetailMeetingViewController *destViewController = segue.destinationViewController;
        destViewController.meeting = [self.meetingLoader.activeMeetings objectAtIndex:indexPath.row];
    }
    if ([segue.identifier isEqualToString:@"DetailArchiveMeetingSegue"]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        DetailArchiveMeetingViewController *vc = segue.destinationViewController;
        [vc setCurrentMeeting:[self.meetingLoader.archiveMeetings objectAtIndex:indexPath.row]];
    }
}

@end
