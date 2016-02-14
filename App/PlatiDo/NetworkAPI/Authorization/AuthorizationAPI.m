//
//  AuthorizationAPI.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 25.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "AuthorizationAPI.h"
#import "APIRequestManager.h"
#import "CurrentUser.h"
#import "NSString+URLEncodedString_ch.h"

@implementation AuthorizationAPI

+ (void)authUser:(NSDictionary*)atrib comBlock:(void (^)(NSDictionary *user, NSError *error))comBlock{
    
    NSString *request = [NSString stringWithFormat:@"api/v1/user/login?token=%@", [CurrentUserInstance token]];
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:atrib
                                                   requestType:requestTypePost
                                                       success:^(id responseObject) {
                                                       if ([responseObject isKindOfClass:[NSDictionary class]]){
                                                           comBlock(responseObject,nil);
                                                       }
                                                   } failure:^(NSError *error) {
                                                       comBlock(nil,error);
                                                   }];
}

+ (void)getRecoverPassCode:(NSString*)phone comBlock:(void (^)(NSDictionary *user, NSError *error))comBlock{
    
    NSString *request = [NSString stringWithFormat:@"api/v1/user/password/restoration_code?phone=%@", [phone URLEncodedString_ch]];
  
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:nil
                                                   requestType:requestTypeGet
                                                       success:^(id responseObject) {
                            
                                                               comBlock(responseObject,nil);
                                                           
                                                       } failure:^(NSError *error) {
                                                           comBlock(nil,error);
                                                }];
}

+ (void)verifySMSCodeToRecover:(NSDictionary*)params comBlock:(void (^)(NSString *userId, NSError *error))comBlock{
    
    NSString *request = [NSString stringWithFormat:@"api/v1/user/password/restoration_code"];
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:params
                                                   requestType:requestTypePost
                                                       success:^(id responseObject) {
                                                          if ([responseObject isKindOfClass:[NSDictionary class]]){
                                                              comBlock([[responseObject valueForKey:@"id"] stringValue],nil);
                                                          }
                                                       } failure:^(NSError *error) {
                                                           comBlock(nil,error);
                                                       }];
}

+ (void)recoverPass:(NSDictionary*)params comBlock:(void (^)(NSDictionary *user, NSError *error))comBlock{
    NSString *request = [NSString stringWithFormat:@"api/v1/user/password/restoration_code"];
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:params
                                                   requestType:requestTypePost
                                                       success:^(id responseObject) {
                                                           comBlock(responseObject,nil);
                                                       } failure:^(NSError *error) {
                                                           comBlock(nil,error);
                                                       }];
}

@end
