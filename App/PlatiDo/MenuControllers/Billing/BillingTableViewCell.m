//
//  BillingTableViewCell.m
//  PlatiDo
//
//  Created by Smart Labs on 09.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "BillingTableViewCell.h"
#import "ChargeTableViewCell.h"
#import "UIColor+Additions.h"
#import "UIView+Additional.h"

@interface BillingTableViewCell()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *payerLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberBillLabel;
@property (weak, nonatomic) IBOutlet UILabel *commissionPayLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundViewWithShadow;
@property (weak, nonatomic) IBOutlet UILabel *commisionFeeLabel;

@end

@implementation BillingTableViewCell


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self.backgroundViewWithShadow drawShadow];    
}

- (void)setBill:(Bill *)bill
{
    _bill = bill;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
    self.sumLabel.text = [NSString stringWithFormat:@"%@ %.2f ₽",NSLocalizedString(@"Total:", nil),_bill.sum];
    self.commisionFeeLabel.text = [NSString stringWithFormat:@"%@ %@%%",NSLocalizedString(@"Commission fee for payment of ", nil),_bill.fee_percent];
    self.payerLabel.text = _bill.payer;
    
    NSString *billFormat = [_bill.month stringByReplacingOccurrencesOfString:@"." withString:@"/"];
    
    NSArray *ar = [_bill.month componentsSeparatedByString:@"."];
    NSString *monthNumber = ar[0];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthName = [[df standaloneMonthSymbols] objectAtIndex:([monthNumber intValue]-1)];
    
    self.periodLabel.text = [NSString stringWithFormat:@"%@ %@",[monthName capitalizedString],ar[1]];
    self.numberBillLabel.text = [NSString stringWithFormat:@"%@ № %@", NSLocalizedString(@"Receipt", nil), billFormat];
//    self.commissionPayLabel.text = [NSString stringWithFormat:@"%@ %.2f ₽", NSLocalizedString(@"TOTAL PAYABLE:", nil), _bill.sum_with_fee];
    self.commissionPayLabel.text = [NSString stringWithFormat:@"%@ %@ ₽", NSLocalizedString(@"TOTAL PAYABLE:", nil), _bill.sum_with_fee];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bill.charges count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChargeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChargeCell" forIndexPath:indexPath];
    Charge *charge = [self.bill.charges objectAtIndex:indexPath.row];
    cell.charge = charge;
    if (indexPath.row % 2)
    {
        
    }else{
        cell.contentView.backgroundColor = [UIColor colorWithHex:0x2B5ABB alpha:0.05];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.parentViewController respondsToSelector:@selector(showChargeDescriptionWithCharge:)])
    {
        [(id)self.parentViewController showChargeDescriptionWithCharge:[self.bill.charges objectAtIndex:indexPath.row]];
    }
}
- (IBAction)tapPayButton:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Payments available", nil)  message:NSLocalizedString(@"Functionality is not working", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
    [alert show];
    
}

- (void)setHidePayButton:(BOOL)hidePayButton
{
    _hidePayButton = hidePayButton;
    self.payButton.hidden = hidePayButton;
    self.commissionPayLabel.hidden = hidePayButton;
    self.commisionFeeLabel.hidden = hidePayButton;
}

@end
