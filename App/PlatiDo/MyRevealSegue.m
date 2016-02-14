//
//  MyRevealSegue.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 27.07.15.
//  Copyright (c) 2015 Valera Voroshilov. All rights reserved.
//

#import "MyRevealSegue.h"
#import "AppDelegate.h"
#import "SwipeMenuController.h"

@implementation MyRevealSegue

- (void)perform{
   
    UINavigationController *navcontroller = self.destinationViewController;
    
    NSArray *viewControllers = navcontroller.viewControllers;

    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:[viewControllers firstObject]];
    [((SwipeMenuController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController) setDetailViewController:nc];
}

@end
