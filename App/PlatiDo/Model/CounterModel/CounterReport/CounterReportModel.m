//
//  CounterReportModel.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 09.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "CounterReportModel.h"

@implementation CounterReportModel

- (CounterReportModel *)initWithDict:(NSDictionary *)dict{

    CounterReportModel *newCounter = [CounterReportModel new];
    
    newCounter.type  =  CounterReportTypeOther;

    if ([[dict valueForKey:@"type"] isEqualToString:@"cold_water"]) {
        newCounter.type  =  CounterReportTypeColdWater;
    }
    if ([[dict valueForKey:@"type"] isEqualToString:@"hot_water"]) {
        newCounter.type  =  CounterReportTypeHotWater;
    }
    if ([[dict valueForKey:@"type"] isEqualToString:@"electricity"]) {
        newCounter.type  =  CounterReportTypeElectricity;
    }
    if ([[dict valueForKey:@"type"] isEqualToString:@"gas"]) {
        newCounter.type  =  CounterReportTypeGas;
    }
    if ([[dict valueForKey:@"type"] isEqualToString:@"warming"]) {
        newCounter.type  =  CounterReportTypeWarming;
    }
    if ([dict valueForKey:@"metrics"] ) {
        newCounter.metrics  =  [dict valueForKey:@"metrics"];
    }

    newCounter.counterID    = [dict valueForKey:@"id"];
    newCounter.title        = [dict valueForKey:@"title"];
    newCounter.subtitle     = [dict valueForKey:@"subtitle"];

    newCounter.userValue    = nil;
    return newCounter;
}

@end
