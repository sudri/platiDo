//
//  APIVideo.m
//  CamOnRoad
//
//  Created by Valera Voroshilov on 06.08.15.
//  Copyright (c) 2015 Dmitry Doroschuk. All rights reserved.
//

#import "RegistarationAPI.h"
#import "APIRequestManager.h"
#import "CurrentUser.h"

@implementation RegistarationAPI
+ (void)getCitiezComBlock:(void (^)(NSArray *objects, NSError *error))comBlock{
    NSDictionary *params = @{};
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:@"api/v1/address/cities"
                                                        params:params
                                                   requestType:requestTypeGet success:^(id responseObject) {
                                                       if ([responseObject isKindOfClass:[NSArray class]]){
                                                           comBlock(responseObject,nil);
                                                       }
                                                   } failure:^(NSError *error) {
                                                       comBlock(nil,error);
                                                   }];
}


+ (void)getStreetsAutoComplete:(NSString*)street ComBlock:(void (^)(NSArray *objects, NSError *error))comBlock{
    NSDictionary *params = @{@"token":@"55d5b1960a69dece588b456b",
                             @"contentType":@"street",
                             @"cityId":@"7800000000000",
                             @"query" :street};
    [[APIRequestManager sharedInstance] downloadJSONDataServer:@"http://kladr-api.ru/api.php"
                                                        Method:@""
                                                        params:params requestType:requestTypeGet success:^(id responseObject) {
                                                            
                                                            comBlock([responseObject valueForKey:@"result"], nil);
                                                        } failure:^(NSError *error) {
                                                            comBlock(nil,error);
                                                        }];
}

+ (void)getCompanyByAdress:(NSDictionary*)adressAtrib ComBlock:(void (^)(NSDictionary *company, NSError *error))comBlock{
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:@"api/v1/address/find_company"
                                                        params:adressAtrib
                                                   requestType:requestTypeGet success:^(id responseObject) {
                                                       if ([responseObject isKindOfClass:[NSDictionary class]]){
                                                           comBlock(responseObject,nil);
                                                       }
                                                   } failure:^(NSError *error) {
                                                       comBlock(nil,error);
                                                   }];
}




+ (NSString*)encodeGetRequestMethod:(NSString*)method withParameters:(NSDictionary*)params{
    NSMutableString *result = [[NSMutableString alloc] initWithString:method];
    [result appendString:@"?"];
    for (NSString *key in params.allKeys){
        [result appendFormat:@"%@=%@&", key, [params valueForKey:key]];
    }
    return result;
}

+ (void)registerUserByData:(NSDictionary*)atrib comBlock:(void (^)(NSDictionary *user, NSError *error))comBlock{
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:@"api/v1/user/register"
                                                        params:atrib
                                                   requestType:requestTypePost success:^(id responseObject) {
                                                       
                                                       if ([responseObject isKindOfClass:[NSDictionary class]]){
                                                           comBlock(responseObject,nil);
                                                       }
                                                       
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                       
                                                   }];
}


+ (void)verifyUser:(NSDictionary*)atrib ComBlock:(void (^)(NSDictionary *user, NSError *error))comBlock{
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:@"api/v1/user/verify?_method=PUT"
                                                        params:atrib
                                                   requestType:requestTypePost success:^(id responseObject) {
                                                       
                                                       if ([responseObject isKindOfClass:[NSDictionary class]]){
                                                           comBlock(responseObject,nil);
                                                       }
                                                       
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                       
                                                   }];
}

+ (void)userMePost:(NSDictionary*)atrib token:(NSString*)token comBlock:(void (^)(NSDictionary *user, NSError *error))comBlock{
    
    NSString *request = [NSString stringWithFormat:@"api/v1/user/me?_method=PUT&token=%@", token];
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:atrib
                                                   requestType:requestTypePost success:^(id responseObject) {
                                                       
                                                       if ([responseObject isKindOfClass:[NSDictionary class]]){
                                                           comBlock(responseObject,nil);
                                                       }
                                                       
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                       
                                                   }];
}

+ (void)userMeGetComBlock:(void (^)(NSDictionary *user, NSError *error))comBlock{
    NSString *request = [NSString stringWithFormat:@"api/v1/user/me?token=%@", [CurrentUserInstance token]];
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:nil
                                                   requestType:requestTypeGet success:^(id responseObject) {
                                            
                                                       if ([responseObject isKindOfClass:[NSDictionary class]]){
                                                           comBlock(responseObject,nil);
                                                       }
                                                       
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                       
                                                   }];
}


#pragma mark - Validation Address

+ (void)userAddressValidation:(NSDictionary*)dict comBlock:(void (^)(id responseObject, NSError *error))comBlock{
    
    NSString *request = [NSString stringWithFormat:@"api/v1/user/me/apartment?token=%@", [CurrentUserInstance token]];
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:dict
                                                   requestType:requestTypePost success:^(id responseObject) {

                                                           comBlock(responseObject,nil);
                                                       
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                   }];
}

#pragma mark - Validation Appartment

+ (void)userAppartmentValidation:(NSDictionary*)dict comBlock:(void (^)(id responseObject, NSError *error))comBlock{
    
    NSString *request = [NSString stringWithFormat:@"api/v1/user/me/apartment?_method=PUT&token=%@", [CurrentUserInstance token]];
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:dict
                                                   requestType:requestTypePost success:^(id responseObject) {
                                                       
                                                       comBlock(responseObject,nil);
                                                       
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                   }];
}


@end
