//
//  ChangePasswordViewController.m
//  PlatiDo
//
//  Created by Smart Labs on 13.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *currentPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@end

@implementation ChangePasswordViewController

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

- (void)backVC{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)tapChangePasswordButton:(UIButton *)sender {
    
    if (!self.passwordTextField.text.length || !self.confirmPasswordTextField.text.length || !self.currentPasswordTextField.text.length)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Fill in all the fields", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Password mismatch", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSDictionary *dict = @{@"password":self.passwordTextField.text,
                           @"password_confirm":self.confirmPasswordTextField.text,
                           @"old_password":self.currentPasswordTextField.text};
    
    [SettingsApi editRequest:dict comBlock:^(id respObj, NSError *error){
        
        if (error)
        {
            NSString *errorMessage = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"Unable to change the password", nil), [error.userInfo objectForKey:@"NSLocalizedDescription"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(errorMessage, nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
            [alert show];
        }
        if (respObj)
        {
            NSString *errorMessage = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Password successfully changed", nil)];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Succesful", nil) message:NSLocalizedString(errorMessage, nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
            [alert show];
        }
    }];
    
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
