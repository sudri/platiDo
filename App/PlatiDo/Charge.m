//
//  Charge.m
//  PlatiDo
//
//  Created by Smart Labs on 09.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "Charge.h"

@implementation Charge

+ (JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id"        : @"uid",
                                                       @"sum"       : @"sum",
                                                       @"tarif"     : @"tarif",
                                                       @"discount"  : @"discount",
                                                       @"full_sum"   : @"fullSum",
                                                       @"normative" : @"normative",
                                                       @"correction": @"correction"
                                                       }];
}

@end
