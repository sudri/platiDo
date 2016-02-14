//
//  DetailPaidBillViewController.m
//  PlatiDo
//
//  Created by Smart Labs on 10.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DetailPaidBillViewController.h"
#import "ChargeDescriptionViewController.h"
#import "BillingTableViewCell.h"

#import "UIColor+Additions.h"

@interface DetailPaidBillViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Charge *chargeForDescription;

@end

@implementation DetailPaidBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int k = [self.bill.charges count]*27+125+142-109;
    return k;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BillingTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BillingCell" forIndexPath:indexPath];
    cell.bill = self.bill;
    cell.parentViewController = self;
    cell.hidePayButton = YES;
    
    return cell;
}

- (void)showChargeDescriptionWithCharge:(Charge *)charge
{
    self.chargeForDescription = charge;
    [self performSegueWithIdentifier:@"ChargeDescriptionFromPaid" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ChargeDescriptionFromPaid"])
    {
        ChargeDescriptionViewController *vc = segue.destinationViewController;
        vc.charge = self.chargeForDescription;
    }
}

@end
