//
//  PopUpController.h
//  TestCoolTransition
//
//  Created by Valera Voroshilov on 23.07.15.
//  Copyright (c) 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>
static CGFloat const kDamping = 0.5;
static CGFloat const kInitialSpringVelocity = 0.3;

@interface PopUpController : UIViewController
@property (copy, nonatomic) void (^complitationBlock)();
@property (nonatomic, strong)  IBOutlet UIView *contentView;
- (IBAction)closeBtnTapped:(id)sender;
@end
