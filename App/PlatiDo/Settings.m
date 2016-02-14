//
//  Settings.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 28.07.15.
//  Copyright (c) 2015 Valera Voroshilov. All rights reserved.
//

#import "Settings.h"
#import "CurrentUser.h"
#import "AppDelegate.h"
#import "OwnershipHelper.h"
#import "ConfirmRightsViewController.h"
#import "SettingsApi.h"

#import "MBProgressHUD.h"
#import "SwipeMenuController.h"

@interface Settings() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *midNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *editAdressButton;

@property (strong, nonatomic) NSArray* menuItems;

@end

@implementation Settings

- (void)viewDidLoad{
    
    self.navigationItem.title = NSLocalizedString(@"Settings", nil);
    self.menuItems = @[NSLocalizedString(@"Verify ownership", nil),
                       NSLocalizedString(@"Notifications", nil),
                       NSLocalizedString(@"Change Password", nil),
                       NSLocalizedString(@"Change Pin", nil),
                       NSLocalizedString(@"Exit", nil)];
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius  = 35;
    
    [CurrentUserInstance setNotificationSettings:NotificationSettingsChangesMyRequest];
    
    NSString *name = [NSString stringWithFormat:@"%@ %@ %@",[CurrentUserInstance surname],[CurrentUserInstance name], [CurrentUserInstance midName]];
    self.nameLabel.text = name;
    
    [self initTextFields];
    
    NSString *phoneString = [CurrentUserInstance phoneNumber];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@ (%@) %@-%@", [phoneString substringToIndex:2], [phoneString substringWithRange:NSMakeRange(2, 3)], [phoneString substringWithRange:NSMakeRange(5, 3)], [phoneString substringFromIndex:8]];
    
    NSString *adress = [NSString stringWithFormat:@"%@, %@, д.%@, корп.%@",[CurrentUserInstance town],[CurrentUserInstance street],[CurrentUserInstance building],[CurrentUserInstance partBuilding]];
    self.adressLabel.text = adress;
    self.emailLabel.text  = [CurrentUserInstance email]?[CurrentUserInstance email]:@"<user@host.ru>";
    
    
}

- (NSString *)adressString
{
    NSString *adr = [NSString stringWithFormat:@"%@, %@, д.%@",[CurrentUserInstance town],[CurrentUserInstance street],[CurrentUserInstance building]];
    
    if ([CurrentUserInstance partBuilding])
    {
        adr = [adr stringByAppendingString:[NSString stringWithFormat:@", корп.%@",[CurrentUserInstance partBuilding]]];
    }
    if ([CurrentUserInstance ownershipStatus] == OwnershipStatusConfirm && [CurrentUserInstance apartament]){
        adr = [adr stringByAppendingString:[NSString stringWithFormat:@", кв.%@",[CurrentUserInstance apartament]]];
    }
    
    return adr;
}

- (void)initTextFields
{
    self.firstNameTextField.delegate = self;
    self.midNameTextField.delegate   = self;
    self.lastNameTextField.delegate  = self;
    self.firstNameTextField.placeholder = NSLocalizedString(@"Name", nil);
    self.lastNameTextField.placeholder = NSLocalizedString(@"Surname", nil);
    self.midNameTextField.placeholder = NSLocalizedString(@"Second Name", nil);
    self.emailTextField.placeholder = NSLocalizedString(@"Email", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateLabels];
}

- (void)updateLabels
{
    NSString *name = [NSString stringWithFormat:@"%@ %@ %@",[CurrentUserInstance surname],[CurrentUserInstance name], [CurrentUserInstance midName]];
    self.nameLabel.text = name;
    self.emailLabel.text = [[CurrentUserInstance email] length]==0?@"<user@host.ru>":[CurrentUserInstance email];
    
    if (self.editAdressButton.hidden)
    {
        self.adressLabel.text = [self adressString];
    } else {
        NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
        self.adressLabel.attributedText = [[NSAttributedString alloc] initWithString:[self adressString]
                                                                          attributes:underlineAttribute];
    }

}

- (IBAction)exitPressed:(id)sender {
    [CurrentUserInstance setPinCode:@""];
    [CurrentUserInstance setIsPinEntryScreenShowed:NO];
    [CurrentUserInstance setToken:@""];
    [shareAppDelegate    showAuthorization];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"SettingsCell" forIndexPath:indexPath];
    cell.textLabel.text = self.menuItems[indexPath.row];
    if (indexPath.row == 0)
    {
        OwnershipStatus stat = [CurrentUserInstance ownershipStatus];
        if (stat != OwnershipStatusNotconfirm)
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case 0:
            [self segueConfirmRightsViewController];
            break;
        case 1:
            [self performSegueWithIdentifier:@"segueNotifications" sender:nil];
            break;
        case 2:
            [self performSegueWithIdentifier:@"segueChangePassword" sender:nil];
            break;
        case 3:
            [self performSegueWithIdentifier:@"segueChangePIN" sender:nil];
            break;
        case 4:
            [self exitPressed:nil];
            break;
            
        default:
            break;
    }
}

- (IBAction)tapEditBarButton:(UIBarButtonItem *)sender {
    
    self.lastNameTextField.hidden = NO;
    self.firstNameTextField.hidden = NO;
    self.midNameTextField.hidden = NO;
    self.emailTextField.hidden = NO;
    self.firstNameTextField.text = [CurrentUserInstance name];
    self.midNameTextField.text   = [CurrentUserInstance midName];
    self.lastNameTextField.text  = [CurrentUserInstance surname];
    self.emailTextField.text     = [CurrentUserInstance email];
    
    self.nameLabel.hidden = YES;
    self.emailLabel.hidden = YES;
    
    if (CurrentUserInstance.ownershipStatus == OwnershipStatusNotconfirm)
    {
        self.editAdressButton.hidden = NO;
        NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
        self.adressLabel.attributedText = [[NSAttributedString alloc] initWithString:self.adressLabel.text
                                                                 attributes:underlineAttribute];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tapDone)];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    
    if ([self.parentViewController.parentViewController isKindOfClass:[SwipeMenuController class]])
    {
        SwipeMenuController *smc = (SwipeMenuController *)self.parentViewController.parentViewController;
        [smc setSwipeLocked:YES];
    }
    
    [self.lastNameTextField becomeFirstResponder];
    
}
                                              
- (void)tapDone
{
    [self.firstNameTextField resignFirstResponder];
    [self.lastNameTextField resignFirstResponder];
    [self.midNameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    self.lastNameTextField.hidden = YES;
    self.firstNameTextField.hidden = YES;
    self.midNameTextField.hidden = YES;
    self.emailTextField.hidden   = YES;
    
    self.nameLabel.hidden = NO;
    self.emailLabel.hidden = NO;
    
    self.editAdressButton.hidden = YES;
    self.adressLabel.text = self.adressLabel.text;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(tapEditBarButton:)];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    if ([self.parentViewController.parentViewController isKindOfClass:[SwipeMenuController class]])
    {
        SwipeMenuController *smc = (SwipeMenuController *)self.parentViewController.parentViewController;
        [smc setSwipeLocked:NO];
    }
    
    NSDictionary *dict = @{@"surname":self.lastNameTextField.text,
                           @"name"   :self.firstNameTextField.text,
                           @"mid_name":self.midNameTextField.text,
                           @"email"   :self.emailTextField.text
                           };
    MBProgressHUD*hood = [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    [SettingsApi editRequest:dict comBlock:^(id respObj, NSError *error)
     {
         if (!error)
         {
             [CurrentUserInstance setName:self.firstNameTextField.text];
             [CurrentUserInstance setSurname:self.lastNameTextField.text];
             [CurrentUserInstance setMidName:self.midNameTextField.text];
             [CurrentUserInstance setEmail:self.emailTextField.text];
             [CurrentUserInstance saveYourSelf];
             [self updateLabels];
             
         }
         NSLog(@"%@", error.localizedDescription);
         
         [hood removeFromSuperview];
     }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.lastNameTextField)
    {
        [self.firstNameTextField becomeFirstResponder];
    } else if (textField == self.firstNameTextField)
    {
        [self.midNameTextField becomeFirstResponder];
    } else if (textField == self.midNameTextField)
    {
        [self.emailTextField becomeFirstResponder];
    } else if (textField == self.emailTextField)
    {
        [self.emailTextField resignFirstResponder];
    }
    
    return YES;
}

- (void)segueConfirmRightsViewController
{
    OwnershipStatus stat = [CurrentUserInstance ownershipStatus];
    if (stat != OwnershipStatusNotconfirm)
    {
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ConfirmRightsViewController* confirmRightsViewController = [storyboard instantiateViewControllerWithIdentifier:@"ConfirmRightsViewController"];
    __weak ConfirmRightsViewController *confirmRightsViewController1 = confirmRightsViewController;
    [confirmRightsViewController setCompletionBlock:^(OwnershipStatus status){
        
        [confirmRightsViewController1.navigationController popViewControllerAnimated:YES];
        [self.tableView reloadData];
        
    }];
    [self.navigationController pushViewController:confirmRightsViewController animated:YES];
}

- (IBAction)editAdress:(UIButton *)sender {
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
//    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"Reg_Page1"];
//    [self presentViewController:viewController animated:YES completion:nil];
    
}

@end
