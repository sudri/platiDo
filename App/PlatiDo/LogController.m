//
//  LogController.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 29.07.15.
//  Copyright (c) 2015 Valera Voroshilov. All rights reserved.
//

#import "LogController.h"

@implementation LogController

- (IBAction)closePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLocalizedString(@"some string", @"костыль");
}

@end
