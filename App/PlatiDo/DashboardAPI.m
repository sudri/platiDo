//
//  DashboardAPI.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 28.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DashboardAPI.h"
#import "APIRequestManager.h"
#import "CurrentUser.h"
#import "DashboardData.h"

@implementation DashboardAPI


+ (void)dashboardInfocomBlock:(void (^)(DashboardData *dashboardData, NSError *error))comBlock{

    NSString *request = [NSString stringWithFormat:@"api/v1/user/me/dashboard?token=%@", [CurrentUserInstance token]];
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:nil
                                                   requestType:requestTypeGet success:^(id responseObject) {
                                                
                                                       NSError* err = nil;
                                                       DashboardData* dashboardData = [[DashboardData alloc] initWithDictionary:responseObject error:&err];
                                                       NSLog(@"err %@", err);
                                                       comBlock (dashboardData, nil);
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                       
                                                   }];
}

@end
