//
//  ConfirmRightsAPI.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 14.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfirmRightsAPI : NSObject
+ (void)sendFlatInfo:(NSDictionary*)params comblock:(void (^)(NSDictionary *responce, NSError *error))comBlock;
@end
