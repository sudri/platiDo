//
//  ChargeDescriptionViewController.h
//  PlatiDo
//
//  Created by Smart Labs on 10.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Charge.h"

@interface ChargeDescriptionViewController : UIViewController

@property (nonatomic, strong) Charge *charge;
@property (nonatomic, strong) UIImage *blurredImage;

@end
