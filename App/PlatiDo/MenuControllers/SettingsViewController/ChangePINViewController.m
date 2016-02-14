//
//  ChangePINViewController.m
//  PlatiDo
//
//  Created by Smart Labs on 13.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "ChangePINViewController.h"
#import "CurrentUser.h"

@interface ChangePINViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *currentPinTextField;
@property (weak, nonatomic) IBOutlet UITextField *pinTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPinTextField;

@end

@implementation ChangePINViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"back"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(backVC)];
    
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backVC{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)tapChangePINButton:(id)sender {
    
    if (!self.pinTextField.text.length || !self.confirmPinTextField.text.length || !self.currentPinTextField.text.length)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Fill in all the fields", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (!(self.pinTextField.text.length==4) || !(self.confirmPinTextField.text.length==4) || !(self.currentPinTextField.text.length==4))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"PIN must be 4 numbers", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (![self.pinTextField.text isEqualToString:self.confirmPinTextField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"PIN mismatch", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (![self.currentPinTextField.text isEqualToString:[CurrentUserInstance pinCode]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Check current PIN", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [CurrentUserInstance setPinCode:self.pinTextField.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (newLength > 4) return NO;
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
