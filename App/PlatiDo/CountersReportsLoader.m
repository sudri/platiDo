//
//  CountersReportsLoader.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 10.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "CountersReportsLoader.h"
#import "APIRequestManager.h"
#import "CurrentUser.h"
#import "CounterReportModel.h"
#import "ArchiveReportModel.h"
#import "ArchiveCounterModel.h"

#define LIMIT_COUNTERS_FOR_LOADING 10

@implementation CountersReportsLoader

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.countersInputs                 = [NSMutableArray new];
        self.countersReports                = [NSMutableArray new];
        _isAllArchiveCountersReportsLoaded  = NO;
    }
    return self;
}

- (void)getArchiveCountersReportComBlock:(void (^)(NSError *error))comBlock{
    NSString        *request = [NSString stringWithFormat:@"api/v1/user/me/meters/stats?token=%@", [CurrentUserInstance token]];
    NSDictionary    * params = @{@"limit"    : [NSString stringWithFormat:@"%lu",(unsigned long)LIMIT_COUNTERS_FOR_LOADING],
                                 @"offset"   : [NSString stringWithFormat:@"%lu",(unsigned long)self.countersReports.count]};
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:params
                                                   requestType:requestTypeGet success:^(id responseObject) {
                                                       if ([responseObject isKindOfClass:[NSArray class]] && !self.isAllArchiveCountersReportsLoaded){
                                                           [self archiveCountersReportLoaded:responseObject];
                                                           comBlock(nil);
                                                       }
                                                   } failure:^(NSError *error) {
#warning TODO: User Request errors processing
                                                       comBlock(error);
                                                   }];
}

- (void)archiveCountersReportLoaded:(NSArray *)array{
   // self.countersReports = [NSMutableArray new];
    if (array.count < LIMIT_COUNTERS_FOR_LOADING) {
        _isAllArchiveCountersReportsLoaded = YES;
    }
    for (int i = 0; i < array.count; i++) {
        NSDictionary *currentCounterReport = array[i];
        ArchiveReportModel *report = [[ArchiveReportModel alloc] initWithDict:currentCounterReport];
        
//        if (i == 3) {
//            NSDictionary *ddd = @{    @"label"  : @"ХХХХХХХХХХХХ",
//                                      @"type"   : @"gas",
//                                      @"value"  : @"9999"};
//            ArchiveCounterModel *newCounter1 = [[ArchiveCounterModel alloc] initWithDict:ddd];
//            [report.counters addObject:newCounter1];
//
//        }
        [self.countersReports addObject:report];
        
    }
}



#pragma mark - Reset User Stats

#warning Attention!!!! This method only for testing. Not Production!!!!!

+ (void)resetUserCountersInputComBlock:(void (^)(NSError *error))comBlock{
    
    NSString        *request = [NSString stringWithFormat:@"api/v1/user/me/meters/reset?token=%@", [CurrentUserInstance token]];
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:nil
                                                   requestType:requestTypeGet success:^(id responseObject) {
                                                           comBlock(nil);
                                                   } failure:^(NSError *error) {
                                                       comBlock(error);
                                                   }];
}

#pragma marl - Counters For Report

- (void)getCountersForInputComBlock:(void (^)(NSError *error))comBlock{
    
    NSString        *request = [NSString stringWithFormat:@"api/v1/user/me/meters?token=%@", [CurrentUserInstance token]];
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:nil
                                                   requestType:requestTypeGet success:^(id responseObject) {
                                                       if ([responseObject isKindOfClass:[NSArray class]]){
                                                           [self inputCountersLoaded:responseObject];
                                                           comBlock(nil);
                                                       }
                                                   } failure:^(NSError *error) {
#warning TODO: User Request errors processing
                                                       comBlock(error);
                                                   }];
}

- (void)inputCountersLoaded:(NSArray *)array{
    self.countersInputs = [NSMutableArray new];
    for (int i = 0; i < array.count; i++) {
        NSDictionary *currentCounter = array[i];
        CounterReportModel *report = [[CounterReportModel alloc] initWithDict:currentCounter];
        [self.countersInputs addObject:report];
    }
}

#pragma mark - Send User Reports

+ (void)sendUserReports:(NSDictionary*)dict comBlock:(void (^)(id responseObject, NSError *error))comBlock{
    
    NSString *request = [NSString stringWithFormat:@"api/v1/user/me/meters?&token=%@", [CurrentUserInstance token]];
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:dict
                                                   requestType:requestTypePost success:^(id responseObject) {
                                                       
                                                       comBlock(responseObject,nil);
                                                       
                                                   } failure:^(NSError *error) {
#warning TODO: User Request errors processing
                                                       comBlock(nil,error);
                                                   }];
}

#pragma mark - Send User Reports

+ (void)sendCounterLabel:(NSDictionary*)dict comBlock:(void (^)(id responseObject, NSError *error))comBlock{
    
    NSString *request = [NSString stringWithFormat:@"api/v1/user/me/meter/label?&token=%@&_method=PUT", [CurrentUserInstance token]];
    
    [[APIRequestManager sharedInstance] downloadJSONDataMethod:request
                                                        params:dict
                                                   requestType:requestTypePost success:^(id responseObject) {
                                                       
                                                       comBlock(responseObject,nil);
                                                       
                                                   } failure:^(NSError *error) {
#warning TODO: User Request errors processing
                                                       comBlock(nil,error);
                                                   }];
}

@end
