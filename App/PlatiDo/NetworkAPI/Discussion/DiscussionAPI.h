//
//  DiscussionAPI.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 06.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CommentEntity;

@interface DiscussionAPI : NSObject
+ (void)createDiscussion:(NSString*)title images:(NSArray*)images comBlock:(void (^)(BOOL sucess, NSError *error))comBlock;
+ (void)getListcomBlock:(void (^)(NSArray *items, NSError *error))comBlock;
+ (void)createComment:(NSDictionary*)dictionary comBlock:(void (^)(CommentEntity *commentEntity, NSError *error))comBlock;
+ (void)getCommentList:(NSDictionary*)dictionary comBlock:(void (^)(NSArray *items, NSError *error))comBlock;
+ (void)setLikeToComment:(NSDictionary*)dictionary comBlock:(void (^)(NSDictionary *response, NSError *error))comBlock;
+ (void)returnLikeComment:(NSDictionary*)dictionary comBlock:(void (^)(NSDictionary *response, NSError *error))comBlock;
+ (void)setLikeDiscussion:(NSDictionary*)dictionary comBlock:(void (^)(NSDictionary *response, NSError *error))comBlock;
+ (void)returnLikeDiscussion:(NSDictionary*)dictionary comBlock:(void (^)(NSDictionary *response, NSError *error))comBlock;
@end
