//
//  AppDelegate.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 10.07.15.
//  Copyright (c) 2015 Valera Voroshilov. All rights reserved.
//

#import "AppDelegate.h"
#import "CurrentUser.h"
#import "SwipeMenuController.h"
#import "MainMenuViewController.h"
#import "CoreDataStack.h"
#import "RegistarationAPI.h"
#import "UIColor+Additions.h"
#import "PasswordAuthorizationViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong) SwipeMenuController    *swipeContainer;
@property (nonatomic, strong) MainMenuViewController *menu;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    if ([CurrentUserInstance token]){
        [self showAuthorization];
    } else {
        [self showTutorial];
    }

    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:0x0F2C86]}];
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithHex:0x0F2C86]];

    [self.window makeKeyAndVisible];

    self.hostReach = [Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:self.hostReach];
    [self.hostReach startNotifier];
    [self updateInterfaceWithReachability: self.hostReach];

    
    return YES;
}

- (void)showMainMenu{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.menu   = [storyboard instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
    
    self.swipeContainer = [[SwipeMenuController alloc] initWithLeftMasterController:self.menu RightMsterController:nil];
    [self.swipeContainer setLeftMasterWidth:260];
    
    [self.window setRootViewController:self.swipeContainer];
    [self showMenuSequeByName:@"ShowDashBoardViewController"];
}

- (void)showMenuSequeByName:(NSString*)segueId{
    [self.menu performSegueWithIdentifier:segueId sender:self];
}

- (void)showAuthorization{
    if (![self.window.rootViewController isKindOfClass:[PasswordAuthorizationViewController class]]){
        [self showController:@"PasswordAuthorizationViewController" inStoryboard:@"Authorization"];
    }
}

- (void)showTutorial{
    [self showController:@"TutorialMainController" inStoryboard:@"Tutorial"];
}

- (void)showController:(NSString*)controllerName inStoryboard:(NSString*)storyboardName{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:controllerName];
    self.window.rootViewController   = viewController;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [shareCoreDataStack saveContext];
    [CurrentUserInstance saveYourSelf];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [shareCoreDataStack saveContext];
    [CurrentUserInstance saveYourSelf];
}

#pragma mark - Reachability

- (void)updateInterfaceWithReachability: (Reachability*) curReach {
    
    self.netStatus = [curReach currentReachabilityStatus];
}

- (void)reachabilityChanged:(NSNotification* )note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
}

@end
