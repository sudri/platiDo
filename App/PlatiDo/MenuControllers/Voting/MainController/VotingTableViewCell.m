//
//  VotingTableViewCell.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 01.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "VotingTableViewCell.h"
#import "CustomCheckbox.h"
#import "ChartItem.h"
#import "UIView+Additional.h"
#import "VoteItemsContainer.h"
#import "PhoneFormatter.h"
#import "UIImageView+AFNetworking.h"

@interface VotingTableViewCell()

@property (weak, nonatomic) IBOutlet VoteItemsContainer *subVot;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainImageH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *acpect;

@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIView *bgViewCustom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnH;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *voteBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end






//#import "UIColor+Additions.h"
//
//@implementation CustomButtonYellow
//
//- (void)awakeFromNib{
//    self.layer.cornerRadius = 2.5;
//    self.clipsToBounds = YES;
//    self.backgroundColor = [UIColor whiteColor];
//    
//    [self setBackgroundImage:[UIColor imageWithColor:[UIColor colorWithHex:0xFFCA00 alpha:1]]
//                    forState:UIControlStateNormal];
//    
//    [self setBackgroundImage:[UIColor imageWithColor:[UIColor colorWithHex:0xF8E28C alpha:0.8]]
//                    forState:UIControlStateDisabled];



@implementation VotingTableViewCell

- (void)awakeFromNib {
    self.subVot.offsetItems = 10;
   

    [self.subVot setBackgroundColor:[UIColor clearColor]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(onTap:)];
    [self.subVot addGestureRecognizer:tap];
    [self.subVot clear];
    [self.voteBtn setEnabled:NO];
    
    self.mainImage.clipsToBounds = YES;
    self.mainImage.layer.masksToBounds = YES;
    
}

- (void)setVoteEntity:(VoteEntity*)entity{
    _voteEntity = entity;
    self.dateLabel.text     = [PhoneFormatter  formatStringDate:_voteEntity.creationDate];
    self.titleLbl.text      = entity.title;
    
 
    
    if (_voteEntity.isActive){
        self.btnH.constant = 40;
        self.leftTimeLabel.text = [NSString stringWithFormat:@"%@ %ld %@",NSLocalizedString(@"left", @"осталось"), (long)entity.hoursTofinish, @"ч."];
    } else {
        self.btnH.constant = 0;
        self.leftTimeLabel.text = @"Голосование завершено";
    }
    
    
    if (entity.images.count>0){
        self.mainImageH.priority = UILayoutPriorityDefaultLow;
        self.acpect.priority     = UILayoutPriorityDefaultHigh;
        
        NSString *imageAdress = [entity.images firstObject];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageAdress]];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        UIImage *cachedImage = [[[self.mainImage  class]  sharedImageCache] cachedImageForRequest:request];
        
        if (cachedImage) {
            self.mainImage.image = cachedImage;
        } else {
            [self.mainImage setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                
                [UIView transitionWithView:self.mainImage
                                  duration:1.0f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    self.mainImage.image = image;
                                } completion:nil];
                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                [self.mainImage setImage:nil];
                self.mainImageH.priority = UILayoutPriorityDefaultHigh;
                self.acpect.priority     = UILayoutPriorityDefaultLow;
            }];
        }
    } else {
        [self.mainImage setImage:nil];
        self.mainImageH.priority = UILayoutPriorityDefaultHigh;
        self.acpect.priority     = UILayoutPriorityDefaultLow;
    }
    
    if (_voteEntity.alredyVote || !_voteEntity.isActive){
        [self showResults];
    } else {
        [self showVotingList];
    }
    
    
    if (_voteEntity.alredyVote){
        [self.voteBtn setTitle:@"Вы уже отдали свой голос" forState:UIControlStateDisabled];
    } else {
        [self.voteBtn setTitle:@"Голосовать" forState:UIControlStateDisabled];
    }
    
    [self checkVoteBtnEnabled];
    
}


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.bgViewCustom.backgroundColor = [UIColor whiteColor];
    [self.bgViewCustom drawShadow];
}


- (void)showVotingList{
    
    [self.subVot clear];
    self.subVot.offsetItems = 10;
    
    for (NSDictionary *dictionary in self.voteEntity.arrayVariants){
            CustomCheckbox *item = [[CustomCheckbox alloc] init];
            item.title.text = [dictionary valueForKey:@"title"];;
            [self.subVot addItem:item];
    }
}


- (void)checkVoteBtnEnabled{
    [self.voteBtn setEnabled:NO];
    for (id checkView in self.subVot.subviews){
        if ([checkView isKindOfClass:[CustomCheckbox class]]){
            CustomCheckbox *check = checkView;
            if (check.isSelected){
                [self.voteBtn setEnabled:YES];
                break;
            }
        }
    }
}


- (void)showResults{

   // self.btnH.constant = 0;
   
    [self.subVot clear];
    self.subVot.offsetItems = 5;
  
    for (NSDictionary *dictionary in self.voteEntity.arrayVariants){
        NSString *text = dictionary[@"title"];
        ChartItem *item = [[ChartItem alloc] init];
        item.title.text = text;
        
        NSInteger questionVotesCount = [dictionary[@"votes_count"] integerValue];
        CGFloat procent = 0;
        if (self.voteEntity.votesCount>0){
            CGFloat oneProcent = self.voteEntity.votesCount/100.0;
            procent = questionVotesCount/oneProcent;
        }
        [item setProcend:procent];
        [self.subVot addItem:item];
    }
}

- (NSDictionary*)selectedQuestion{
    NSInteger counter = 0;
    for (CustomCheckbox *check in self.subVot.subviews){
        if (check.isSelected){
            NSDictionary *result = self.voteEntity.arrayVariants[counter];
            return result;
        }
        counter++;
    }
    return nil;
}

- (void)onTap:(UITapGestureRecognizer*)tap{
    
    CGPoint touchPoint = [tap locationInView:self.subVot];
    for (CustomCheckbox *check in self.subVot.subviews){
        if (CGRectContainsPoint(check.frame, touchPoint)){
            [check setSelected:YES];
            [self.voteBtn setEnabled:YES];
        } else {
            [check setSelected:NO];
        }
    }
    
}

- (IBAction)voteBtnPressed:(id)sender {

    if ([self.delegate respondsToSelector:@selector(didTapOnVoteIncell:)]){
        [self.delegate didTapOnVoteIncell:self];
    }
}


@end
