//
//  ArchiveCounterModel.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 11.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CounterModel.h"

@interface ArchiveCounterModel : CounterModel

@property (strong, nonatomic) NSString  *title;
@property (strong, nonatomic) NSString  *subtitle;

@property (strong, nonatomic) NSString  *value;

- (ArchiveCounterModel *)initWithDict:(NSDictionary *)dict;

@end
