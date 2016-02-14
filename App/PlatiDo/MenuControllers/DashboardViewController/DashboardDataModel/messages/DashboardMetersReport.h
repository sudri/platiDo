//
//  DashboardMetersReport.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 28.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface DashboardMetersReport : JSONModel

@property (nonatomic, assign)  NSInteger daysLeft;
@property (nonatomic, assign)  BOOL isReported;

@end
