//
//  CommentCellTableViewCell.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 07.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentEntity.h"


@class CommentCellTableViewCell;

@protocol CommentCellTableViewCellProtocol <NSObject>
- (void)didTapReponseOnComment:(CommentCellTableViewCell*)cell;
- (void)didTapOnLike:(CommentCellTableViewCell*)cell;
- (void)didTapOnDisLike:(CommentCellTableViewCell*)cell;
@end

@interface CommentCellTableViewCell : UITableViewCell

@property (nonatomic, strong) CommentEntity *comment;
@property (nonatomic, weak)  id <CommentCellTableViewCellProtocol> delegate;

- (void)hideLikePanel:(BOOL)isHide;

@end
