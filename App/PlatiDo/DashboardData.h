//
//  DashboardData.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 28.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
#import "DashboardAccessRights.h"
#import "DashboardRequests.h"

@class DashboardCounter;
@class DashboardRequests;
@class DashboardDiscussions;
@class DashboardVotings;
@class DashboardAccessRights;

@interface DashboardData : JSONModel

@property (nonatomic, strong)  DashboardCounter            *counters;
@property (nonatomic, strong)  DashboardAccessRights       *accessRights;

@property (nonatomic, assign)  NSNumber<Optional> *bills;
@property (nonatomic, assign)  NSNumber<Optional> *metersReport;
@property (nonatomic, strong)  NSArray <Optional> *dashboardDiscussions;
@property (nonatomic, strong)  NSArray <Optional> *dashboardVotings;
@property (nonatomic, strong)  NSArray <Optional> *dashboardRequests;


@end
