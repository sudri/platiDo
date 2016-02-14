//
//  BillingRequestApi.h
//  PlatiDo
//
//  Created by Smart Labs on 09.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillingRequestApi : NSObject

+ (void)currentBillWithComBlock:(void (^)(id responseObject, NSError *error))comBlock;
+ (void)historyBillWithComBlock:(void (^)(id responseObject, NSError *error))comBlock;

@end
