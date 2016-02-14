//
//  ArchiveReportModel.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 11.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "ArchiveReportModel.h"
#import "ArchiveCounterModel.h"
#import "PhoneFormatter.h"

@implementation ArchiveReportModel

- (ArchiveReportModel *)initWithDict:(NSDictionary *)dict{
   
    ArchiveReportModel *newModel = [[ArchiveReportModel alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"MM.yyyy"];    
    newModel.date = [dateFormatter dateFromString:[dict valueForKey:@"month"]];
    
    NSArray *arrayOfCounters = [dict valueForKey:@"stats"];
    newModel.counters = [NSMutableArray new];
    for (int i = 0; i < arrayOfCounters.count; i++) {
        ArchiveCounterModel *newCounter = [[ArchiveCounterModel alloc] initWithDict:arrayOfCounters[i]];
        [newModel.counters addObject:newCounter];
    }
    
    
    if([dict valueForKey:@"created_at"]){
        newModel.createdAtUserDate = [PhoneFormatter dateFromServerString:[dict valueForKey:@"created_at"]];
    }else{
        newModel.createdAtUserDate = nil;
    }
    
    return newModel;
}

@end
