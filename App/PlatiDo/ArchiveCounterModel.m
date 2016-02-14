//
//  ArchiveCounterModel.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 11.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "ArchiveCounterModel.h"

@implementation ArchiveCounterModel

- (ArchiveCounterModel *)initWithDict:(NSDictionary *)dict{
    
    ArchiveCounterModel *newCounter = [ArchiveCounterModel new];
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

    newCounter.title        = [dict valueForKey:@"title"];
    newCounter.subtitle     = [dict valueForKey:@"subtitle"];
    newCounter.value        = [self counterValueWithZeroForRightMetric:[dict valueForKey:@"value"]];
    
    return newCounter;
}


@end
