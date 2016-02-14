//
//  DateManager.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 31.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DateManager.h"

@implementation DateManager{

    NSDateFormatter * _formatter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _formatter = [[NSDateFormatter alloc] init];

    }
    return self;
}

- (NSString *)getDateOfUserReguest: (NSDate *)neededDate
{
    NSString *callDate;
    
    NSInteger dif = [self daysBetweenDate:neededDate andDate:[NSDate date]];
    
    if (dif == 0) {
        
        [_formatter setDateFormat:@"HH:mm"];
        callDate = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Today", nil), [_formatter stringFromDate:neededDate]];
        return callDate;
    }
    if (dif == 1)
    {
        callDate = NSLocalizedString(@"Yesterday", nil);
        return callDate;
    }
    
    if ((dif > 1) && (dif <= 5))
    {
        [_formatter setDateFormat:@"EEEE"];
        callDate = [_formatter stringFromDate:neededDate];
        callDate = [callDate capitalizedString];
        return callDate;
    }
    
    if (dif > 5)
    {
        [_formatter setDateFormat:@"dd.MM.yy"];
        callDate = [_formatter stringFromDate:neededDate];
        return callDate;
    }
    
    return callDate;
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}


@end
