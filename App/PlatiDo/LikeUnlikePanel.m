//
//  LikeUnlikePanel.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 23.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "LikeUnlikePanel.h"

@interface LikeUnlikePanel ()
@property (weak, nonatomic) IBOutlet UIButton *likeCountLbl;
@property (weak, nonatomic) IBOutlet UIButton *unlikeCountLbl;
@property (weak, nonatomic) IBOutlet UIButton *likeImg;
@property (weak, nonatomic) IBOutlet UIButton *disLikeImg;

@end


@implementation LikeUnlikePanel 

- (void)setLikeSelected:(BOOL)isSelected{
    [self.likeCountLbl setSelected:isSelected];
    [self.likeImg setSelected:isSelected];
    if (isSelected)
        [self setUnLikeSelected:!isSelected];
}

- (void)setUnLikeSelected:(BOOL)isSelected{
    [self.unlikeCountLbl setSelected:isSelected];
    [self.disLikeImg setSelected:isSelected];
    if (isSelected)
        [self setLikeSelected:!isSelected];
}


- (IBAction)likeTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(likeTapped:)]){
        [self.delegate likeTapped:self];
    }
}

- (IBAction)unlikeTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(unlikeTapped:)]){
        [self.delegate unlikeTapped:self];
    }
}

- (void)setLikeCount:(NSInteger)count{
     [self.likeImg setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:UIControlStateNormal];
}

- (void)setUnLikeCount:(NSInteger)count{
    [self.disLikeImg setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:UIControlStateNormal];
}


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self addXibContent];
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled{
    _enabled = enabled;
    self.likeCountLbl.enabled = enabled;
    self.unlikeCountLbl.enabled = enabled;
    self.likeImg.enabled = enabled;
    self.disLikeImg.enabled = enabled;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self addXibContent];
    }
    return self;
}


- (void)addXibContent{
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"LikeUnlikePanel" owner:self options:nil] firstObject];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:view];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                  options:NSLayoutFormatAlignmentMask
                                                                  metrics:nil
                                                                    views:views]];
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                  options:NSLayoutFormatAlignmentMask
                                                                  metrics:nil
                                                                    views:views]];
}

@end
