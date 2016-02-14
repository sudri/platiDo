//
//  Bill.h
//  PlatiDo
//
//  Created by Smart Labs on 09.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "JSONModel.h"
#import "Charge.h"

@interface Bill : JSONModel

@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *payer;
@property (nonatomic, strong) NSArray <ConvertOnDemand,Charge *> *charges;
@property (nonatomic) float sum;
@property (nonatomic) NSNumber *sum_with_fee;
@property (nonatomic) NSNumber *fee_percent;


@end
