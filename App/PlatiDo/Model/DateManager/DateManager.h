//
//  DateManager.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 31.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateManager : NSObject

- (NSString *)getDateOfUserReguest: (NSDate *)neededDate;
- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

@end
