//
//  PasswordEntryViewController.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 24.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordEntryViewController : UIViewController
@property (copy, nonatomic) void (^complitationBlock)();
@end
