//
//  CounterReportModel.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 09.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CounterModel.h"

@interface CounterReportModel : CounterModel

@property (strong, nonatomic) NSNumber  *counterID;
@property (strong, nonatomic) NSString  *title;
@property (strong, nonatomic) NSString  *subtitle;
@property (strong, nonatomic) NSNumber  *userValue;



- (CounterReportModel *)initWithDict:(NSDictionary *)dict;

@end
