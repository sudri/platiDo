//
//  DetailUserRequestViewController.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 03.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class UserRequestModel;

@interface DetailUserRequestViewController : UIViewController


@property (strong, nonatomic) UserRequestModel   * currentUserRequestModel;

@end
