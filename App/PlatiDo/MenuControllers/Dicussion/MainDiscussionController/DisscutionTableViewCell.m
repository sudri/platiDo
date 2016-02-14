//
//  DisscutionTableViewCell.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 09.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DisscutionTableViewCell.h"
#import "UIView+Additional.h"
#import "PhoneFormatter.h"
#import "UIImageView+AFNetworking.h"
#import "UIColor+Additions.h"
#import "DiscussionAPI.h"
#import "LikeUnlikePanel.h"

@interface DisscutionTableViewCell () <LikeUnlikePanelProtocol> 
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UIView *backgroundViewMy;
@property (weak, nonatomic) IBOutlet UIImageView *imageDiscus;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hConstrait;
@property (weak, nonatomic) IBOutlet LikeUnlikePanel *likeUnlikePanel;

@property (assign, nonatomic) BOOL likeInProcessing;

@property (nonatomic) UIImage *likeImage;

@end

@implementation DisscutionTableViewCell  

- (void)likeTapped:(LikeUnlikePanel*)sender{
    __weak typeof(self.discussion) weakself = self.discussion;
    if (self.likeInProcessing) return;
    self.likeInProcessing = YES;
    
    if (self.discussion.isLike && self.discussion.alreadyLiked){
        NSDictionary *dictionary = @{@"id":self.discussion.discussionID};
        [self.likeUnlikePanel setLikeCount:--weakself.likesCount];
          [self.likeUnlikePanel setLikeSelected:NO];
        [DiscussionAPI returnLikeDiscussion:dictionary comBlock:^(NSDictionary *response, NSError *error) {
            self.likeInProcessing = NO;
            if (response !=nil && [response valueForKey:@"likes_count"]!=nil && error == nil ){
                self.discussion.alreadyLiked = NO;
                self.discussion.isLike = NO;
                weakself.likesCount = [[response valueForKey:@"likes_count"] integerValue];
                weakself.dislikesCount = [[response valueForKey:@"dislikes_count"] integerValue];
                [self.likeUnlikePanel setLikeCount:weakself.likesCount];
                [self.likeUnlikePanel setUnLikeCount:weakself.dislikesCount];
            }
        }];
    } else {
        NSDictionary *dictionary = @{@"id":self.discussion.discussionID,
                                     @"is_like":@(1)};
        [self.likeUnlikePanel setLikeCount:++weakself.likesCount];
          [self.likeUnlikePanel setLikeSelected:YES];
        if (!self.discussion.isLike && self.discussion.alreadyLiked) [self.likeUnlikePanel setUnLikeCount:--weakself.dislikesCount];
        [DiscussionAPI setLikeDiscussion:dictionary comBlock:^(NSDictionary *response, NSError *error) {
            self.likeInProcessing = NO;
            if (response !=nil && [response valueForKey:@"likes_count"]!=nil && error == nil ){
                self.discussion.alreadyLiked = YES;
                self.discussion.isLike = YES;
                weakself.likesCount = [[response valueForKey:@"likes_count"] integerValue];
                weakself.dislikesCount = [[response valueForKey:@"dislikes_count"] integerValue];
                [self.likeUnlikePanel setLikeCount:weakself.likesCount];
                [self.likeUnlikePanel setUnLikeCount:weakself.dislikesCount];
            }
        }];
    }
}




- (void)unlikeTapped:(LikeUnlikePanel*)sender{
    __weak typeof(self.discussion) weakself = self.discussion;
    if (self.likeInProcessing) return;
    self.likeInProcessing = YES;
    
    if (!self.discussion.isLike && self.discussion.alreadyLiked){
        NSDictionary *dictionary = @{@"id":self.discussion.discussionID};
        [self.likeUnlikePanel setUnLikeCount:--weakself.dislikesCount];
        [self.likeUnlikePanel setUnLikeSelected:NO];
        [DiscussionAPI returnLikeDiscussion:dictionary comBlock:^(NSDictionary *response, NSError *error) {
            self.likeInProcessing = NO;
            if (response !=nil && [response valueForKey:@"dislikes_count"]!=nil && error == nil ){
                self.discussion.alreadyLiked = NO;
                self.discussion.isLike = NO;
                weakself.likesCount    = [[response valueForKey:@"likes_count"] integerValue];
                weakself.dislikesCount = [[response valueForKey:@"dislikes_count"] integerValue];
                [self.likeUnlikePanel setLikeCount:weakself.likesCount];
                [self.likeUnlikePanel setUnLikeCount:weakself.dislikesCount];
            }
        }];
    } else {
        NSDictionary *dictionary = @{@"id":self.discussion.discussionID,
                                     @"is_like":@(0)};
         [self.likeUnlikePanel setUnLikeSelected:YES];
        [self.likeUnlikePanel setUnLikeCount:++weakself.dislikesCount];
        if (self.discussion.isLike && self.discussion.alreadyLiked) [self.likeUnlikePanel setLikeCount:--weakself.likesCount];
        [DiscussionAPI setLikeDiscussion:dictionary comBlock:^(NSDictionary *response, NSError *error) {
            self.likeInProcessing = NO;
            if (response !=nil && [response valueForKey:@"dislikes_count"]!=nil && error == nil ){
                self.discussion.alreadyLiked = YES;
                self.discussion.isLike = NO;
                weakself.likesCount    = [[response valueForKey:@"likes_count"] integerValue];
                weakself.dislikesCount = [[response valueForKey:@"dislikes_count"] integerValue];
                [self.likeUnlikePanel setLikeCount:weakself.likesCount];
                [self.likeUnlikePanel setUnLikeCount:weakself.dislikesCount];;
            }
        }];
    }
}


- (void)awakeFromNib {
    self.imageDiscus.clipsToBounds = YES;
    self.imageDiscus.layer.masksToBounds = YES;
    self.likeUnlikePanel.delegate = self;
}

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



- (void)setDiscussion:(DiscussionEntity*)discussion{
 
    _discussion = discussion;
    
    self.likeUnlikePanel.enabled = !self.discussion.isOwner;
    

    if (!self.discussion.isOwner  && self.discussion.alreadyLiked){
        if (self.discussion.isLike){
            [self.likeUnlikePanel setLikeSelected:YES];
        } else {
            [self.likeUnlikePanel setUnLikeSelected:YES];
        }
    } else {
        [self.likeUnlikePanel setUnLikeSelected:NO];
        [self.likeUnlikePanel setLikeSelected:NO];
    }
    
    
    [self.likeUnlikePanel setLikeCount:self.discussion.likesCount];
    [self.likeUnlikePanel setUnLikeCount:self.discussion.dislikesCount];
    
    
    self.titleLbl.text = _discussion.title;
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_discussion.commentsCount] forState:UIControlStateNormal];
    [self.dateLbl    setText:[PhoneFormatter formatStringDate:_discussion.createdAt]];
    
    if (_discussion.images.count>0){
        self.hConstrait.priority = UILayoutPriorityDefaultLow;
        self.aspect.priority     = UILayoutPriorityDefaultHigh;
        
        NSString *imageAdress = _discussion.images[0];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageAdress]];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        
        UIImage *cachedImage = [[[self.imageDiscus class]  sharedImageCache] cachedImageForRequest:request];
        if (cachedImage) {
            self.imageDiscus.image = cachedImage;
            return;
        }
        
        __weak DiscussionEntity* weakDisccussion = self.discussion;
        [self.imageDiscus setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            if (![weakDisccussion.discussionID integerValue] == [self.discussion.discussionID integerValue]) return;
            
            [UIView transitionWithView:self.imageDiscus
                              duration:1.0f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                self.imageDiscus.image = image;
                            } completion:nil];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [self.imageDiscus setImage:nil];
            self.hConstrait.priority = UILayoutPriorityDefaultHigh;
            self.aspect.priority     = UILayoutPriorityDefaultLow;
        }];
    } else {
        [self.imageDiscus setImage:nil];
        self.hConstrait.priority = UILayoutPriorityDefaultHigh;
        self.aspect.priority = UILayoutPriorityDefaultLow;
    }
}


- (void)drawRect:(CGRect)rect{
    [self superview];
    [self.backgroundViewMy drawShadow];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

@end
