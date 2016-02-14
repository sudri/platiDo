//
//  DashboardRequests.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 28.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DashboardRequests.h"

@implementation DashboardRequests
+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                        @"id": @"uid",
                                                        @"description":@"message",
                                                        @"subject":@"title"
                                                      }];
}
@end
