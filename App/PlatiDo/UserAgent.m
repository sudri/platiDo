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
//    NSString *uniqueStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"uniqueStrForUA"];
//    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    NSString *stringWithoutDefis = [idfv stringByReplacingOccurrencesOfString:@"-" withString:@""];
//  
//    NSString *userAgent = [NSString stringWithFormat:@"iOS|%@|%@|Apple||%@%@", [UIDevice currentDevice].systemVersion, [UIDevice deviceName], uniqueStr, stringWithoutDefis];

    //NSLog(@"userAgent %@", userAgent);
    //User-Agent: {"os":"iOS","os_v":"8.0.3","app_v":"1.0.1","model":"iPhone 4.1","полезная инфа 1":"тут"}
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
    NSLog(@"%s %@",__PRETTY_FUNCTION__,userDict);
    return [userDict description];
}

@end
