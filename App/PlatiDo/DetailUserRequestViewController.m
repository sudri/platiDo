//
//  DetailUserRequestViewController.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 03.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DetailUserRequestViewController.h"
#import "UserRequestModel.h"
#import "CustomHeaderView.h"
#import "UserCommentTableViewCell.h"
#import "UIColor+Additions.h"
#import "UIPlaceHolderTextView.h"
#import "AddUserRequestApi.h"
#import "CurrentUser.h"
#import "AnimationModel.h"
#import "MBProgressHUD.h"
#import "RatingViewController.h"
#import "UIView+Screenshot.h"
#import "UIImage+MyBlur.h"
#import "AlertViewCustom.h"
#import "FormHelper.h"

#define EMPTY_CELL_HEIGHT       90.0
#define HEIGHT_HEADER_SECTION   30.0

@interface DetailUserRequestViewController ()<UIScrollViewDelegate, RatingViewDelegate, FormHelperProtocol>{

    AnimationModel  *_animationModel;
}

@property (weak, nonatomic) IBOutlet UITableView                *tableView;
@property (weak, nonatomic) IBOutlet UIButton                   *closeRequestButton;
@property (weak, nonatomic) IBOutlet UIButton                   *addCommentButton;

@property (weak, nonatomic) IBOutlet UIView                     *closeRequestView;

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView      *commentTextView;

@property (strong, nonatomic)  FormHelper                       *formHelper;

@end

@implementation DetailUserRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.formHelper = [[FormHelper alloc] init];
    self.formHelper.delegate = self;
    [self.formHelper setScrollView:self.tableView];
    [self.formHelper setScrollContentView:self.tableView];
    [self.formHelper setFormView:self.tableView.tableFooterView];
    [self.formHelper setRootView:self.view];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"back"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(backVC)];
    
    self.navigationItem.leftBarButtonItem = backButton;

    _animationModel = [[AnimationModel alloc] initWithViewsArray:@[self.commentTextView]];

    CustomHeaderView *customHeader =  [[[NSBundle mainBundle] loadNibNamed:@"CustomHeaderView"
                                                                     owner:self
                                                                   options:nil]
                                                                objectAtIndex:0];
    [customHeader setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200)];
    
    [customHeader setCurrentUserRequestModel:_currentUserRequestModel];
    self.tableView.tableHeaderView = customHeader;
    
    self.tableView.estimatedRowHeight   = EMPTY_CELL_HEIGHT;
    self.tableView.rowHeight            = UITableViewAutomaticDimension;
    [self.tableView setSeparatorColor:[UIColor colorWithHex:0x9A9A9A]];
    
    [self.commentTextView setPlaceholder:NSLocalizedString(@"Input your comment", nil)];
    [self.commentTextView setPlaceholderColor:[UIColor colorWithHex:0xCECECE]];
    
    self.closeRequestButton.layer.cornerRadius = 3;
    self.closeRequestButton.clipsToBounds = YES;

    UIView *footer = self.tableView.tableFooterView;
    
    [footer.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    [footer.layer setShadowOffset:CGSizeMake(0.0, 1.0)];
    [footer.layer setShadowOpacity:0.5];
    [footer.layer setShadowRadius:2.0];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(3, 3, 3, 3);
    
    UIImage *originalImage1 = [UIImage imageNamed:@"send_button"];
    UIImage *stretchableImage1 = [originalImage1 resizableImageWithCapInsets:insets];
    [self.addCommentButton setBackgroundImage:stretchableImage1 forState:UIControlStateNormal];
    
    [self.addCommentButton setTitleColor:[UIColor colorWithHex:0x2B5ABB] forState:UIControlStateNormal];

    [self statusModification];
}


- (void)viewWillAppear:(BOOL)animated{
    [self.formHelper registerMe];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.formHelper unregisterMe];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Setters
- (void)setCurrentUserRequestModel:(UserRequestModel *)currentUserRequestModel{

    _currentUserRequestModel = currentUserRequestModel;
    NSString *title = (_currentUserRequestModel.group == UserRequestGroupMy) ? NSLocalizedString(@"My requests", nil) : NSLocalizedString(@"Actual requests", nil);
    [self setTitle:title];
}

- (void)statusModification{

    if (_currentUserRequestModel.group == UserRequestGroupMy) {
      
        if (_currentUserRequestModel.status == UserRequestComplete) {
            self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.closeRequestView.frame), 0.0f);
            self.tableView.tableFooterView  = [[UIView alloc] initWithFrame:CGRectZero];
        }else{
            self.closeRequestView.hidden    = YES;
        }
    }else{
        self.tableView.tableFooterView  = [[UIView alloc] initWithFrame:CGRectZero];
        self.closeRequestView.hidden    = YES;
    }
}

#pragma mark -  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (_currentUserRequestModel.group == UserRequestGroupActual) {
       
        return NSLocalizedString(@"Comments not available", nil);
    }

//    if ([_currentUserRequestModel.comments count] > 0) {
        return NSLocalizedString(@"Comments", nil);
//    }
//    else return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_currentUserRequestModel.group == UserRequestGroupActual) {
        return 0;
    }

    return [_currentUserRequestModel.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserCommentTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"UserCommentTableViewCell"];
    
    Comment *curComment = _currentUserRequestModel.comments[indexPath.row];
    [cell setCurComment:curComment];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return HEIGHT_HEADER_SECTION;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor clearColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithHex:0x7E7E7E]];
    [header.textLabel setTextAlignment:NSTextAlignmentCenter];
}

#pragma mark - User Actions

- (void)backVC{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)addCommentTapped:(id)sender {
    
    if (self.commentTextView.text.length > 1) {
        
        NSDictionary *dict = @{@"id"      : [_currentUserRequestModel.reqId stringValue],
                               @"comment" : self.commentTextView.text};
        
        [self dismissKeyboard];
        
        [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
        [AddUserRequestApi addUserCommentToRequest:dict comBlock:^(id responseObject, NSError *error) {
            [MBProgressHUD  hideHUDForView:self.view animated:YES];

            if (!error) {
                Comment *newComment  = [Comment new];
                newComment.text      = self.commentTextView.text;
                newComment.createdAt = [NSDate date];
                newComment.createdBy = [NSString stringWithFormat:@"%@ %@", [CurrentUserInstance surname], [CurrentUserInstance name]];
                
                [_currentUserRequestModel.comments addObject:newComment];
                
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:[_currentUserRequestModel.comments count] - 1 inSection:0];
                
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
                
                self.commentTextView.text = @"";
            }
            
#warning TODO: User Request errors processing
        }];
    }
    else{
        
        [_animationModel shakeTF];
    }
}


#pragma mark - PrepareForSegue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"RateServiceQuolitySegue"]) {
        
        UIImage *screenShot = [self.navigationController.view screenshot];
        UIImage *blurImage  = [screenShot blurredImageWithRadius:17.5 iterations:2 tintColor:nil];

        RatingViewController *ratingVC = (RatingViewController *)[segue destinationViewController];
        [ratingVC.view setFrame:self.view.bounds];
        [ratingVC setBlurredImage:blurImage];
        [ratingVC setCurrentUserRequestModel:_currentUserRequestModel];
        ratingVC.delegate = self;
    }
}

#pragma mark - RatingViewDelegate

-(void)userRequestClosed{
    
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.tableView.tableFooterView  = [[UIView alloc] initWithFrame:CGRectZero];
    self.closeRequestView.hidden    = YES;

    [[NSNotificationCenter defaultCenter] postNotificationName:NEED_LIST_OF_USER_REQUESTS object:nil];
    
    [self performSelector:@selector(backVC) withObject:nil afterDelay:.5];
    [AlertViewCustom userRequestClosedSuccessfully];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
 
    [self dismissKeyboard];
}

#pragma mark - Keyboard

-(void)scrollDidUp{

}

-(void)scrollDidDown{

}

//- (void)notificationKeyboardWillShow:(NSNotification *)notification {
//
//    NSDictionary* keyboardInfo = [notification userInfo];
//    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
//    
////    CGFloat animationDuration  =  [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    
//    CGPoint newContentOffset = CGPointMake(0, self.tableView.contentSize.height -  CGRectGetHeight(keyboardFrameBeginRect) - 50);
//    [self.tableView setContentOffset:newContentOffset animated:YES];
//}
//
//
//- (void)notificationKeyboardWillHide:(NSNotification *)notification {
//    
////    NSDictionary* keyboardInfo = [notification userInfo];
////    CGFloat animationDuration  =  [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//}

-(void)dismissKeyboard {
    [self.commentTextView resignFirstResponder];
}

@end
