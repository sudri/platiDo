//
//  VotesAPI.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 03.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "VotesAPI.h"
#import "CurrentUser.h"
#import "APIRequestManager.h"
#import "VoteEntity.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImage+ImageEffects.h"

@implementation VotesAPI


+ (void)createVote:(NSDictionary*)dictionary comBlock:(void (^)(BOOL sucess, NSError *error))comBlock{
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





+ (void)voteParameters:(NSDictionary*)parameters comBlock:(void (^)(VoteEntity *updatedVote, NSError *error))comBlock{
     NSString *request = [NSString stringWithFormat:@"api/v1/voting/vote?token=%@&_method=PUT", [CurrentUserInstance token]];
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:parameters
                                                   requestType:requestTypePost success:^(id responseObject) {
                                    
                                                       if ([responseObject isKindOfClass:[NSDictionary class]]){
                                                            VoteEntity *newVote = [VoteEntity voteEntityFromDictionary:responseObject];
                                                            comBlock (newVote, nil);
                                                       }
                                                       
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                       
                                                   }];
}

+ (void)getListcomBlock:(void (^)(NSArray *items, NSError *error))comBlock{
    NSString *request = [NSString stringWithFormat:@"api/v1/voting?token=%@", [CurrentUserInstance token]];
    
    
//    "id": "int",
//    "title": "string",
//    "created_at": "string, format: 2015-10-02 17:12:45",
//    "updated_at": "string, format: 2015-10-02 17:27:25",
//    "expires_at": "string, format: 2015-10-04 17:12:45",
//    "is_active": "bool",
//    "votes_count": "int",
//    "is_owner": "bool",
//    "created_by_manager": "bool",
//    "questions": [
//                  {
//                      "id": "int",
//                      "title": "string",
//                      "votes_count": "int",
//                      "has_user_vote": "bool"
//                  }
//                  ],
//    "already_voted": "bool",
//    "images": [
//               "http:\/\/url\/to\/image.png"
//               ]
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:nil
                                                   requestType:requestTypeGet success:^(id responseObject) {
                                               
                                                       
                                                       NSMutableArray *array = [NSMutableArray new];
                                                       if ([responseObject isKindOfClass:[NSArray class]]){
                                                           for (NSDictionary *dictionary in responseObject){
                                                               VoteEntity *newVote = [VoteEntity voteEntityFromDictionary:dictionary];
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
