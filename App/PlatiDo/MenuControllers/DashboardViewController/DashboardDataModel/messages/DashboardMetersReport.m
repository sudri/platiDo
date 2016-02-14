//
//  DashboardMetersReport.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 28.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DashboardMetersReport.h"

@implementation DashboardMetersReport
+ (JSONKeyMapper*)keyMapper
{
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       
                                                       @"days_left": @"daysLeft",
                                                       @"is_reported":@"isReported"
                                                       
                                                       }];
}
@end
