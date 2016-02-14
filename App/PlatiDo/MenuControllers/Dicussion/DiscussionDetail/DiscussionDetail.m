//
//  DiscussionDetail.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 30.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DiscussionDetail.h"
#import "PhotoCell.h"
#import "UIView+Additional.h"
#import "PhotoCollectionViewDataSource.h"
#import "BigTextInputView.h"
#import "VoteItemsContainer.h"
#import "CurrentUser.h"
#import "PhoneFormatter.h"
#import "FormHelper.h"
#import "DiscussionAPI.h"
#import "CommentCellTableViewCell.h"
#import "HeaderDisCommentTableViewCell.h"
#import "MBProgressHUD.h"
#import "UIView+Additional.h"
#import "UIButton+Extensions.h"
#import "UIColor+Additions.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>

#define commentPortionSize 10

@interface DiscussionDetail () <PhotoCollectionViewDataSourceProtocol, FormHelperProtocol, CommentCellTableViewCellProtocol, HeaderDisCommentTableViewCellProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewMessageAttachment;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIView *textMessageBg;
@property (weak, nonatomic) IBOutlet UIView *messagePanel;
@property (weak, nonatomic) IBOutlet BigTextInputView *textViewMessage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHconstrait;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messagePanelConstrait;


@property (strong, nonatomic)  PhotoCollectionViewDataSource *photoDataSource;
@property (strong, nonatomic)  NSMutableArray    *items;
@property (assign, nonatomic)  CGSize            keyboardSize;
@property (strong, nonatomic)  UIRefreshControl *refreshControlBottom;
@end

@implementation DiscussionDetail
- (void)viewDidLoad{
    self.items = [NSMutableArray  new];
    self.tableView.estimatedRowHeight   = 160;
    self.tableView.rowHeight            = UITableViewAutomaticDimension;
    self.navigationController.navigationBar.translucent = NO;
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blurBg"]];
    self.tableView.backgroundView = bgView;

    self.textViewMessage.textView.text = @"";
    self.textViewMessage.textView.placeholder = NSLocalizedString(@"Your comment", @"Ваш комментарий _2");
    [self.textViewMessage.textView setTextColor:[UIColor colorWithHex:0x141F77]];
   
    self.photoDataSource = [[PhotoCollectionViewDataSource alloc] initWithDelegate:self];
    self.collectionViewMessageAttachment.delegate   =  self.photoDataSource;
    self.collectionViewMessageAttachment.dataSource =  self.photoDataSource;
    [self.textViewMessage.separator setHidden:YES];
 
    [self collectionViewSetVisible:NO];
    [self.textMessageBg.layer setCornerRadius:5];
    
    self.refreshControlBottom = [UIRefreshControl new];
    self.refreshControlBottom.triggerVerticalOffset = 100.;
    [self.refreshControlBottom addTarget:self action:@selector(checkNewComment) forControlEvents:UIControlEventValueChanged];
    self.tableView.bottomRefreshControl = self.refreshControlBottom;
    
    [self getNewPortion];
}


- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    self.keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.messagePanelConstrait.constant = self.keyboardSize.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];

    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

- (void)collectionViewSetVisible:(BOOL)isVisible{
    self.collectionViewHconstrait.constant = isVisible? 60:0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setNeedsDisplay];
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    self.keyboardSize = CGSizeZero;
    self.messagePanelConstrait.constant = 0;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];

    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
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


- (void)checkNewComment{
    NSInteger offset = self.discussion.commentsCount;
    NSDictionary *dictionary = @{@"discussion_id":_discussion.discussionID,
                                 @"offset":@(offset),
                                 @"limit" :@(commentPortionSize)};
    
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    [DiscussionAPI getCommentList:dictionary comBlock:^(NSArray *items, NSError *error) {
        [MBProgressHUD  hideHUDForView:self.view animated:YES];
        [self.refreshControlBottom endRefreshing];
        self.discussion.commentsCount+=items.count;
        [self.items addObjectsFromArray:items];
        [self.tableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *myIP = [NSIndexPath indexPathForRow:self.items.count inSection:0];
            [self.tableView scrollToRowAtIndexPath:myIP atScrollPosition:UITableViewScrollPositionTop animated:YES];
        });
    }];
}

- (void)didTapLoadMoreOnCell:(HeaderDisCommentTableViewCell*)cell{
    [self getNewPortion];
}


- (void)getNewPortion{
    NSIndexPath *indexPathZero = [NSIndexPath indexPathForRow:0 inSection:0];
    HeaderDisCommentTableViewCell *cellHeader = [self.tableView cellForRowAtIndexPath:indexPathZero];
    NSInteger offset = self.discussion.commentsCount - self.items.count - commentPortionSize;
    NSInteger limit  = commentPortionSize;
    
    if (offset<0){
        offset = 0;
        limit = self.discussion.commentsCount - self.items.count;
    }
    
    if (limit == 0) {
         [cellHeader hideLoadComponents:offset==0];
        return;
    }
    
    NSDictionary *dictionary = @{@"discussion_id":_discussion.discussionID,
                                 @"offset":@(offset),
                                 @"limit" :@(limit)};
    
    [cellHeader startActivity];
    [DiscussionAPI getCommentList:dictionary comBlock:^(NSArray *items, NSError *error) {
        [cellHeader stopActivity];
        if (self.items==nil){
            self.items = [items mutableCopy];
            [self.tableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.items.count inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            });
          
        } else {
            for (NSInteger index = items.count-1; index>=0; index--){
                 CommentEntity *comment = items[index];
                 [self.items insertObject:comment atIndex:0];
            }
            [self.tableView reloadData];
        }

        [cellHeader hideLoadComponents:offset==0];//  offset==0 all items loaded
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.messagePanel setHidden:!self.discussion.isActive];
}


- (void)returnMyVote:(CommentCellTableViewCell*)cell{
    NSDictionary *dictionary = @{@"comment_id":cell.comment.commentId};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DiscussionAPI returnLikeComment:dictionary comBlock:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        cell.comment.likesCount     = [[response valueForKey:@"likes_count"] integerValue];
        cell.comment.dislikesCount  = [[response valueForKey:@"dislikes_count"] integerValue];
        cell.comment.alreadyLiked   = NO;
        [self.tableView reloadData];
    }];
    
}

- (void)didTapReponseOnComment:(CommentCellTableViewCell*)cell{
    [self startAnswerToAuthr:cell.comment.author];
}

- (void)didTapOnLike:(CommentCellTableViewCell*)cell{

    if ( cell.comment.alreadyLiked){
        [self returnMyVote:cell];
        return;
    }
    
    NSDictionary *dictionary = @{@"comment_id":cell.comment.commentId,
                                 @"is_like":@(1)};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DiscussionAPI setLikeToComment:dictionary comBlock:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        cell.comment.likesCount ++;
        cell.comment.alreadyLiked = YES;
    
        [self.tableView reloadData];
    }];
    
}

- (void)didTapOnDisLike:(CommentCellTableViewCell*)cell{
    if ( cell.comment.alreadyLiked){
        [self returnMyVote:cell];
        return;
    }
    
    NSDictionary *dictionary = @{@"comment_id":cell.comment.commentId,
                                 @"is_like":@(0)};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DiscussionAPI setLikeToComment:dictionary comBlock:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
      
        cell.comment.dislikesCount++;
        cell.comment.alreadyLiked = YES;

        [self.tableView reloadData];
    }];
}


- (void)viewDidAppear:(BOOL)animated{
    [self registerForKeyboardNotifications];
}


- (void)viewWillDisappear:(BOOL)animated{
    [self deregisterFromKeyboardNotifications];
}

- (IBAction)addImageBtnPressed:(id)sender {
    [self.photoDataSource showPhotoFrom:self PickerwithComblock:^(UIImage *image) {
        [self.textViewMessage.textView resignFirstResponder];
        self.messagePanelConstrait.constant = 0;
        [self.view setNeedsDisplay];
        [self.view layoutIfNeeded];
    }];
}


- (void)startAnswerToAuthr:(NSString*)author{
    self.textViewMessage.textView.text = [NSString stringWithFormat:@"%@, ",author ];
    [self.textViewMessage.textView becomeFirstResponder];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger countCell = self.items.count+1;// +1 couse header
    return countCell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0){
        HeaderDisCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
        cell.delegate = self;
        cell.title.text = self.discussion.title;
        cell.images = self.discussion.images;
        return cell;
    } else {
        CommentCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        [cell setComment:self.items[indexPath.row-1]];
        cell.delegate = self;
        return cell;
    }
}


- (IBAction)backBtnPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)sendBtnPRessed:(id)sender {
    NSString *trimmedText = [self.textViewMessage.textView.text stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //[self.textViewMessage.textView.text ];
    NSDictionary *dictionary = @{@"discussion_id":self.discussion.discussionID,
                                 @"comment":trimmedText};
    
    [self.textViewMessage.textView resignFirstResponder];
    self.textViewMessage.textView.text = @"";
    [self.textViewMessage updateTextViewAnim:NO];
    [self.view setNeedsDisplay];
    [self.view layoutIfNeeded];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DiscussionAPI createComment:dictionary comBlock:^(CommentEntity *commentEntity, NSError *error) {
        [MBProgressHUD  hideHUDForView:self.view animated:NO];
    
        if (commentEntity!=nil){
            [self checkNewComment];
        }
    }];
}

@end
