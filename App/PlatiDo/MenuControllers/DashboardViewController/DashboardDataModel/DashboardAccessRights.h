//
//  DashboardAccessRights.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 11.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface DashboardAccessRights : JSONModel

@property (nonatomic, assign) BOOL bills;
@property (nonatomic, assign) BOOL requests;
@property (nonatomic, assign) BOOL discussions;
@property (nonatomic, assign) BOOL votings;
@property (nonatomic, assign) BOOL metersReport;

@end
