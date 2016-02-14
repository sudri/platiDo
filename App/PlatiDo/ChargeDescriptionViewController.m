//
//  ChargeDescriptionViewController.m
//  PlatiDo
//
//  Created by Smart Labs on 10.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "ChargeDescriptionViewController.h"
#import "UIColor+Additions.h"

@interface ChargeDescriptionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tarifLabel;
@property (weak, nonatomic) IBOutlet UILabel *normativeLavel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *recalculationLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *uidLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *blurredImageView;



@end

@implementation ChargeDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contentView.layer.borderColor = [UIColor colorWithHex:0xAAAAAA].CGColor;
    self.contentView.layer.borderWidth = 0.5f;
    self.contentView.layer.cornerRadius = 3;
    self.contentView.layer.masksToBounds = YES;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.contentView.bounds];
    self.contentView.layer.masksToBounds = NO;
    self.contentView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    self.contentView.layer.shadowOpacity = 0.3f;
    self.contentView.layer.shadowPath = shadowPath.CGPath;
    
    //    self.closeRequestButton.layer.cornerRadius = 3;
    //    self.closeRequestButton.clipsToBounds = YES;
    self.charge = self.charge;
    self.blurredImageView.image = self.blurredImage;
    
}

- (IBAction)tapCloseButton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)setBlurredImage:(UIImage *)blurredImage
{
    _blurredImage = blurredImage;
    self.blurredImageView.image = _blurredImage;
}

- (void)setCharge:(Charge *)charge
{
    _charge = charge;
    self.tarifLabel.text = [NSString stringWithFormat:@"%.2f",self.charge.tarif];
    self.normativeLavel.text = [NSString stringWithFormat:@"%.2f",self.charge.normative];
    self.discountLabel.text = [NSString stringWithFormat:@"%.2f",self.charge.discount];
    self.recalculationLabel.text = [NSString stringWithFormat:@"%.2f",self.charge.correction];
    self.sumLabel.text = [NSString stringWithFormat:@"%.2f",self.charge.fullSum];
    self.costLabel.text = [NSString stringWithFormat:@"%.2f",self.charge.sum];
    self.uidLabel.text = charge.uid;
    [self.view setNeedsDisplay];
}

@end
