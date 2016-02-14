//
//  Application.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 28.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Comment.h"
#import "JSONModel.h"

#define NEED_LIST_OF_USER_REQUESTS @"NeedListOfUserRequests"

typedef NS_ENUM(NSInteger, UserRequestStateType) {
    UserRequestNew          = 0,
    UserRequestProcessing   = 1,
    UserRequestComplete     = 2,
    UserRequestUndefined    = 3
};


typedef NS_ENUM(NSInteger, UserRequestStateGroup) {
    UserRequestGroupMy          = 0,
    UserRequestGroupActual      = 1
};


@interface UserRequestModel : NSObject

@property (strong, nonatomic) NSNumber  *reqId;

@property (strong, nonatomic) NSString  *subject;
@property (strong, nonatomic) NSString  *reqDescription;

@property (assign) UserRequestStateType  status;
@property (assign) UserRequestStateGroup group;

@property (strong, nonatomic) NSString  *statusText;

@property (strong, nonatomic) NSString  *type;
@property (strong, nonatomic) NSDate    *createdAt;
@property (strong, nonatomic) NSDate    *closedAt;

@property (assign) BOOL                 is_closed;

@property (strong, nonatomic) NSMutableArray  * comments;



- (UserRequestModel *)initWithDict: (NSDictionary *)dict;

@end
