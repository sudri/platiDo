//
//  AuthorizationAPI.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 25.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorizationAPI : NSObject
+ (void)authUser:(NSDictionary*)atrib comBlock:(void (^)(NSDictionary *user, NSError *error))comBlock;
+ (void)getRecoverPassCode:(NSString*)phone comBlock:(void (^)(NSDictionary *user, NSError *error))comBlock;
+ (void)verifySMSCodeToRecover:(NSDictionary*)params comBlock:(void (^)(NSString *userId, NSError *error))comBlock;
+ (void)recoverPass:(NSDictionary*)params comBlock:(void (^)(NSDictionary *user, NSError *error))comBlock;
@end
