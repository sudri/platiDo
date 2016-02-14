//
//  DiscussionEntity.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 06.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscussionEntity : NSObject
+(DiscussionEntity*)discussionEntityByDictionary:(NSDictionary*)dictionary;

@property (nonatomic, strong)  NSNumber *discussionID;
@property (nonatomic, strong)  NSString *title;
@property (nonatomic, strong)  NSDate   *createdAt;
@property (nonatomic, strong)  NSDate   *updatedAt;
@property (nonatomic, strong)  NSArray  *images;
@property (nonatomic, assign)  BOOL isActive;
@property (nonatomic, assign)  BOOL isOwner;
@property (nonatomic, assign)  BOOL isLike;
@property (nonatomic, assign)  BOOL createdByManager;
@property (nonatomic, assign)  BOOL alreadyLiked;
@property (nonatomic, assign)  NSInteger commentsCount;
@property (nonatomic, assign)  NSInteger likesCount;
@property (nonatomic, assign)  NSInteger dislikesCount;
@end
