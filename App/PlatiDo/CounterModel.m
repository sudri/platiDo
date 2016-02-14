//
//  CounterModel.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 14.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "CounterModel.h"

@implementation CounterModel


- (NSString *)getIconForType{
    
    NSDictionary *types = @{[@(CounterReportTypeColdWater) stringValue]     : @"cold_water_counter",
                            [@(CounterReportTypeHotWater) stringValue]      : @"hot_water_counter",
                            [@(CounterReportTypeElectricity) stringValue]   : @"electricity_counter",
                            [@(CounterReportTypeGas) stringValue]           : @"gas_counter",
                            [@(CounterReportTypeWarming) stringValue]       : @"warming_counter",
                            [@(CounterReportTypeOther) stringValue]         : @"default_counter"
                            
                            };
    
    NSString *text = [types valueForKey:[@(self.type)stringValue]];
    return text;
}

- (NSString *)counterValueWithZeroForRightMetric:(NSString *)valueFromServer{
    
    NSMutableString *result = [NSMutableString stringWithString:valueFromServer];
    for (int i = 0; i <  5 - [valueFromServer length]; i++) {
        [result insertString:@"0" atIndex:0];
    }
    
    return result;
}


@end
