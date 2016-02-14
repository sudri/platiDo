//
//  DetailMeetingViewController.m
//  PlatiDo
//
//  Created by Smart Labs on 14.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DetailMeetingViewController.h"
#import "DetailMeetingTableViewCell.h"
#import "MeetingVoteViewController.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+MyBlur.h"
#import "UIView+Screenshot.h"
#import "CommentCellTableViewCell.h"
#import "BigTextInputView.h"
#import "PhotoCollectionViewDataSource.h"
#import "MeetingLoader.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "CurrentUser.h"
#import "UIColor+Additions.h"

#define commentPortionSize 10

typedef enum : NSUInteger {
    DetailMeetingTypeRegistration,
    DetailMeetingTypeVote
} DetailMeetingType;

@interface DetailMeetingViewController ()<UITableViewDelegate, UITableViewDataSource, PhotoCollectionViewDataSourceProtocol, BigTextInputViewProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *quorumLabel;
@property (nonatomic)       DetailMeetingType detailMeetingType;

@property (strong, nonatomic) NSMutableArray *comments;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageBconstraits;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messagePanelConstrait;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewMessageAttachment;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIView *textMessageBg;
@property (weak, nonatomic) IBOutlet UIView *messagePanel;
@property (weak, nonatomic) IBOutlet BigTextInputView *textViewMessage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHconstrait;

@property (strong, nonatomic)  PhotoCollectionViewDataSource *photoDataSource;
@property (assign, nonatomic)  CGSize     keyboardSize;

@property (weak, nonatomic) IBOutlet UIButton *registrationButton;
@end

@implementation DetailMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = NSLocalizedString(@"Meetings", nil);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"back"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(backVC)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.messagePanel.hidden = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    
    self.textViewMessage.textView.text = @"";
    self.textViewMessage.textView.placeholder = NSLocalizedString(@"Your comment", @"Ваш комментарий _2");
    [self.textViewMessage.textView setTextColor:[UIColor colorWithHex:0x141F77]];
    self.textViewMessage.delegate = self;
    
    self.photoDataSource = [[PhotoCollectionViewDataSource alloc] initWithDelegate:self];
    self.collectionViewMessageAttachment.delegate   =  self.photoDataSource;
    self.collectionViewMessageAttachment.dataSource =  self.photoDataSource;
    [self.textViewMessage.separator setHidden:YES];
    
    [self collectionViewSetVisible:NO];
    [self.textMessageBg.layer setCornerRadius:5];
    
    
    self.comments = [[NSMutableArray alloc] init];

    [self checkRegistration];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.tableView.frame];
    [imageView setImage:[UIImage imageNamed:@"blurBg"]];
    
    self.tableView.backgroundView = imageView;
  
    [self getNewPortion];
}

- (void)checkNewComment{
    NSInteger offset = self.meeting.commentsCount;
    NSDictionary *dictionary = @{@"meeting_id":self.meeting.meetId,
                                 @"offset":@(offset),
                                 @"limit" :@(commentPortionSize)};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MeetingLoader getCommentList:dictionary comBlock:^(NSArray *items, NSError *error) {
        [MBProgressHUD  hideHUDForView:self.view animated:YES];
       // [self.refreshControlBottom endRefreshing];
        self.meeting.commentsCount+=items.count;
        [self.comments addObjectsFromArray:items];
        [self.tableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *myIP = [NSIndexPath indexPathForRow:self.comments.count inSection:0];
            [self.tableView scrollToRowAtIndexPath:myIP atScrollPosition:UITableViewScrollPositionTop animated:YES];
        });
    }];
}

- (void)getNewPortion{
    NSIndexPath *indexPathZero = [NSIndexPath indexPathForRow:0 inSection:0];
    DetailMeetingTableViewCell *cellHeader = [self.tableView cellForRowAtIndexPath:indexPathZero];
    NSInteger offset = self.meeting.commentsCount - self.comments.count - commentPortionSize;
    NSInteger limit  = commentPortionSize;
    
    if (offset<0){
        offset = 0;
        limit = self.meeting.commentsCount - self.comments.count;
    }
    
    if (limit == 0) {
        [cellHeader hideLoadComponents:offset==0];
        return;
    }
    
    NSDictionary *dictionary = @{@"meeting_id":self.meeting.meetId,
                                 @"offset":@(offset),
                                 @"limit" :@(limit)};
    
    [cellHeader startActivity];
    [MeetingLoader getCommentList:dictionary comBlock:^(NSArray *items, NSError *error) {
        [cellHeader stopActivity];
        if (self.comments==nil){
            self.comments = [items mutableCopy];
            [self.tableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.comments.count inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            });
            
        } else {
            for (NSInteger index = items.count-1; index>=0; index--){
                CommentEntity *comment = items[index];
                [self.comments insertObject:comment atIndex:0];
            }
            [self.tableView reloadData];
        }
        
        [cellHeader hideLoadComponents:offset==0];//  offset==0 all items loaded
    }];
}


#pragma mark - Keyboard

- (void)keyboardWasShown:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    
    self.keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    self.messagePanelConstrait.constant = self.keyboardSize.height;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // workself
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    self.keyboardSize = CGSizeZero;
    self.messagePanelConstrait.constant = 45;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.textViewMessage setNeedsLayout];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self deregisterFromKeyboardNotifications];
}

- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)deregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0)
    {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"MeetingCell" forIndexPath:indexPath];
        DetailMeetingTableViewCell *dCell = (DetailMeetingTableViewCell *)cell;
        dCell.meeting = self.meeting;
        if (self.detailMeetingType == DetailMeetingTypeVote)
        {
            dCell.quorum = NSLocalizedString(@"Quorum", nil);
        }
    }else{
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
        CommentCellTableViewCell *commcentCell = (CommentCellTableViewCell *)cell;
        [commcentCell hideLikePanel:YES];
        commcentCell.comment = [self.comments objectAtIndex:indexPath.row - 1];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (cell.tag != 1){
        [cell setBackgroundColor:[UIColor clearColor]];
    }
}

#pragma mark - User Actions

- (void)backVC{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)tapSendComment:(UIButton *)sender {

        NSString *trimmedText = [self.textViewMessage.textView.text stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //[self.textViewMessage.textView.text ];
        NSDictionary *dictionary = @{@"meeting_id":self.meeting.meetId,
                                     @"comment":trimmedText};
        
        [self.textViewMessage.textView resignFirstResponder];
        self.textViewMessage.textView.text = @"";
        [self.textViewMessage updateTextViewAnim:NO];
        [self.view setNeedsDisplay];
        [self.view layoutIfNeeded];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [MeetingLoader createComment:dictionary comBlock:^(CommentEntity *commentEntity, NSError *error) {
            [MBProgressHUD  hideHUDForView:self.view animated:NO];
            
            if (commentEntity!=nil){
                [self checkNewComment];
            }
        }];
    
}
- (IBAction)tapAttach:(UIButton *)sender {
}

- (void)collectionViewSetVisible:(BOOL)isVisible{
    self.collectionViewHconstrait.constant = isVisible? 60:0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setNeedsDisplay];
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)tapRegistration:(UIButton *)sender {
    
    if (self.detailMeetingType == DetailMeetingTypeRegistration)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [MeetingLoader registrateUserToMeetiong:_meeting comBlock:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!error) {
                [_meeting setIsRegistered:YES];
                [self checkRegistration];
            }
        }];
    } else {
        [self performSegueWithIdentifier:@"MeetingVote" sender:nil];
    }
}

#pragma mark - Setters

- (void)setMeeting:(Meeting *)meeting{
    _meeting = meeting;
}

- (void)checkRegistration{
    if (_meeting.isRegistered) {
        [self.registrationButton setTitle:NSLocalizedString(@"Vote", nil) forState:UIControlStateNormal];
        self.detailMeetingType = DetailMeetingTypeVote;
        self.messageBconstraits.constant += 45;
        [self.view setNeedsDisplay];
        [self.view layoutIfNeeded];
        [self.tableView reloadData];
     }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MeetingVote"]){
        MeetingVoteViewController *vc = segue.destinationViewController;
        UIImage *screenShot = [self.navigationController.view screenshot];
        UIImage *blurImage  = [screenShot blurredImageWithRadius:17.5 iterations:2 tintColor:nil];
        vc.blurredImage = blurImage;
        vc.meeting = self.meeting;
    }
}

- (void)changeTextBigTextInputView:(BigTextInputView *)textView
{
    NSLog(@"%f %f %f", textView.textView.contentOffset.y, textView.textView.contentSize.height, textView.textView.frame.size.height);
//    NSRange range = NSMakeRange(textView.textView.text.length - 1, 1);
//    [textView.textView scrollRangeToVisible:range];
}

@end
