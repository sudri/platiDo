//
//  BillingRequestApi.m
//  PlatiDo
//
//  Created by Smart Labs on 09.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "BillingRequestApi.h"
#import "APIRequestManager.h"
#import "CurrentUser.h"

@implementation BillingRequestApi

+ (void)currentBillWithComBlock:(void (^)(id responseObject, NSError *error))comBlock
{
    NSString *request = [NSString stringWithFormat:@"api/v1/user/me/bill"];
    //?token=%@", [CurrentUserInstance token]
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:@{@"token":[CurrentUserInstance token]}
                                                   requestType:requestTypeGet success:^(id responseObject) {
                                                       
                                                       comBlock(responseObject,nil);
                                                       
                                                   } failure:^(NSError *error) {
                                                       
                                                       comBlock(nil,error);
                                                   }];
}

+ (void)historyBillWithComBlock:(void (^)(id responseObject, NSError *error))comBlock
{
    comBlock(nil, nil);
}

@end
