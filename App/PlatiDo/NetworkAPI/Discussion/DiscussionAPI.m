//
//  DiscussionAPI.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 06.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DiscussionAPI.h"
#import "APIRequestManager.h"
#import "CurrentUser.h"
#import "DiscussionEntity.h"
#import "CommentEntity.h"
#import <UIKit/UIKit.h>

#import "AFHTTPRequestOperationManager.h"

@implementation DiscussionAPI
+ (void)returnLikeDiscussion:(NSDictionary*)dictionary comBlock:(void (^)(NSDictionary *response, NSError *error))comBlock{
    NSString *request = [NSString stringWithFormat:@"api/v1/discussion/like?token=%@&_method=DELETE", [CurrentUserInstance token]];
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:dictionary
                                                   requestType:requestTypePost success:^(id responseObject) {
                                                       if ([responseObject isKindOfClass:[NSDictionary class]]){
                                                           comBlock (responseObject, nil);
                                                       }
                                                       
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                       
                                                   }];
}

+ (void)setLikeDiscussion:(NSDictionary*)dictionary comBlock:(void (^)(NSDictionary *response, NSError *error))comBlock{
    NSString *request = [NSString stringWithFormat:@"api/v1/discussion/like?token=%@&_method=PUt", [CurrentUserInstance token]];
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:dictionary
                                                   requestType:requestTypePost success:^(id responseObject) {
                                                       if ([responseObject isKindOfClass:[NSDictionary class]]){
                                                           comBlock (responseObject, nil);
                                                       }
                                                       
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                       
                                                   }];

}

+ (void)returnLikeComment:(NSDictionary*)dictionary comBlock:(void (^)(NSDictionary *response, NSError *error))comBlock{
    NSString *request = [NSString stringWithFormat:@"api/v1/discussion/comment/like?token=%@&_method=DELETE", [CurrentUserInstance token]];
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:dictionary
                                                   requestType:requestTypePost success:^(id responseObject) {
                                                       if ([responseObject isKindOfClass:[NSDictionary class]]){
                                                           comBlock (responseObject, nil);
                                                       }
                                                       
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                       
                                                   }];
}

+ (void)setLikeToComment:(NSDictionary*)dictionary comBlock:(void (^)(NSDictionary *response, NSError *error))comBlock{
    NSString *request = [NSString stringWithFormat:@"api/v1/discussion/comment/like?token=%@&_method=PUT", [CurrentUserInstance token]];
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:dictionary
                                                   requestType:requestTypePost success:^(id responseObject) {
                                                       if ([responseObject isKindOfClass:[NSDictionary class]]){
                                                           comBlock (responseObject, nil);
                                                       }
                                                    
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                       
                                                   }];
}

+ (void)getCommentList:(NSDictionary*)dictionary comBlock:(void (^)(NSArray *items, NSError *error))comBlock{
    NSString *request = [NSString stringWithFormat:@"api/v1/discussion/comments?token=%@", [CurrentUserInstance token]];
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:dictionary
                                                   requestType:requestTypeGet success:^(id responseObject) {
                                                       
                                                       NSMutableArray *array = [NSMutableArray new];
                                                       
                                                       for (NSDictionary *dictionary in responseObject){
                                                           CommentEntity *new = [CommentEntity commentEntityWithDictionary:dictionary];
                                                           [array addObject:new];
                                                       }
                                                       
                                                       comBlock (array, nil);
                                                       return;
                                                       
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                       
                                                   }];
}

+ (void)createComment:(NSDictionary*)dictionary comBlock:(void (^)(CommentEntity *commentEntity, NSError *error))comBlock{
        
    NSString *request = [NSString stringWithFormat:@"api/v1/discussion/comment/add?token=%@", [CurrentUserInstance token]];
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:dictionary
                                                   requestType:requestTypePost success:^(id responseObject) {
                                                       if ([responseObject isKindOfClass:[NSDictionary class]]){
                                                           CommentEntity *comment = [CommentEntity commentEntityWithDictionary:responseObject];
                                                           comBlock (comment, nil);
                                                       }
                                                       
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                       
                                                   }];
    
}



+ (void)createDiscussion:(NSDictionary*)dictionary comBlock:(void (^)(BOOL sucess, NSError *error))comBlock{
    NSString *request = [NSString stringWithFormat:@"api/v1/voting?token=%@", [CurrentUserInstance token]];
    [[APIRequestManager sharedInstance] sendImagePostRequestToMethod:request parmeters:dictionary success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            BOOL sucess = [[responseObject valueForKey:@"id"] boolValue];
            comBlock (sucess, nil);
        } else {
            comBlock (NO, [NSError new]);
        }
    } failure:^(NSError *error) {
        comBlock (NO, error);
    }];
}

+ (void)createDiscussion:(NSString*)title images:(NSArray*)images comBlock:(void (^)(BOOL sucess, NSError *error))comBlock{

    NSDictionary *parameters = @{@"title": title,
                                 @"images":images};
    NSString *request = [NSString stringWithFormat:@"api/v1/discussion?token=%@", [CurrentUserInstance token]];
    
    [[APIRequestManager sharedInstance] sendImagePostRequestToMethod:request parmeters:parameters success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            BOOL sucess = [[responseObject valueForKey:@"id"] boolValue];
            comBlock (sucess, nil);
        } else {
            comBlock (NO, [NSError new]);
        }
    } failure:^(NSError *error) {
        comBlock (NO, error);
    }];
    
}

+ (void)getListcomBlock:(void (^)(NSArray *items, NSError *error))comBlock{
    
    NSString *request = [NSString stringWithFormat:@"api/v1/discussion?token=%@", [CurrentUserInstance token]];
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:nil
                                                   requestType:requestTypeGet success:^(id responseObject) {
                                        
                                                       NSMutableArray *array = [NSMutableArray new];
                                                       if ([responseObject isKindOfClass:[NSArray class]]){
                                                           for (NSDictionary *dictionary in responseObject){
                                                               DiscussionEntity *newVote = [DiscussionEntity discussionEntityByDictionary:dictionary];
                                                               [array addObject:newVote];
                                                           }
                                                           comBlock (array, nil);
                                                           return;
                                                       }
                                                       
                                                       
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                       
                                                   }];
    
}

@end
