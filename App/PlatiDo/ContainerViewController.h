//
//  ContainerViewController.h
//  Container Transitions
//
//  Created by Joachim Bondo on 30/04/2014.
//
//  Interactive transition support added by Alek Åström on 11/05/2014.
//

@import UIKit;
@import Foundation;

@protocol ContainerViewControllerDelegate;

/** A very simple container view controller for demonstrating containment in an environment different from UINavigationController and UITabBarController.
 @discussion This class implements support for non-interactive custom view controller transitions.
 @note One of the many current limitations, besides not supporting interactive transitions, is that you cannot change view controllers after the object has been initialized.
 */
@interface ContainerViewController : UIViewController
- (instancetype)initWithViewControllers:(NSArray *)viewControllers;
- (void)showNextController;
- (void)showPrevController;

@property (nonatomic, assign) BOOL canShowNext;
@property (nonatomic, assign) BOOL canShowPrev;
@end

@protocol ContainerViewControllerDelegate <NSObject>
@optional

- (void)containerViewController:(ContainerViewController *)containerViewController didSelectViewController:(UIViewController *)viewController;

- (id <UIViewControllerAnimatedTransitioning>)containerViewController:(ContainerViewController *)containerViewController animationControllerForTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

- (id <UIViewControllerInteractiveTransitioning>)containerViewController:(ContainerViewController *)containerViewController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController;
@end
