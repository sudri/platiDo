//
//  ArchiveReportModel.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 11.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArchiveReportModel : NSObject


@property (strong, nonatomic) NSDate * date;
@property (strong, nonatomic) NSDate * createdAtUserDate;

@property (strong, nonatomic) NSMutableArray * counters;

- (ArchiveReportModel *)initWithDict:(NSDictionary *)dict;

@end
