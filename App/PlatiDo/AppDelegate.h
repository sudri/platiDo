//
//  AppDelegate.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 10.07.15.
//  Copyright (c) 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Reachability/Reachability.h>

#define shareAppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]


@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

- (void)showController:(NSString*)controllerName inStoryboard:(NSString*)storyboardName;
- (void)showMainMenu;
- (void)showTutorial;
- (void)showAuthorization;
- (void)showMenuSequeByName:(NSString*)segueId;

@property (assign, nonatomic) NetworkStatus netStatus;
@property (strong, nonatomic) Reachability  *hostReach;


@end

