//
//  DashboardItem.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 31.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    DashboardItembill = 0,
    DashboardItemDiscussions,
    DashboardItemVotings,
    DashboardItemRequests,
    DashboardItemMetersReport,
}DashboardItemType;

@interface DashboardItem : NSObject

@property (nonatomic, strong) id data;
@property (nonatomic, assign) DashboardItemType type;
@property (nonatomic, assign) BOOL isHaveAccess;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL isNeedCreateRecord;

@end
