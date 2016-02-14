//
//  Charge.h
//  PlatiDo
//
//  Created by Smart Labs on 09.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "JSONModel.h"

@interface Charge : JSONModel

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, assign) float     sum;
@property (nonatomic, assign) float     tarif;
@property (nonatomic, assign) float     discount;
@property (nonatomic, assign) float     fullSum;
@property (nonatomic, assign) float     normative;
@property (nonatomic, assign) float     correction;

@end
