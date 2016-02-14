//
//  ChargeTableViewCell.m
//  PlatiDo
//
//  Created by Smart Labs on 09.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "ChargeTableViewCell.h"

@interface ChargeTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *tarif;
@property (weak, nonatomic) IBOutlet UILabel *sum;

@end

@implementation ChargeTableViewCell

- (void)setCharge:(Charge *)charge
{
    _charge = charge;
    self.name.text = charge.uid;
    self.tarif.text = [NSString stringWithFormat:@"%.2f",charge.tarif];
    self.sum.text = [NSString stringWithFormat:@"%.2f",charge.sum];
}

@end
