//
//  AddUserRequestApi.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 31.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "AddUserRequestApi.h"
#import "APIRequestManager.h"
#import "CurrentUser.h"

@implementation AddUserRequestApi

+ (void)addUserRequest:(NSDictionary*)dict comBlock:(void (^)(id responseObject, NSError *error))comBlock{
    
    NSString *request = [NSString stringWithFormat:@"api/v1/user/me/request?token=%@", [CurrentUserInstance token]];
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:dict
                                                   requestType:requestTypePost success:^(id responseObject) {
                                                       
                                                       comBlock(responseObject,nil);
                                                       
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                   }];
}

+ (void)addUserCommentToRequest:(NSDictionary*)dict comBlock:(void (^)(id responseObject, NSError *error))comBlock{
    
    NSString *request = [NSString stringWithFormat:@"api/v1/user/me/request/comment/add?token=%@", [CurrentUserInstance token]];
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:dict
                                                   requestType:requestTypePost success:^(id responseObject) {
                                                       
                                                       comBlock(responseObject,nil);
                                                       
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                   }];
}

+ (void)closeUserRequest:(NSDictionary*)dict comBlock:(void (^)(id responseObject, NSError *error))comBlock{
    
    NSString *request = [NSString stringWithFormat:@"api/v1/user/me/request?_method=DELETE&token=%@", [CurrentUserInstance token]];
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:dict
                                                   requestType:requestTypePost success:^(id responseObject) {
                                                       
                                                       comBlock(responseObject,nil);
                                                       
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                   }];
}



@end
