//
//  ApplicationsAPI.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 28.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRequestsLoader : NSObject

@property (strong, nonatomic) NSMutableArray *myRequests;
@property (strong, nonatomic) NSMutableArray *actualUserRequests;

- (void)getApplicationsComBlock:(void (^)(NSError *error))comBlock;

+ (void)getUserRequestTypesComBlock:(void (^)(NSArray *userRequestTypes, NSError *error))comBlock;

@end
