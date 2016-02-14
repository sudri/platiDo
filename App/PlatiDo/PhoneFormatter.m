//
//  PhoneFormatter.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 26.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "PhoneFormatter.h"

@implementation PhoneFormatter
+ (NSString*)formatPhoneNumber:(NSString*) simpleNumber deleteLastChar:(BOOL)deleteLastChar {
    if(simpleNumber.length==0) return @"";
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];
    
    if(deleteLastChar) {
        simpleNumber = [simpleNumber substringToIndex:[simpleNumber length] - 1];
    }
    
    if(simpleNumber.length>=10){
        simpleNumber = [simpleNumber substringToIndex:10];
        return simpleNumber;
    }
    
    return simpleNumber;
}


+ (NSString*)formatSMSNumber:(NSString*)simpleNumber deleteLastChar:(BOOL)deleteLastChar{
    if(simpleNumber.length==0) return @"";
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];
    
    if(deleteLastChar) {
        simpleNumber = [simpleNumber substringToIndex:[simpleNumber length] - 1];
    }
    
    if(simpleNumber.length>=4){
        simpleNumber = [simpleNumber substringToIndex:4];
        return simpleNumber;
    }
    
    return simpleNumber;
}

+ (NSString*)formatBuildNumber:(NSString*)simpleNumber deleteLastChar:(BOOL)deleteLastChar{
    if(simpleNumber.length==0) return @"";
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];
    
    if(deleteLastChar) {
        simpleNumber = [simpleNumber substringToIndex:[simpleNumber length] - 1];
    }
    
    if(simpleNumber.length>=4){
        simpleNumber = [simpleNumber substringToIndex:4];
        return simpleNumber;
    }
    
    return simpleNumber;
}

+ (NSString*)formatPartNumber:(NSString*)simpleNumber deleteLastChar:(BOOL)deleteLastChar{
    if(simpleNumber.length==0) return @"";
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];
    
    if(deleteLastChar) {
        simpleNumber = [simpleNumber substringToIndex:[simpleNumber length] - 1];
    }
    
    if(simpleNumber.length>=4){
        simpleNumber = [simpleNumber substringToIndex:4];
        return simpleNumber;
    }
    
    return simpleNumber;
}


+ (NSString*)formatShortDate:(NSDate*)sourceDate{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy"];
    
    NSDate *now = [[NSDate alloc] init];
    NSString *theDate = [dateFormat stringFromDate:now];
    return theDate;
}


+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
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


+ (NSString*)formatStringDate:(NSDate*)neededDate{
    NSString *callDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSInteger dif = [self daysBetweenDate:neededDate andDate:[NSDate date]];
    
    if (dif == 0) {
        
        [formatter setDateFormat:@"HH:mm"];
        callDate = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Today", nil), [formatter stringFromDate:neededDate]];
        return callDate;
    }
    if (dif == 1)
    {
        callDate = NSLocalizedString(@"Yesterday", nil);
        return callDate;
    }
    
    if ((dif > 1) && (dif <= 5))
    {
        [formatter setDateFormat:@"EEEE"];
        callDate = [formatter stringFromDate:neededDate];
        callDate = [callDate capitalizedString];
        return callDate;
    }
    
    if (dif > 5)
    {
        [formatter setDateFormat:@"dd.MM.yy"];
        callDate = [formatter stringFromDate:neededDate];
        return callDate;
    }
    
    return callDate;
}


+ (NSDate*)dateFromServerString:(NSString*)sourceString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"];
    NSDate *dateResult = [dateFormatter dateFromString:sourceString];
    return dateResult;
}
@end
