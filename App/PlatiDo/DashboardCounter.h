//
//  DashboardCounter.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 28.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface DashboardCounter : JSONModel

@property (nonatomic, assign)  NSInteger bills;
@property (nonatomic, assign)  NSInteger requests;
@property (nonatomic, assign)  NSInteger discussions;
@property (nonatomic, assign)  NSInteger votings;

@end
