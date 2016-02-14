//
//  DashboardItem.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 31.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DashboardItem.h"

@implementation DashboardItem
- (BOOL)isNeedCreateRecord{
    if ((self.type == DashboardItemDiscussions||
        self.type == DashboardItemVotings ||
        self.type == DashboardItemRequests) && (self.count==0)){
        return YES;
    }
    return NO;
}

@end
