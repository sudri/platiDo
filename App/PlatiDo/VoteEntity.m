//
//  VoteEntity.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 10.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "VoteEntity.h"
#import "PhoneFormatter.h"

@implementation VoteEntity
+ (VoteEntity*)voteEntityFromDictionary:(NSDictionary*)dictionary{


    VoteEntity *newVote   = [VoteEntity new];
    newVote.votingId      = [dictionary valueForKey:@"id"];
    newVote.title         = [dictionary valueForKey:@"title"];
    newVote.votesCount    = [[dictionary valueForKey:@"votes_count"] integerValue];
    NSString *dateNew     = [dictionary valueForKey:@"created_at"];
    newVote.creationDate  = [PhoneFormatter dateFromServerString:dateNew];
    dateNew               = [dictionary valueForKey:@"expires_at"];
    newVote.expiresDate   = [PhoneFormatter dateFromServerString:dateNew];
    newVote.arrayVariants = [dictionary valueForKey:@"questions"];
    newVote.alredyVote    = [[dictionary valueForKey:@"already_voted"] boolValue];
    newVote.isActive      = [[dictionary valueForKey:@"is_active"] boolValue];
    newVote.images        = [dictionary valueForKey:@"images"];
    return newVote;
}

- (id)init{
    self = [super init];
    if (self){
        self.arrayVariants = [NSMutableArray new];
        self.images        = [NSMutableArray new];
    }
    return self;
}

- (NSInteger)hoursTofinish{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
    NSDateComponents *components = [calendar components:NSCalendarUnitHour
                                               fromDate:[NSDate date]
                                                 toDate:self.expiresDate
                                                options:0];
    return components.hour;
}

@end
