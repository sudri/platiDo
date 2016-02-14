//
//  SettingsApi.h
//  PlatiDo
//
//  Created by Smart Labs on 13.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsApi : NSObject

+ (void)editRequest:(NSDictionary*)dict comBlock:(void (^)(id responseObject, NSError *error))comBlock;

+ (void)editAdressRequest:(NSDictionary*)dict comBlock:(void (^)(id responseObject, NSError *error))comBlock;

@end
