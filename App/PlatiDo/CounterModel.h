//
//  CounterModel.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 14.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CounterReportType) {
    CounterReportTypeColdWater          = 0,
    CounterReportTypeHotWater           = 1,
    CounterReportTypeWarming            = 2,
    CounterReportTypeElectricity        = 3,
    CounterReportTypeGas                = 4,
    CounterReportTypeOther              = 5
};

@interface CounterModel : NSObject

@property (assign)  CounterReportType       type;
@property (strong, nonatomic)  NSString     *metrics;

- (NSString *)getIconForType;
- (NSString *)counterValueWithZeroForRightMetric:(NSString *)valueFromServer;

@end
