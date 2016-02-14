//
//  APIRequestManager.h
//  CamOnRoad
//
//  Created by Valera Voroshilov on 06.08.15.
//  Copyright (c) 2015 Dmitry Doroschuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DomainURL   @"http://api.platido.ru/"

@interface APIRequestManager : NSObject

typedef enum {
    requestTypeGet,
    requestTypePost,
    requestTypePut,
    requestTypeDelete
} requestType;

+ (instancetype)sharedInstance;

@property (nonatomic, strong)  NSString *token;

- (void)downloadJSONDataServer:(NSString*)server
                        Method:(NSString *)method
                        params:(NSDictionary *)params
                   requestType:(requestType)requestType
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

- (void)downloadJSONDataMethod:(NSString *)method
                        params:(NSDictionary *)params
                   requestType:(requestType)requestType
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

- (void)sendImagePostRequestToMethod:(NSString*)requestMethod
                parmeters:(NSDictionary*)parameters
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;


@end
