//
//  CommentEntity.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 07.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "CommentEntity.h"
#import "PhoneFormatter.h"

@implementation CommentEntity
+ (CommentEntity*) commentEntityWithDictionary:(NSDictionary*)dictionary{

    CommentEntity *newComment   = [CommentEntity new];
    newComment.commentId        = [dictionary valueForKey:@"id"];
    newComment.comment          = [dictionary valueForKey:@"comment"];
    newComment.likesCount       = [[dictionary valueForKey:@"likes_count"] integerValue];
    newComment.dislikesCount    = [[dictionary valueForKey:@"dislikes_count"] integerValue];
    NSString *dateNew           = [dictionary valueForKey:@"created_at"];
    newComment.createdAt        = [PhoneFormatter dateFromServerString:dateNew];
    newComment.images           = [dictionary valueForKey:@"images"];
    newComment.isOwner          = [[dictionary valueForKey:@"is_owner"] boolValue];
    newComment.author           = [dictionary valueForKey:@"author"] ;
    newComment.alreadyLiked     = [[dictionary valueForKey:@"already_liked"] boolValue];
    newComment.isLike           = [[dictionary valueForKey:@"is_like"] boolValue];
    newComment.createdByManager = [[dictionary valueForKey:@"created_by_manager"] boolValue];
    
    return newComment;
}
@end
