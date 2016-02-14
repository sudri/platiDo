//
//  Meeting.m
//  PlatiDo
//
//  Created by Smart Labs on 08.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "Meeting.h"
#import "MeetingQuestion.h"
#import "PhoneFormatter.h"

@implementation Meeting

- (Meeting *)initWithDict:(NSDictionary *)dict{

    Meeting *newMeeting = [[Meeting alloc]init];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
//    [dateFormatter setDateFormat:@"MM.yyyy"];

    
    newMeeting.meetId               = [dict valueForKey:@"id"];
    newMeeting.title                = [dict valueForKey:@"title"];
    newMeeting.chairman             = [dict valueForKey:@"chairman"];
    newMeeting.secretary            = [dict valueForKey:@"secretary"];

    newMeeting.createdAt            = [PhoneFormatter dateFromServerString:[dict valueForKey:@"created_at"]];
    newMeeting.endsAt               = [PhoneFormatter dateFromServerString:[dict valueForKey:@"ends_at"]];
    newMeeting.startsAt             = [PhoneFormatter dateFromServerString:[dict valueForKey:@"starts_at"]];

    newMeeting.isVotingOpened       = [[dict valueForKey:@"is_voting_opened"] boolValue];
    newMeeting.isRegistrationOpened = [[dict valueForKey:@"is_registration_opened"] boolValue];
    newMeeting.isRegistered         = [[dict valueForKey:@"is_registered"] boolValue];
    newMeeting.isActive             = [[dict valueForKey:@"is_active"] boolValue];
    newMeeting.commentsCount        = [[dict valueForKey:@"comments_count"] integerValue];
    newMeeting.questions            = [MeetingQuestion getQuestionsArrayFromDicts:[dict valueForKey:@"questions"]];
    
    return newMeeting;
}


- (NSString *)getQuestionsInOrderedString{
    
    int num = 1;
    NSString *string = @"";
    
    for (MeetingQuestion *currentQuestion in self.questions){
        string = [string stringByAppendingString:[NSString stringWithFormat:@"%d. %@ \n", num, currentQuestion.title]];
        num++;
    }
    return string;
}

@end
