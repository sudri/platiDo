//
//  CommentEntity.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 07.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentEntity : NSObject

+ (CommentEntity*) commentEntityWithDictionary:(NSDictionary*)dictionary;

@property (nonatomic, strong) NSString  *commentId;
@property (nonatomic, strong) NSString  *comment;
@property (nonatomic, assign) NSInteger likesCount;
@property (nonatomic, assign) NSInteger dislikesCount;
@property (nonatomic, strong) NSDate    *createdAt;
@property (nonatomic, strong) NSDate    *updatedAt;
@property (nonatomic, assign) BOOL      isOwner;
@property (nonatomic, assign) BOOL      createdByManager;
@property (nonatomic, strong) NSString  *author;
@property (nonatomic, assign) BOOL      alreadyLiked;
@property (nonatomic, assign) BOOL      isLike;
@property (nonatomic, strong) NSArray   *images;


@end
