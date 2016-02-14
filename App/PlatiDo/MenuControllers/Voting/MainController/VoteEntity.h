//
//  VoteEntity.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 10.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoteEntity : NSObject
+ (VoteEntity*)voteEntityFromDictionary:(NSDictionary*)dictionary;

@property (nonatomic, strong) NSString        *votingId;
@property (nonatomic, strong) NSString        *title;
@property (nonatomic, strong) NSMutableArray  *arrayVariants;
@property (nonatomic, strong) NSMutableArray  *images;
@property (nonatomic, strong) NSDate          *creationDate;
@property (nonatomic, strong) NSDate          *expiresDate;
@property (nonatomic, assign, readonly) NSInteger hoursTofinish;
@property (nonatomic, assign) NSInteger       votesCount;
@property (nonatomic, assign) BOOL            alredyVote;
@property (nonatomic, assign) BOOL            isActive;

@end
