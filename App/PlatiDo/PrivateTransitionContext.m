//
//  PrivateTransitionContext.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 12.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "PrivateTransitionContext.h"
#define  offsetScroll 120

#pragma mark - Private Transitioning Classes

@interface PrivateTransitionContext ()
@property (nonatomic, strong) NSDictionary *privateViewControllers;
@property (nonatomic, weak)   UIView *containerView;
@property (nonatomic, assign) CGRect privateDisappearingFromRect;
@property (nonatomic, assign) CGRect privateAppearingFromRect;
@property (nonatomic, assign) CGRect privateDisappearingToRect;
@property (nonatomic, assign) CGRect privateAppearingToRect;

@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;
@property (nonatomic, assign) BOOL transitionWasCancelled;
@property (nonatomic, assign) BOOL goingRight;
@end

@implementation PrivateTransitionContext

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingRight:(BOOL)goingRight {
    NSAssert ([fromViewController isViewLoaded] && fromViewController.view.superview, @"The fromViewController view must reside in the container view upon initializing the transition context.");
    
    if ((self = [super init])) {
        
        self.presentationStyle = UIModalPresentationCustom;
        self.containerView = fromViewController.view.superview;
        _transitionWasCancelled = NO;
        self.goingRight = goingRight;
        self.privateViewControllers = @{
                                        UITransitionContextFromViewControllerKey:fromViewController,
                                        UITransitionContextToViewControllerKey:toViewController,
                                        };
        
        CGFloat travelDistance = (goingRight ? -self.containerView.bounds.size.width : self.containerView.bounds.size.width);
        self.privateDisappearingFromRect = self.privateAppearingToRect = self.containerView.bounds;
        self.privateDisappearingToRect = CGRectOffset (self.containerView.bounds, travelDistance, 0);
        self.privateAppearingFromRect = CGRectOffset (self.containerView.bounds, -travelDistance, 0);
    }
    
    return self;
}

- (CGRect)initialFrameForViewController:(UIViewController *)viewController {
    if (viewController == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.privateDisappearingFromRect;
    } else {
        return self.privateAppearingFromRect;
    }
}

- (CGRect)finalFrameForViewController:(UIViewController *)viewController {
    if (viewController == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.privateDisappearingToRect;
    } else {
        return self.privateAppearingToRect;
    }
}

- (UIViewController *)viewControllerForKey:(NSString *)key {
    return self.privateViewControllers[key];
}

- (void)completeTransition:(BOOL)didComplete {
    if (self.completionBlock) {
        self.completionBlock (didComplete);
    }
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
   percentComplete = percentComplete/0.5;

    CGFloat startingPoint;
    NSInteger directionKoefi;
    if (self.goingRight){
        startingPoint = offsetScroll*(self.numberSelected-1);
        directionKoefi = 1;
    } else {
        startingPoint = offsetScroll*(self.numberSelected+1);
        directionKoefi = -1;
    }
  
    [self.parentContainerScroll setContentOffset:(CGPoint){startingPoint+directionKoefi*percentComplete*offsetScroll, self.parentContainerScroll.contentOffset.y}];
}


///velocity of pan is speed of animation
- (void)finishInteractiveTransition {
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
          [self.parentContainerScroll setContentOffset:(CGPoint){offsetScroll*self.numberSelected, self.parentContainerScroll.contentOffset.y}];
    } completion:nil];
    self.transitionWasCancelled = NO;
}
- (void)cancelInteractiveTransition {
    self.transitionWasCancelled = YES;
    NSInteger idx = self.goingRight?self.numberSelected-1:self.numberSelected+1;
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
         [self.parentContainerScroll setContentOffset:(CGPoint){offsetScroll*(idx), self.parentContainerScroll.contentOffset.y}];
    } completion:nil];
}

@end
