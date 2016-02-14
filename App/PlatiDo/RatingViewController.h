//
//  RatingViewController.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 07.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserRequestModel;

@protocol RatingViewDelegate <NSObject>

@required

- (void)userRequestClosed;

@end

@interface RatingViewController : UIViewController

@property (strong, nonatomic) UserRequestModel  * currentUserRequestModel;
@property (nonatomic, strong) UIImage           * blurredImage;

@property (weak) id <RatingViewDelegate>  delegate;

@end
