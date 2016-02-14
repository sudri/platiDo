//
//  DashboardDiscussions.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 31.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DashboardDiscussions.h"

@implementation DashboardDiscussions
+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       
                                                       @"id": @"uid"
                                                       
                                                       }];
}

@end
