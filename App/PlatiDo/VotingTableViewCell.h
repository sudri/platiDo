//
//  VotingTableViewCell.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 01.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoteEntity.h"
@class VotingTableViewCell;


@protocol VotingTableViewCellProtocol <NSObject>
- (void)didTapOnVoteIncell:(VotingTableViewCell*)cell;
@end


@interface VotingTableViewCell : UITableViewCell

@property (nonatomic, weak)   id <VotingTableViewCellProtocol> delegate;
@property (nonatomic, strong) VoteEntity *voteEntity;
@property (nonatomic, strong, readonly) NSDictionary* selectedQuestion;

@end
