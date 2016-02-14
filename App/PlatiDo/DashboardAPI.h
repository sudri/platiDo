//
//  DashboardAPI.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 28.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DashboardData;
@interface DashboardAPI : NSObject
+ (void)dashboardInfocomBlock:(void (^)(DashboardData *dashboardData, NSError *error))comBlock;
@end
