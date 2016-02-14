//
//  MyCompanyViewController.m
//  
//
//  Created by Valera Voroshilov on 11.09.15.
//
//

#import "MyCompanyViewController.h"
#import "AppDelegate.h"

@interface MyCompanyViewController ()

@end

@implementation MyCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [shareAppDelegate showMainMenu];
    NSURL *url = [NSURL URLWithString:@"http://www.cosmoservice.spb.ru/"];
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
