//
//  MeetingApi.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 28.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "MeetingLoader.h"
#import "Meeting.h"
#import "APIRequestManager.h"
#import "CurrentUser.h"
#import "CommentEntity.h"
#define LIMIT_COUNTERS_FOR_LOADING 10

@implementation MeetingLoader

- (instancetype)init
{
    self = [super init];
    if (self) {
    
    }
    return self;
}

#pragma mark - Active Meetings Loader

- (void)loadMeetingsWithType:(LoadMeetingsType)meetingsType withComblock:(void (^)(NSError *error))comblock{

    NSString *request = [NSString stringWithFormat:@"api/v1/general_meeting?token=%@", [CurrentUserInstance token]];
    
    NSDictionary    *params = @{@"limit"    : [NSString stringWithFormat:@"%lu",(unsigned long)LIMIT_COUNTERS_FOR_LOADING],
                                @"offset"   : [NSString stringWithFormat:@"%lu",(unsigned long)_activeMeetings.count],
                                @"active"   : [NSString stringWithFormat:@"%lu",(unsigned long)meetingsType]};
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request params:params
                                                   requestType:requestTypeGet success:^(id responseObject) {
                                                       
                                                       if ([responseObject isKindOfClass:[NSArray class]]){
                                                           [self meetingsLoaded:responseObject withType:meetingsType];
                                                           comblock(nil);
                                                       }
                                                   } failure:^(NSError *error) {
                                                       comblock(error);
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

- (void)meetingsLoaded:(NSArray *)loadedMeetings withType:(LoadMeetingsType)meetingsType{
    
    NSMutableArray *resultActiveMeetings = [NSMutableArray new];
    
    for (int i = 0; i < [loadedMeetings count]; i++) {
        NSDictionary *dict = loadedMeetings[i];
        Meeting *currentMeeting = [[Meeting alloc] initWithDict:dict];
        [resultActiveMeetings addObject:currentMeeting];
    }
    if (meetingsType == LoadMeetingsTypeActive) {
        _activeMeetings = [[NSArray alloc] initWithArray:resultActiveMeetings];
    }else{
        _archiveMeetings = [[NSArray alloc] initWithArray:resultActiveMeetings];
    }
}


#pragma mark - Meeting Registration

+ (void)registrateUserToMeetiong:(Meeting*)meeting comBlock:(void (^)( NSError *error))comBlock{
    
    NSDictionary *params = @{@"id" : [meeting.meetId stringValue]};
    NSString *request = [NSString stringWithFormat:@"api/v1/general_meeting/register?token=%@", [CurrentUserInstance token]];
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:params
                                                   requestType:requestTypePost success:^(id responseObject) {
                                                       comBlock(nil);
                                                       
                                                   } failure:^(NSError *error) {
                                                       comBlock(error);
                                                   }];
}

+ (void)getCommentList:(NSDictionary*)dictionary comBlock:(void (^)(NSArray *items, NSError *error))comBlock{
    NSString *request = [NSString stringWithFormat:@"api/v1/general_meeting/comments?token=%@", [CurrentUserInstance token]];
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
    
    NSString *request = [NSString stringWithFormat:@"api/v1/general_meeting/comment?token=%@", [CurrentUserInstance token]];
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


@end
