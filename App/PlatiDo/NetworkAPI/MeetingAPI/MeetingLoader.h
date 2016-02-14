//
//  MeetingApi.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 28.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentEntity.h"
typedef NS_ENUM(NSInteger, LoadMeetingsType) {
    LoadMeetingsTypeArchive = 0,
    LoadMeetingsTypeActive  = 1
};

@class Meeting;

@interface MeetingLoader : NSObject

@property (strong, nonatomic, readonly) NSArray *activeMeetings;
@property (strong, nonatomic, readonly) NSArray *archiveMeetings;

- (void)loadMeetingsWithType:(LoadMeetingsType)meetingsType withComblock:(void (^)(NSError *error))comblock;
+ (void)registrateUserToMeetiong:(Meeting*)meeting comBlock:(void (^)(NSError *error))comBlock;
+ (void)getCommentList:(NSDictionary*)dictionary comBlock:(void (^)(NSArray *items, NSError *error))comBlock;
+ (void)createComment:(NSDictionary*)dictionary comBlock:(void (^)(CommentEntity *commentEntity, NSError *error))comBlock;
@end
