//
//  DashboardAccessRights.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 11.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DashboardAccessRights.h"

@implementation DashboardAccessRights
+ (JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"bills": @"bills",
                                                       @"requests": @"requests",
                                                       @"discussions": @"discussions",
                                                       @"votings": @"votings",
                                                       @"messages.requests": @"dashboardRequests",
                                                       @"meters_report": @"metersReport",
                                                       }];
}
@end
