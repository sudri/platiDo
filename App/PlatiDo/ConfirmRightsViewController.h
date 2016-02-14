//
//  ConfirmRightsViewController.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 13.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentUser.h"

@interface ConfirmRightsViewController : UIViewController

@property (nonatomic, copy) void(^completionBlock)(OwnershipStatus status);

@end
