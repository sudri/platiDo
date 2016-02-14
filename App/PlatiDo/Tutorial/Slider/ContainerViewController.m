//
//  ContainerViewController.m
//  Container Transitions
//
//  Created by Joachim Bondo on 30/04/2014.
//
//  Interactive transition support added by Alek Åström on 11/05/2014.
//

#import "ContainerViewController.h"
#import "PanGestureInteractiveTransition.h"
#import "PrivateAnimatedTransition.h"
#import "PrivateTransitionContext.h"


#pragma mark -

@interface ContainerViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *clouds;
@property (weak, nonatomic) IBOutlet UIView *privateContainerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewBackground;
@property (weak, nonatomic) IBOutlet UIImageView *cityLight;
@property (weak, nonatomic) IBOutlet UIImageView *cityMiddleLight;
@property (weak, nonatomic) IBOutlet UIImageView *cityShadow;
@property (weak, nonatomic) IBOutlet UIImageView *cityMiddleShadow;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) PanGestureInteractiveTransition *defaultInteractionController;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, weak) id<ContainerViewControllerDelegate>delegate;
@property (nonatomic, weak) UIGestureRecognizer *interactiveTransitionGestureRecognizer;
@property (nonatomic, weak) UIViewController *selectedViewController;

@end

@implementation ContainerViewController

- (NSArray*)loadChildControllers{
    
    UIStoryboard *sb      = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
    UIViewController *vc1 = [sb instantiateViewControllerWithIdentifier:@"TutorialPage1"];
    UIViewController *vc2 = [sb instantiateViewControllerWithIdentifier:@"TutorialPage2"];
    UIViewController *vc3 = [sb instantiateViewControllerWithIdentifier:@"Reg_Page1"];
    UIViewController *vc4 = [sb instantiateViewControllerWithIdentifier:@"Reg_Page2"];
    
    return @[vc1,vc2,vc3,vc4];
}

- (void)viewDidLoad {
	[super viewDidLoad];
     self.canShowNext = YES;
     self.canShowPrev = YES;
    self.viewControllers = [self loadChildControllers];
    [self animClouds];
    [self addParalax];
    
    __weak typeof(self) wself = self;
    self.defaultInteractionController = [[PanGestureInteractiveTransition alloc] initWithGestureRecognizerInView:self.privateContainerView recognizedBlock:^(UIPanGestureRecognizer *recognizer) {
        BOOL leftToRight = [recognizer velocityInView:recognizer.view].x > 0;
        
        NSUInteger currentVCIndex = [self.viewControllers indexOfObject:self.selectedViewController];
        if (!leftToRight && currentVCIndex != self.viewControllers.count-1) {
            if (self.canShowNext){
                [wself setSelectedViewController:self.viewControllers[currentVCIndex+1]];
            }
        } else if (leftToRight && currentVCIndex > 0) {
            if (self.canShowPrev){
                [wself setSelectedViewController:self.viewControllers[currentVCIndex-1]];
            }
        }
    }];
	self.selectedViewController = (self.selectedViewController ?: self.viewControllers[0]);
}

- (void)animClouds{
      [UIView animateWithDuration:50 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
           self.clouds.transform = CGAffineTransformMakeTranslation (- self.clouds.frame.size.width, 0);
      } completion:^(BOOL finished) {
           self.clouds.transform = CGAffineTransformMakeTranslation ( self.clouds.frame.size.width, 0);
          [self animClouds];
      }];
}

- (void)addParalax{
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-15);
    verticalMotionEffect.maximumRelativeValue = @(15);
    [self.clouds addMotionEffect:verticalMotionEffect];
    
    ////////////////////////////////////
    
    UIInterpolatingMotionEffect *verticalMotionEffect2 =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect2.minimumRelativeValue = @(35);
    verticalMotionEffect2.maximumRelativeValue = @(-35);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect2 =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect2.minimumRelativeValue = @(40);
    horizontalMotionEffect2.maximumRelativeValue = @(-40);
    // Create group to combine both
    UIMotionEffectGroup *group2 = [UIMotionEffectGroup new];
    group2.motionEffects = @[horizontalMotionEffect2, verticalMotionEffect2];
    
    [self.cityMiddleLight addMotionEffect:group2];
    /////////////////////////////
    
    UIInterpolatingMotionEffect *verticalMotionEffect3 =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect3.minimumRelativeValue = @(20);
    verticalMotionEffect3.maximumRelativeValue = @(-20);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect3 =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect3.minimumRelativeValue = @(20);
    horizontalMotionEffect3.maximumRelativeValue = @(-20);
    // Create group to combine both
    UIMotionEffectGroup *group3 = [UIMotionEffectGroup new];
    group3.motionEffects = @[horizontalMotionEffect3, verticalMotionEffect3];
    
    [self.cityLight addMotionEffect:group3];

    /////////////////////////////
    
    UIInterpolatingMotionEffect *verticalMotionEffect4 =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect4.minimumRelativeValue = @(-15);
    verticalMotionEffect4.maximumRelativeValue = @(15);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect4 =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect4.minimumRelativeValue = @(-15);
    horizontalMotionEffect4.maximumRelativeValue = @(15);
    // Create group to combine both
    UIMotionEffectGroup *group4 = [UIMotionEffectGroup new];
    group4.motionEffects = @[horizontalMotionEffect4, verticalMotionEffect4];
    
    [self.cityMiddleShadow addMotionEffect:group4];
    
    //////////////////////
    UIInterpolatingMotionEffect *verticalMotionEffect5 =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect5.minimumRelativeValue = @(-5);
    verticalMotionEffect5.maximumRelativeValue = @(5);
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect5 =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect5.minimumRelativeValue = @(-10);
    horizontalMotionEffect5.maximumRelativeValue = @(10);
    // Create group to combine both
    UIMotionEffectGroup *group5 = [UIMotionEffectGroup new];
    group5.motionEffects = @[horizontalMotionEffect5, verticalMotionEffect5];
    [self.cityShadow addMotionEffect:group5];
    //////////////////////
}




- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
	return self.selectedViewController;
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
	NSParameterAssert (selectedViewController);
	[self transitionToChildViewController:selectedViewController];
}

- (UIGestureRecognizer *)interactiveTransitionGestureRecognizer {
    return self.defaultInteractionController.recognizer;
}

- (void)lockInteraction:(BOOL)isLock{
    if (isLock) {
        [self.privateContainerView removeGestureRecognizer: self.defaultInteractionController.recognizer];
    } else  {
        if (self.defaultInteractionController.recognizer.view == nil) {
            [self.privateContainerView addGestureRecognizer:self.defaultInteractionController.recognizer];
        }
    }
}

- (void)showNextController{
    NSUInteger currentVCIndex = [self.viewControllers indexOfObject:self.selectedViewController];
    if (currentVCIndex+1 < self.viewControllers.count) {
        [self setSelectedViewController:self.viewControllers[currentVCIndex+1]];
    }
}

- (void)showPrevController{
    NSUInteger currentVCIndex = [self.viewControllers indexOfObject:self.selectedViewController];
    if (currentVCIndex-1 < self.viewControllers.count) {
        [self setSelectedViewController:self.viewControllers[currentVCIndex-1]];
    }
}

#pragma mark Private Methods

- (void)transitionToChildViewController:(UIViewController *)toViewController {
	UIViewController *fromViewController = self.selectedViewController;
	if (toViewController == fromViewController || ![self isViewLoaded]) {
		return;
	}
	
	UIView *toView = toViewController.view;
	[toView setTranslatesAutoresizingMaskIntoConstraints:YES];
	toView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	toView.frame = self.privateContainerView.bounds;
	
	[fromViewController willMoveToParentViewController:nil];
	[self addChildViewController:toViewController];
	

	if (!fromViewController) {
		[self.privateContainerView addSubview:toViewController.view];
		[toViewController didMoveToParentViewController:self];
        [self _finishTransitionToChildViewController:toViewController];
		return;
	}

    NSUInteger fromIndex = [self.viewControllers indexOfObject:fromViewController];
    NSUInteger toIndex   = [self.viewControllers indexOfObject:toViewController];
    

    
	id<UIViewControllerAnimatedTransitioning>animator = nil;
	if ([self.delegate respondsToSelector:@selector (containerViewController:animationControllerForTransitionFromViewController:toViewController:)]) {
		animator = [self.delegate containerViewController:self animationControllerForTransitionFromViewController:fromViewController toViewController:toViewController];
	}
    BOOL animatorIsDefault = (animator == nil);
    PrivateAnimatedTransition *animatorDefinite = [PrivateAnimatedTransition new];
  
	animator = animatorDefinite;


	PrivateTransitionContext *transitionContext = [[PrivateTransitionContext alloc] initWithFromViewController:fromViewController toViewController:toViewController goingRight:toIndex > fromIndex];
    transitionContext.parentContainerScroll = self.scrollViewBackground;
    transitionContext.numberSelected = toIndex;
	transitionContext.animated = YES;
    
    id<UIViewControllerInteractiveTransitioning> interactionController = [self _interactionControllerForAnimator:animator animatorIsDefault:animatorIsDefault];
    
	transitionContext.interactive = (interactionController != nil);
	transitionContext.completionBlock = ^(BOOL didComplete) {
        if (didComplete) {
            [fromViewController.view removeFromSuperview];
            [fromViewController removeFromParentViewController];
            [toViewController didMoveToParentViewController:self];
            [self _finishTransitionToChildViewController:toViewController];
            [self.pageControl setCurrentPage:toIndex];
            
        
            switch (toIndex) {
                case 2:
                    self.canShowNext = NO;
                    self.canShowPrev = YES;
                    break;
                    
                case 3:
                    self.canShowNext = YES;
                    self.canShowPrev = NO;
                    break;
                    
                default:
                    self.canShowNext = YES;
                    self.canShowPrev = YES;
                    break;
            }
            
            if (toIndex==2){
                self.canShowNext = NO;
            } else {
                self.canShowNext = YES;
            }
    
        } else {
            [toViewController.view removeFromSuperview];
        }
        
        if ([animator respondsToSelector:@selector (animationEnded:)]) {
            [animator animationEnded:didComplete];
        }
	};

    if ([transitionContext isInteractive]) {
        [interactionController startInteractiveTransition:transitionContext];
    } else {
        [animator animateTransition:transitionContext];
        [self _finishTransitionToChildViewController:toViewController];
    }
}

- (void)_finishTransitionToChildViewController:(UIViewController *)toViewController {
    _selectedViewController = toViewController;
}

- (id<UIViewControllerInteractiveTransitioning>)_interactionControllerForAnimator:(id<UIViewControllerAnimatedTransitioning>)animationController animatorIsDefault:(BOOL)animatorIsDefault {
    
    if (self.defaultInteractionController.recognizer.state == UIGestureRecognizerStateBegan) {
        self.defaultInteractionController.animator = animationController;
        return self.defaultInteractionController;
    } else if (!animatorIsDefault && [self.delegate respondsToSelector:@selector(containerViewController:interactionControllerForAnimationController:)]) {
        return [self.delegate containerViewController:self interactionControllerForAnimationController:animationController];
    } else {
        return nil;
    }
}
@end



