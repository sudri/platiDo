//
//  DashboardBill.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 28.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DashboardBill.h"

@implementation DashboardBill
+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       
                                                       @"id": @"uid"
                                                       
                                                       }];
}
@end
