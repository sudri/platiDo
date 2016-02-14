//
//  UserAgent.m
//  CamOnRoad
//
//  Created by Fedor Semenchenko on 22.10.14.
//  Copyright (c) 2014 Dmitry Doroschuk. All rights reserved.
//

#import "UserAgent.h"
#include <sys/utsname.h>
@import UIKit;


@implementation UserAgent

+ (NSString *) getUserAgent
{
    NSString *osVer = [[UIDevice currentDevice] systemVersion];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

    struct utsname u;
    uname(&u);
    char *type = u.machine;

    NSString *strType = [NSString stringWithFormat:@"%s", type];

    NSString *model = [NSString stringWithFormat:@"%@ %@", [[UIDevice currentDevice] model], strType];
    NSDictionary *userDict = @{@"os" : @"iOs",
    @"os_v" : osVer,
    @"app_v" : appVersion,
    @"model" : model};
    return [userDict description];
}

@end
