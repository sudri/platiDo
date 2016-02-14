//
//  DetailMeetingTableViewCell.m
//  PlatiDo
//
//  Created by Smart Labs on 08.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DetailMeetingTableViewCell.h"
#import "MeetingQuestion.h"

@interface DetailMeetingTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *questionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *organizerLAbel;
@property (weak, nonatomic) IBOutlet UILabel *quorumLabel;
@property (weak, nonatomic) IBOutlet UILabel *secretaryLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UIButton *loadBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loadBtnHightConstrait;

@end

@implementation DetailMeetingTableViewCell

- (void)setMeeting:(Meeting *)meeting
{
    _meeting = meeting;
    self.titleLabel.text = meeting.title;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMMM HH:mm"];
    self.dateLabel.text = [formatter stringFromDate:meeting.createdAt];
    self.secretaryLabel.text = meeting.secretary;
    self.organizerLAbel.text = meeting.chairman;
    
    self.questionsLabel.text = [_meeting getQuestionsInOrderedString];
}

- (void)setQuorum:(NSString *)quorum
{
    _quorum = quorum;
    self.quorumLabel.text = quorum;
}


- (void)hideLoadComponents:(BOOL)isHide{
    [self.loadBtn setHidden:isHide];
    [self.activity setHidden:isHide];
    if (isHide){
        self.loadBtnHightConstrait.constant = 0;
    } else {
        self.loadBtnHightConstrait.constant = 32;
    }
}

- (void)startActivity{
    [self.loadBtn setHidden:YES];
    [self.activity startAnimating];
}


- (void)stopActivity{
    [self.loadBtn setHidden:NO];
    [self.activity stopAnimating];
}

- (IBAction)loadMOrePressed:(id)sender {
    [self startActivity];
    if ([self.delegate respondsToSelector:@selector(didTapLoadMoreOnCell:)]){
        [self.delegate didTapLoadMoreOnCell:self];
    }
}

@end
