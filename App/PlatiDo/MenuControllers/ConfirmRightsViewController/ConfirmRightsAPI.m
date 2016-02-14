//
//  ConfirmRightsAPI.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 14.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "ConfirmRightsAPI.h"
#import "CurrentUser.h"
#import "APIRequestManager.h"

@implementation ConfirmRightsAPI


+ (void)sendFlatInfo:(NSDictionary*)params comblock:(void (^)(NSDictionary *responce, NSError *error))comBlock{
    NSString *request = [NSString stringWithFormat:@"api/v1/user/me/apartment/ownership?_method=PUT&token=%@", [CurrentUserInstance token]];
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:params
                                                   requestType:requestTypePost success:^(id responseObject) {
                                                       
                                                       comBlock(responseObject, nil);
                                                       
                                                   } failure:^(NSError *error) {

                                                       comBlock(nil,error);
                                                    
                                                   }];
}
@end
