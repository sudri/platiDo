//
//  Meeting.h
//  PlatiDo
//
//  Created by Smart Labs on 08.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface Meeting : NSObject

@property (strong, nonatomic) NSNumber  * meetId;
@property (strong, nonatomic) NSString  * title;
@property (strong, nonatomic) NSString  * chairman;
@property (strong, nonatomic) NSString  * secretary;

@property (strong, nonatomic) NSDate    * createdAt;
@property (strong, nonatomic) NSDate    * endsAt;
@property (strong, nonatomic) NSDate    * startsAt;

@property (assign) BOOL isVotingOpened;
@property (assign) BOOL isRegistrationOpened;
@property (assign) BOOL isRegistered;
@property (assign) BOOL isActive;
@property (assign) NSInteger commentsCount;

@property (strong, nonatomic) NSArray   * questions;


- (Meeting *)initWithDict:(NSDictionary *)dict;
- (NSString *)getQuestionsInOrderedString;

@end
