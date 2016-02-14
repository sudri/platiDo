//
//  UserAgent.m
//  CamOnRoad
//
//  Created by Fedor Semenchenko on 22.10.14.
//  Copyright (c) 2014 Dmitry Doroschuk. All rights reserved.
//

#import "UserAgent.h"

@implementation UserAgent

+ (NSString *) getUserAgent
{
//    NSString *uniqueStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"uniqueStrForUA"];
//    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    NSString *stringWithoutDefis = [idfv stringByReplacingOccurrencesOfString:@"-" withString:@""];
//  
//    NSString *userAgent = [NSString stringWithFormat:@"iOS|%@|%@|Apple||%@%@", [UIDevice currentDevice].systemVersion, [UIDevice deviceName], uniqueStr, stringWithoutDefis];

    //NSLog(@"userAgent %@", userAgent);
    return @"";
}

@end
