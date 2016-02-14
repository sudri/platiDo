//
//  BillingViewController.h
//  PlatiDo
//
//  Created by Smart Labs on 08.09.15.
//  Copyright (c) 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BillingRequestApi.h"
#import "Bill.h"
#import "Charge.h"

@interface BillingViewController : UIViewController

@property (strong, nonatomic) NSArray *charges;

- (void)showChargeDescriptionWithCharge:(Charge *)charge;
- (void)hideSearchMode;

@end
