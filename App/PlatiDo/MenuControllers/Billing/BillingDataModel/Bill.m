//
//  Bill.m
//  PlatiDo
//
//  Created by Smart Labs on 09.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "Bill.h"

@implementation Bill
+ (JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                   @"sum"       : @"sum",
            @"sum_with_fee" : @"sum_with_fee",
            @"fee_percent" : @"fee_percent",
                                                   @"month"     : @"month",
                                                   @"charges"   : @"charges",
                                                   @"name"      : @"payer"
                                                   }];
}

@end
