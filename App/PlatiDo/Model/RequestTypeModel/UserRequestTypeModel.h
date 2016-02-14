//
//  UserRequestTypeModel.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 01.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface UserRequestTypeModel : JSONModel <NSCoding>


@property (strong, nonatomic) NSString * label;
@property (strong, nonatomic) NSString * value;


+ (void)saveArrayInDefaults: (NSArray *) arrayOfUserRequestTypes;
+ (NSArray *)getArrayOfUserRequestTypes;

@end
