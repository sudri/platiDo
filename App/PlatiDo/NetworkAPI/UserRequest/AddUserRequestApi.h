//
//  AddUserRequestApi.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 31.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddUserRequestApi : NSObject

+ (void)addUserRequest:(NSDictionary*)dict comBlock:(void (^)(id responseObject, NSError *error))comBlock;
+ (void)addUserCommentToRequest:(NSDictionary*)dict comBlock:(void (^)(id responseObject, NSError *error))comBlock;
+ (void)closeUserRequest:(NSDictionary*)dict comBlock:(void (^)(id responseObject, NSError *error))comBlock;

@end
