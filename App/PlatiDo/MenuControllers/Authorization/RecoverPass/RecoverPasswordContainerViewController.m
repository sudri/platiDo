//
//  RecoverPasswordViewController.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 22.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "RecoverPasswordContainerViewController.h"
#import "UIImage+ImageEffects.h"
#import "SendPhoneForPassViewController.h"
#import "RecoverPassSmsViewController.h"
#import "PasswordEntryViewController.h"


@interface RecoverPasswordContainerViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgContent;
@property (weak, nonatomic) IBOutlet UIImageView *frontImage;


@property (strong, nonatomic) SendPhoneForPassViewController *sendPhoneForPassViewController;
@property (strong, nonatomic) RecoverPassSmsViewController   *recoverPassSmsViewController;
@property (strong, nonatomic) PasswordEntryViewController    *passwordEntryViewController;


@end

@implementation RecoverPasswordContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.frontImage setImage:[UIImage imageNamed:@"blurBg"]];
    [self.frontImage setHidden:NO];
    
    UIStoryboard *storyboard            = [UIStoryboard storyboardWithName:@"Authorization" bundle:nil];
    
    self.sendPhoneForPassViewController = [storyboard instantiateViewControllerWithIdentifier:@"SendPhoneForPassViewController"];
    self.recoverPassSmsViewController   = [storyboard instantiateViewControllerWithIdentifier:@"RecoverPassSmsViewController"];
    self.passwordEntryViewController    = [storyboard instantiateViewControllerWithIdentifier:@"PasswordEntryViewController"];

    __weak typeof (self) weakSelf = self;
    [self.sendPhoneForPassViewController setComplitationBlock:^{
        [weakSelf removeViewController:weakSelf.sendPhoneForPassViewController];
        [weakSelf showViewController:weakSelf.recoverPassSmsViewController];
    }];
    
    [self.recoverPassSmsViewController setComplitationBlock:^{
        [weakSelf removeViewController:weakSelf.recoverPassSmsViewController];
        [weakSelf showViewController:weakSelf.passwordEntryViewController];
    }];
    
    [self.passwordEntryViewController setComplitationBlock:^{
        [weakSelf removeViewController:weakSelf.passwordEntryViewController];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self showViewController:self.sendPhoneForPassViewController];
}

- (void)showViewController:(UIViewController*)controller{
    [controller.view setFrame:self.view.bounds];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    [self.view addSubview:controller.view];
}

- (void)removeViewController:(UIViewController*)controller{
    [controller removeFromParentViewController];
    [controller didMoveToParentViewController:nil];
    [controller.view removeFromSuperview];
}

@end
