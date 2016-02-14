//
//  UIViewController+ConfirmRightsController.h
//  
//
//  Created by Valera Voroshilov on 13.09.15.
//
//

#import <UIKit/UIKit.h>
#import "CurrentUser.h"

@interface OwnershipHelper : NSObject

- (id)initWithViewController:(UIViewController*)viewController;
@property (nonatomic, copy) void(^completionBlock)(OwnershipStatus status);
@end
