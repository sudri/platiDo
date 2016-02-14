//
//  AttachmentCollectionViewCell.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 10.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "AttachmentCollectionViewCell.h"
@interface AttachmentCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation AttachmentCollectionViewCell

- (void)awakeFromNib {
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    self.image.layer.cornerRadius = 3;
    self.image.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.image.clipsToBounds = YES;
    self.image.layer.borderWidth = 0.5;
}

- (void)updateAppiarence:(UIImage*)img{
    [self.image setImage:img];
}

@end
