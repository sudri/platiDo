//
//  DiscussionEntity.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 06.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DiscussionEntity.h"
#import "PhoneFormatter.h"

@implementation DiscussionEntity

+ (DiscussionEntity*)discussionEntityByDictionary:(NSDictionary*)dictionary{
 
    DiscussionEntity *newDiscuss   = [DiscussionEntity new];
    newDiscuss.discussionID      = [dictionary valueForKey:@"id"];
    newDiscuss.likesCount    = [[dictionary valueForKey:@"likes_count"] integerValue];
    newDiscuss.dislikesCount = [[dictionary valueForKey:@"dislikes_count"] integerValue];
    newDiscuss.title         = [dictionary valueForKey:@"title"];
    newDiscuss.commentsCount = [[dictionary valueForKey:@"comments_count"] integerValue];
    NSString *dateNew        = [dictionary valueForKey:@"created_at"];
    newDiscuss.createdAt     = [PhoneFormatter dateFromServerString:dateNew];
    newDiscuss.images        = [dictionary valueForKey:@"images"];
    newDiscuss.isOwner       = [[dictionary valueForKey:@"is_owner"] boolValue];
    newDiscuss.isActive      = [[dictionary valueForKey:@"is_active"] boolValue];
    newDiscuss.alreadyLiked  = [[dictionary valueForKey:@"already_liked"] boolValue];
    newDiscuss.isLike        = [[dictionary valueForKey:@"is_like"] boolValue];
    return newDiscuss;

}


@end
