//
//  CountersReportsLoader.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 10.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountersReportsLoader : NSObject


@property (strong, nonatomic) NSMutableArray *countersInputs;
@property (strong, nonatomic) NSMutableArray *countersReports;

@property (assign, readonly) BOOL isAllArchiveCountersReportsLoaded;

- (void)getArchiveCountersReportComBlock:(void (^)(NSError *error))comBlock;
- (void)getCountersForInputComBlock:(void (^)(NSError *error))comBlock;
+ (void)sendUserReports:(NSDictionary*)dict comBlock:(void (^)(id responseObject, NSError *error))comBlock;
+ (void)resetUserCountersInputComBlock:(void (^)(NSError *error))comBlock;
+ (void)sendCounterLabel:(NSDictionary*)dict comBlock:(void (^)(id responseObject, NSError *error))comBlock;

@end
