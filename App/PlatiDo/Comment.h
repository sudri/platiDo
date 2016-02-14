//
//  Comment.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 28.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CommentCreatorType) {
    CommentCreatorTypeUser          = 0,
    CommentCreatorTypeDispetcher    = 1
};

@interface Comment : NSObject

@property (strong, nonatomic) NSString  *text;

@property (strong, nonatomic) NSDate    *createdAt;
@property (strong, nonatomic) NSString  *createdBy;
@property (assign) CommentCreatorType   creatorType;

- (Comment *)initWithDict: (NSDictionary *)dict;

@end
