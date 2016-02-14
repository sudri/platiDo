//
//  BillingTableViewCell.h
//  PlatiDo
//
//  Created by Smart Labs on 09.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillingViewController.h"
#import "Charge.h"
#import "Bill.h"

@interface BillingTableViewCell : UITableViewCell

@property (nonatomic, strong) Bill *bill;
@property (nonatomic, strong) UIViewController *parentViewController;

@property (nonatomic, assign) BOOL hidePayButton;

@end
