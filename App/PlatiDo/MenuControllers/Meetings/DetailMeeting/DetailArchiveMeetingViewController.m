//
//  DetailArchiveMeetingViewController.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 29.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DetailArchiveMeetingViewController.h"
#import "Meeting.h"
#import "MeetingQuestion.h"

@interface DetailArchiveMeetingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *meetingTitle;
@property (weak, nonatomic) IBOutlet UILabel *meetingDate;
@property (weak, nonatomic) IBOutlet UITextView *meetingActionsTextView;

@end

@implementation DetailArchiveMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"Archive meetings", nil)];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"back"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(backVC)];
    self.navigationItem.leftBarButtonItem = backButton;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMMM HH:mm"];
    
    [self.meetingTitle setText:_currentMeeting.title];
    [self.meetingDate setText:[formatter stringFromDate:_currentMeeting.startsAt]];
    [self.meetingActionsTextView setText:[_currentMeeting getQuestionsInOrderedString]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Actions

- (IBAction)meetingProtocolTapped:(id)sender {
}

- (IBAction)meetingDesicionsTapped:(id)sender {
}

- (IBAction)meetingDetailsTapped:(id)sender {
}

- (void)backVC{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Setters

- (void)setCurrentMeeting:(Meeting *)currentMeeting{
    
    _currentMeeting = currentMeeting;
}

@end
