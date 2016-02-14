//
//  DetailPaidBillViewController.h
//  PlatiDo
//
//  Created by Smart Labs on 10.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"

@interface DetailPaidBillViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) Bill *bill;

- (void)showChargeDescriptionWithCharge:(Charge *)charge;

@end
