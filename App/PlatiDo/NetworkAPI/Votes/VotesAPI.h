//
//  VotesAPI.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 03.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VoteEntity;

@interface VotesAPI : NSObject
+ (void)createVote:(NSDictionary*)dictionary comBlock:(void (^)(BOOL sucess, NSError *error))comBlock;
+ (void)getListcomBlock:(void (^)(NSArray *items, NSError *error))comBlock;
+ (void)voteParameters:(NSDictionary*)parameters comBlock:(void (^)(VoteEntity *updatedVote, NSError *error))comBlock;
@end
