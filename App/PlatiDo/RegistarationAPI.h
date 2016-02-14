//
//  APIVideo.h
//  CamOnRoad
//
//  Created by Valera Voroshilov on 06.08.15.
//  Copyright (c) 2015 Dmitry Doroschuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistarationAPI : NSObject
+ (void)getCitiezComBlock:(void (^)(NSArray *objects, NSError *error))comBlock;
+ (void)getStreetsAutoComplete:(NSString*)street ComBlock:(void (^)(NSArray *objects, NSError *error))comBlock;
+ (void)getCompanyByAdress:(NSDictionary*)adressAtrib ComBlock:(void (^)(NSDictionary *company, NSError *error))comBlock;
+ (void)registerUserByData:(NSDictionary*)atrib comBlock:(void (^)(NSDictionary *user, NSError *error))comBlock;
+ (void)verifyUser:(NSDictionary*)atrib ComBlock:(void (^)(NSDictionary *user, NSError *error))comBlock;
+ (void)userMePost:(NSDictionary*)atrib token:(NSString*)token comBlock:(void (^)(NSDictionary *user, NSError *error))comBlock;
+ (void)userMeGetComBlock:(void (^)(NSDictionary *user, NSError *error))comBlock;


+ (void)userAddressValidation:(NSDictionary*)dict comBlock:(void (^)(id responseObject, NSError *error))comBlock;
+ (void)userAppartmentValidation:(NSDictionary*)dict comBlock:(void (^)(id responseObject, NSError *error))comBlock;

@end
