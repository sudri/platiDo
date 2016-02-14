//
//  PopUpController.m
//  TestCoolTransition
//
//  Created by Valera Voroshilov on 23.07.15.
//  Copyright (c) 2015 Valera Voroshilov. All rights reserved.
//

#import "PopUpController.h"


@implementation PopUpController
{
    UIVisualEffectView *_visualEffectView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
 
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _visualEffectView.frame = self.parentViewController.view.bounds;
    _visualEffectView.alpha  = 0;
    
    [self.view addSubview:_visualEffectView];
    [self.view sendSubviewToBack:_visualEffectView];
}


- (void)viewWillAppear:(BOOL)animated{
   self.contentView.transform = CGAffineTransformMakeTranslation(0,  CGRectGetMaxY(self.view.frame));
}

- (void)viewDidAppear:(BOOL)animated{
    [self showMe];
}


- (void)hideMe{
    [UIView animateWithDuration:0.7 delay:0
         usingSpringWithDamping:kDamping
          initialSpringVelocity:kInitialSpringVelocity options:0x00 animations:^{
              self.contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetMaxY(self.view.frame));
          } completion:^(BOOL finished) {
              [UIView animateWithDuration:0.2 animations:^{
                  _visualEffectView.alpha = 0;
              }completion:^(BOOL finished) {
                  if (self.navigationController==nil){
                      [self removeFromParentViewController];
                      [self.view removeFromSuperview];
                      [self didMoveToParentViewController:nil];
                  }else {
                      [self.parentViewController removeFromParentViewController];
                      [self.parentViewController.view removeFromSuperview];
                      [self.parentViewController didMoveToParentViewController:nil];
                  }
                  _complitationBlock ();
              }];
          }];
}

- (void)showMe{
    [UIView animateWithDuration:0.3 animations:^{
        _visualEffectView.alpha = 1;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:kDamping initialSpringVelocity:kInitialSpringVelocity options:0x00 animations:^{
            self.contentView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (IBAction)closeBtnTapped:(id)sender {
    [self hideMe];
}
@end
