//
//  CommentCellTableViewCell.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 07.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "CommentCellTableViewCell.h"
#import "PhoneFormatter.h"
#import "UIButton+Extensions.h"
#import "CommonDataProvider.h"
#import "UIColor+Additions.h"
#import "LikeUnlikePanel.h"
#import "DiscussionAPI.h"

static UIImage *likeImage, *dislikeImage;

@interface CommentCellTableViewCell() <LikeUnlikePanelProtocol>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightResponceBtnConstrait;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *mainText;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *responseBtn;
@property (weak, nonatomic) IBOutlet LikeUnlikePanel *likeUnlikePanel;

@property (assign, nonatomic) BOOL likeInProcessing;

@end

@implementation CommentCellTableViewCell


- (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color {

    UIImage *img = [UIImage imageNamed:name];
    
    UIGraphicsBeginImageContext(img.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    [color setFill];
    
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return coloredImg;
};


- (void)awakeFromNib {
    self.likeUnlikePanel.delegate = self;
}


- (void)likeTapped:(LikeUnlikePanel*)sender{
    __weak typeof(self.comment) weakComment = self.comment;
    if (self.likeInProcessing) return;
    self.likeInProcessing = YES;
    
    if (self.comment.isLike && self.comment.alreadyLiked){
        [self.likeUnlikePanel setLikeSelected:NO];
        NSDictionary *dictionary = @{@"comment_id":self.comment.commentId};
        [self.likeUnlikePanel setLikeCount:--weakComment.likesCount];
        [DiscussionAPI returnLikeComment:dictionary comBlock:^(NSDictionary *response, NSError *error) {
            self.likeInProcessing = NO;
            if (response !=nil && [response valueForKey:@"likes_count"]!=nil && error == nil ){
                self.comment.alreadyLiked = NO;
                self.comment.isLike = NO;
                weakComment.likesCount = [[response valueForKey:@"likes_count"] integerValue];
                weakComment.dislikesCount = [[response valueForKey:@"dislikes_count"] integerValue];
                [self.likeUnlikePanel setLikeCount:weakComment.likesCount];
                [self.likeUnlikePanel setUnLikeCount:weakComment.dislikesCount];
            }
        }];
    } else {
        NSDictionary *dictionary = @{@"comment_id":self.comment.commentId,
                                     @"is_like":@(1)};
        [self.likeUnlikePanel setLikeSelected:YES];
        [self.likeUnlikePanel setLikeCount:++weakComment.likesCount];
        if (!self.comment.isLike && self.comment.alreadyLiked) [self.likeUnlikePanel setUnLikeCount:--weakComment.dislikesCount];
        [DiscussionAPI setLikeToComment:dictionary comBlock:^(NSDictionary *response, NSError *error) {
            self.likeInProcessing = NO;
            if (response !=nil && [response valueForKey:@"likes_count"]!=nil && error == nil ){
                self.comment.alreadyLiked = YES;
                self.comment.isLike = YES;
                weakComment.likesCount = [[response valueForKey:@"likes_count"] integerValue];
                weakComment.dislikesCount = [[response valueForKey:@"dislikes_count"] integerValue];
                [self.likeUnlikePanel setLikeCount:weakComment.likesCount];
                [self.likeUnlikePanel setUnLikeCount:weakComment.dislikesCount];
            }
        }];
    }
}


- (void)unlikeTapped:(LikeUnlikePanel*)sender{
    __weak typeof(self.comment) weakself = self.comment;
    if (self.likeInProcessing) return;
    self.likeInProcessing = YES;
    
    if (!self.comment.isLike && self.comment.alreadyLiked){
        [self.likeUnlikePanel setUnLikeSelected:NO];
        NSDictionary *dictionary = @{@"comment_id":self.comment.commentId};
        [self.likeUnlikePanel setUnLikeCount:--weakself.dislikesCount];
        [DiscussionAPI returnLikeComment:dictionary comBlock:^(NSDictionary *response, NSError *error) {
            self.likeInProcessing = NO;
            if (response !=nil && [response valueForKey:@"dislikes_count"]!=nil && error == nil ){
                self.comment.alreadyLiked = NO;
                self.comment.isLike = NO;
                
                weakself.likesCount    = [[response valueForKey:@"likes_count"] integerValue];
                weakself.dislikesCount = [[response valueForKey:@"dislikes_count"] integerValue];
                [self.likeUnlikePanel setLikeCount:weakself.likesCount];
                [self.likeUnlikePanel setUnLikeCount:weakself.dislikesCount];
            }
        }];
    } else {
        NSDictionary *dictionary = @{@"comment_id":self.comment.commentId,
                                     @"is_like":@(0)};
        
        [self.likeUnlikePanel setUnLikeCount:++weakself.dislikesCount];
        if (self.comment.isLike && self.comment.alreadyLiked) [self.likeUnlikePanel setLikeCount:--weakself.likesCount];
        [self.likeUnlikePanel setUnLikeSelected:YES];
        [DiscussionAPI setLikeToComment:dictionary comBlock:^(NSDictionary *response, NSError *error) {
            self.likeInProcessing = NO;
            
            if (response !=nil && [response valueForKey:@"dislikes_count"]!=nil && error == nil ){
                self.comment.alreadyLiked = YES;
                self.comment.isLike = NO;
                
                weakself.likesCount    = [[response valueForKey:@"likes_count"] integerValue];
                weakself.dislikesCount = [[response valueForKey:@"dislikes_count"] integerValue];
                [self.likeUnlikePanel setLikeCount:weakself.likesCount];
                [self.likeUnlikePanel setUnLikeCount:weakself.dislikesCount];;
            }
        }];
    }
}


- (IBAction)responseBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didTapReponseOnComment:)]){
        [self.delegate didTapReponseOnComment:self];
    }
}

- (void)setComment:(CommentEntity *)comment{
    _comment = comment;
    
    self.title.text     = comment.author;
    self.mainText.text  = comment.comment;
    self.dateLabel.text = [PhoneFormatter formatStringDate:comment.createdAt];
    
    self.heightResponceBtnConstrait.constant = comment.isOwner?0:30;
    [self.likeUnlikePanel setLikeCount:comment.likesCount];
    [self.likeUnlikePanel setUnLikeCount:comment.dislikesCount];
    if (!self.comment.isOwner  && self.comment.alreadyLiked){
        if (self.comment.isLike){
            [self.likeUnlikePanel setLikeSelected:YES];
        } else {
            [self.likeUnlikePanel setUnLikeSelected:YES];
        }
    } else {
        [self.likeUnlikePanel setUnLikeSelected:NO];
        [self.likeUnlikePanel setLikeSelected:NO];
    }
  
    [self.likeUnlikePanel setEnabled:!self.comment.isOwner];
    [self.responseBtn setHidden:self.comment.isOwner];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

- (void)hideLikePanel:(BOOL)isHide{
    [self.likeUnlikePanel setHidden:isHide];
}

@end
