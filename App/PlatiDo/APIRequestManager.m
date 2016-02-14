//
//  APIRequestManager.m
//  CamOnRoad
//
//  Created by Valera Voroshilov on 06.08.15.
//  Copyright (c) 2015 Dmitry Doroschuk. All rights reserved.
//

#import "APIRequestManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "UserAgent.h"
#import "ErrorProcessing.h"
#import "UIImage+ImageEffects.h"

//#import "NSString+URLEncodedString_ch.h"
//#import "NSString+Hash.h"

#define SOLT        @"b080dfcba1fd499d2489871d66317ccffe6f4b92"
#define DomainURL   @"http://api.platido.ru/"

static APIRequestManager *sInstance;

@interface APIRequestManager ()
@property (nonatomic, strong) AFHTTPRequestOperationManager *afManager;
@property (nonatomic, strong) NSString *programVer;

@end

@implementation APIRequestManager

+ (instancetype)sharedInstance {
  
    static dispatch_once_t    onceKey;
    dispatch_once(&onceKey, ^{
        sInstance = [[APIRequestManager alloc] init];
        sInstance.afManager = [AFHTTPRequestOperationManager manager];
        [sInstance.afManager.requestSerializer setValue:[[NSLocale preferredLanguages] objectAtIndex:0] forHTTPHeaderField:@"Accept-Language"];
        [sInstance.afManager.requestSerializer setValue:[UserAgent getUserAgent] forHTTPHeaderField:@"User-Agent"];
        
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        
        sInstance.programVer = [NSString stringWithFormat:@"%@-%@", build, version];
        //sInstance.token  = [[NSUserDefaults standardUserDefaults] stringForKey:kToken];
    });
    return sInstance;
}


- (void)sendImagePostRequestToMethod:(NSString*)requestMethod
                           parmeters:(NSDictionary*)parameters
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure{
        NSMutableDictionary *mutableParamenters = [parameters mutableCopy];
    
        NSArray *images = [mutableParamenters valueForKey:@"images"];
        [mutableParamenters removeObjectForKey:@"images"];
    
        NSString *request = requestMethod;
    
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:DomainURL]];
    
        AFHTTPRequestOperation *op = [manager POST:request parameters:mutableParamenters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSInteger counter = 1;
            for (UIImage *image in images) {
                UIImage *imageFixed = [image fixOrientation];
                NSData *imageData   = UIImageJPEGRepresentation(imageFixed, 0.5);
                NSString *keyName   = [NSString stringWithFormat:@"image%ld", (long)counter];
                NSString *fileName  = [NSString stringWithFormat:@"image%ld.jpg", (long)counter];
                [formData appendPartWithFileData:imageData name:keyName fileName:fileName mimeType:@"image/jpeg"];
                counter++;
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success (responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure (error);
        }];
        [op start];
}


- (void)setToken:(NSString *)token{
//   [[NSUserDefaults standardUserDefaults] setObject:token forKey:kToken];
   [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)signWithMethodURL:(NSString*)requestMethod params:(NSDictionary*)parameters{
    
    NSMutableDictionary *params = parameters ? [parameters mutableCopy] : [NSMutableDictionary dictionary];
    
    NSMutableArray *keys = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    
    [keys addObjectsFromArray:[params allKeys]];
    [values addObjectsFromArray:[params allValues]];
    
    [keys sortUsingSelector:@selector(caseInsensitiveCompare:)];
    
    NSMutableString *joinedValues = [NSMutableString stringWithString:@""];
    for (NSString *key in keys) {
        if (![key isEqualToString:@"_method"] && ![key isEqualToString:@"sign"])
        {
            [joinedValues appendString:[NSString stringWithFormat:@"%@", [params valueForKey:key]]];
        }
    }
    NSString *presign = [NSString stringWithFormat:@"%@%@%@", SOLT, requestMethod, joinedValues];
    return @"";//[NSString sha1: presign];
}


- (void)downloadJSONDataServer:(NSString*)server
                        Method:(NSString *)method
                        params:(NSDictionary *)params
                   requestType:(requestType)requestType
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure{
    @try {
        [self clearCookie];
        
        NSString *APIURLMethod = [NSString stringWithFormat:@"%@%@", server, method];
        
        void (^successLocal)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject){
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            success(responseObject);
        };
        
        void (^errorLocal)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error){
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            NSData *responseData = [error.userInfo valueForKey:@"com.alamofire.serialization.response.error.data"];
            NSString *myString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"respose error user info %@", myString);
            
            ErrorProcessing *errorProcessing = [[ErrorProcessing alloc] init];
            [errorProcessing processError:error];
            
            failure(error);
        };
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        switch (requestType) {
            case requestTypeGet:{}
                [self.afManager GET:APIURLMethod parameters:params success:successLocal failure:errorLocal];
                break;
            case requestTypePost:{}
                [self.afManager POST:APIURLMethod parameters:params success:successLocal failure:errorLocal];
                break;
            case requestTypePut:{}
                [self.afManager PUT:APIURLMethod parameters:params success:successLocal failure:errorLocal];
                break;
            case requestTypeDelete:{}
                [self.afManager DELETE:APIURLMethod parameters:params success:successLocal failure:errorLocal];
                break;
        }
    }
    
    @catch (NSException *exception) {
        NSLog(@"Exception in method %@ : %@", method, exception);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}


- (void)downloadJSONDataMethod:(NSString *)method
                        params:(NSDictionary *)params
                   requestType:(requestType)requestType
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure{
    [self downloadJSONDataServer:DomainURL Method:method params:params requestType:requestType success:success failure:failure];
}


- (void)clearCookie{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:DomainURL]];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}
@end
