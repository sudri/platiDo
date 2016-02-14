//
//  SettingsApi.m
//  PlatiDo
//
//  Created by Smart Labs on 13.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "SettingsApi.h"
#import "CurrentUser.h"
#import "APIRequestManager.h"

@implementation SettingsApi

+ (void)editRequest:(NSDictionary*)dict comBlock:(void (^)(id responseObject, NSError *error))comBlock{
    
    NSString *request = [NSString stringWithFormat:@"api/v1/user/me?token=%@", [CurrentUserInstance token]];
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:dict
                                                   requestType:requestTypePut success:^(id responseObject) {
                                                       
                                                       comBlock(responseObject,nil);
                                                       
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                   }];
}

+ (void)editAdressRequest:(NSDictionary*)dict comBlock:(void (^)(id responseObject, NSError *error))comBlock{
    
    NSString *request = [NSString stringWithFormat:@"api/v1/user/me/apartment?token=%@", [CurrentUserInstance token]];
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:dict
                                                   requestType:requestTypePost success:^(id responseObject) {
                                                       
                                                       comBlock(responseObject,nil);
                                                       
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                   }];
}

@end
