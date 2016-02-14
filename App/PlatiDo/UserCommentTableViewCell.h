//
//  UserCommentTableViewCell.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 04.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Comment;

@interface UserCommentTableViewCell : UITableViewCell

@property (strong, nonatomic) Comment *curComment;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *createByLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
