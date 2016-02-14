//
//  Application.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 28.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "UserRequestModel.h"

@implementation UserRequestModel

- (UserRequestModel *)initWithDict: (NSDictionary *)dict{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    UserRequestModel *newRequest = [UserRequestModel new];
    
    newRequest.reqId                = [dict valueForKey:@"id"];
    newRequest.subject              = [dict valueForKey:@"subject"];
    newRequest.reqDescription       = [dict valueForKey:@"description"];

    newRequest.statusText           = [dict valueForKey:@"status_text"];
    newRequest.type                 = [dict valueForKey:@"type"];
    newRequest.createdAt            = [dateFormatter dateFromString:[dict valueForKey:@"created_at"]];
    newRequest.closedAt             = [dateFormatter dateFromString:[dict valueForKey:@"closed_at"]];
    newRequest.is_closed            = [[dict valueForKey:@"is_closed"] boolValue];

    newRequest.status               = UserRequestUndefined;
    newRequest.group                = UserRequestGroupActual;
    
    if ([[dict valueForKey:@"group"] isEqualToString:@"my"]) {
        newRequest.group = UserRequestGroupMy;
    }
    if ([[dict valueForKey:@"group"] isEqualToString:@"actual"]) {
        newRequest.group = UserRequestGroupActual;
    }

    
    if ([[dict valueForKey:@"status"] isEqualToString:@"new"]) {
        newRequest.status = UserRequestNew;
    }
    if ([[dict valueForKey:@"status"] isEqualToString:@"in_process"]) {
        newRequest.status = UserRequestProcessing;
    }
    if ([[dict valueForKey:@"status"] isEqualToString:@"closed"]) {
        newRequest.status = UserRequestComplete;
    }
    
    NSArray *comments = [dict valueForKey:@"comments"];
    newRequest.comments = [NSMutableArray new];
    if (comments.count > 0) {
        for (int i = 0; i < [comments count]; i++ ) {
            NSDictionary  * comDict     = comments[i];
            Comment       * curComment  = [[Comment alloc] initWithDict:comDict];
            if (curComment) {
                [newRequest.comments addObject:curComment];
            }
        }
    }
    
    return newRequest;
}

//+ (JSONKeyMapper*)keyMapper{
//    return [[JSONKeyMapper alloc] initWithDictionary:@{
//                                                       @"id"            : @"appId",
//                                                       @"description"   : @"apDescription",
//                                                       @"created_at"    : @"createdAt",
//                                                       @"closed_at"     : @"closedAt",
//                                                       @"status_text"   : @"statusText"
//                                                       }];
//}

@end
