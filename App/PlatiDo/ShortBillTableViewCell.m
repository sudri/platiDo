//
//  ShortBillTableViewCell.m
//  PlatiDo
//
//  Created by Smart Labs on 10.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "ShortBillTableViewCell.h"

@interface ShortBillTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *billNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;


@end

@implementation ShortBillTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBill:(Bill *)bill
{
    _bill = bill;
    self.sumLabel.text = [NSString stringWithFormat:@"%.2f ₽", bill.sum];
    self.billNumberLabel.text = [NSString stringWithFormat:@"%@ № %@", NSLocalizedString(@"Receipt", nil), _bill.month];
}

@end
