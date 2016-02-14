//
//  DashboardData.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 28.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//


#import "DashboardData.h"

#import "DashboardCounter.h"
#import "DashboardBill.h"
#import "DashboardRequests.h"
#import "DashboardMetersReport.h"


@implementation DashboardData

+ (JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"counters": @"counters",
                                                       @"messages.bill": @"bills",
                                                       @"messages.meters_report": @"metersReport",
                                                       @"messages.discussions": @"dashboardDiscussions",
                                                       @"messages.votings": @"dashboardVotings",
                                                       @"messages.requests": @"dashboardRequests",
                                                       @"access_rights":@"accessRights"
                                                     }];
}

@end
