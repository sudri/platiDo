//
//  Comment.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 28.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "Comment.h"
#import "PhoneFormatter.h"

@implementation Comment

- (Comment *)initWithDict: (NSDictionary *)dict{

    Comment *newComment = [Comment new];
    newComment.text        = [dict valueForKey:@"text"];
    newComment.createdAt   = [PhoneFormatter dateFromServerString:[dict valueForKey:@"created_at"]];
    newComment.createdBy   = [dict valueForKey:@"created_by"];
    newComment.creatorType = ([[dict valueForKey:@"creator_type"] isEqualToString:@"user"]) ? CommentCreatorTypeUser : CommentCreatorTypeDispetcher;
    
    return newComment;
}
@end
