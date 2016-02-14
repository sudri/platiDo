//
//  CommonDataProvider.m
//  
//
//  Created by Valera Voroshilov on 15.09.15.
//
//

#import "CommonDataProvider.h"


static CommonDataProvider *sCommonDataProviderInstance;
@implementation CommonDataProvider
{
    UIImage *_likeImage;
    UIImage *_disLikeImage;
}
+ (CommonDataProvider*)sharedInstance{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if (sCommonDataProviderInstance == nil){
            sCommonDataProviderInstance = [[self alloc] init];
        }
    });
    return sCommonDataProviderInstance;
}

@end
