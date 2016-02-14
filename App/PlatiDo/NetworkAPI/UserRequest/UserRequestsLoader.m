//
//  ApplicationsAPI.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 28.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "UserRequestsLoader.h"
#import "APIRequestManager.h"
#import "CurrentUser.h"
#import "UserRequestModel.h"
#import "UserRequestTypeModel.h"

@implementation UserRequestsLoader

- (instancetype)init{
    self = [super init];
    if (self) {
        self.myRequests         = [NSMutableArray new];
        self.actualUserRequests = [NSMutableArray new];
    }
    return self;
}

- (void)getApplicationsComBlock:(void (^)(NSError *error))comBlock{
    
    NSString *request = [NSString stringWithFormat:@"api/v1/user/me/request?token=%@", [CurrentUserInstance token]];
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:nil
                                                   requestType:requestTypeGet success:^(id responseObject) {
                                                       if ([responseObject isKindOfClass:[NSDictionary class]]){
                                                           [self applicationsLoaded:responseObject];
                                                           comBlock(nil);
                                                       }
                                                   } failure:^(NSError *error) {
#warning TODO: User Request errors processing
                                                       comBlock(error);
                                                   }];
}

- (void)applicationsLoaded:(NSDictionary *)dict{

   // NSError* err = nil;
    self.myRequests         = [NSMutableArray new];
    self.actualUserRequests = [NSMutableArray new];

    NSArray *my     = [dict valueForKey:@"my"];
    NSArray *actual = [dict valueForKey:@"actual"];
    
    for (int i = 0; i < [my count]; i++){
    
        NSDictionary *curDict = my[i];
        //UserRequestModel *currentApplication = [[UserRequestModel alloc] initWithDictionary:curDict error:&err] ;
        UserRequestModel *currentApplication = [[UserRequestModel alloc] initWithDict:curDict];

        [self.myRequests addObject:currentApplication];
    }
    
    for (int i = 0; i < [actual count]; i++){
        
        NSDictionary *curDict = actual[i];
        //UserRequestModel *currentApplication = [[UserRequestModel alloc] initWithDictionary:curDict error:&err] ;
        UserRequestModel *currentApplication = [[UserRequestModel alloc] initWithDict:curDict];
        [self.actualUserRequests addObject:currentApplication];
    }
}

#pragma mark - Get List of UserRequestTypes

+ (void)getUserRequestTypesComBlock:(void (^)(NSArray *userRequestTypes, NSError *error))comBlock{
    
    NSString *request = [NSString stringWithFormat:@"api/v1/request/types?token=%@", [CurrentUserInstance token]];

    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:nil
                                                   requestType:requestTypeGet success:^(id responseObject) {
                                                       if ([responseObject isKindOfClass:[NSArray class]]){
                                                           NSArray *arr = responseObject;
                                                           NSMutableArray *requestTypes = [NSMutableArray new];
                                                           NSError *err;
                                                           
                                                           for (int i = 0; i < [arr count]; i++) {
                                                               UserRequestTypeModel *newModel = [[UserRequestTypeModel alloc] initWithDictionary:arr[i] error:&err];
                                                               [requestTypes addObject:newModel];
                                                           }
                                                           comBlock(requestTypes,nil);
                                                       }
                                                   } failure:^(NSError *error) {
                                                       comBlock(nil,error);
#warning TODO: User Request errors processing
                                                   }];
}

@end
