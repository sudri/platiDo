//
//  DashboardRequests.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 28.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface DashboardRequests : JSONModel

@property (nonatomic, assign)  NSInteger uid;
@property (nonatomic, strong)  NSString *title;
@property (nonatomic, strong)  NSString *message;

@end
