//
//  CommonDataProvider.h
//  
//
//  Created by Valera Voroshilov on 15.09.15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define CommonDataProviderInstance [CommonDataProvider sharedInstance]
@interface CommonDataProvider : NSObject
+ (CommonDataProvider*)sharedInstance;

@property (nonatomic, assign) BOOL createRequestAfterAppear;
@property (nonatomic, assign) BOOL createVoteAfterAppear;
@property (nonatomic, assign) BOOL createDiscuttionsAfterAppear;


@end
