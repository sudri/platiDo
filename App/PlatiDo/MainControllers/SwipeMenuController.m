//
//  SNBSwipeMenuController.m
//  SwipeMenu
//
//  Created by Nikita Solovtsov on 05.09.13.
//  Copyright (c) 2013 Nikita Solovtsov. All rights reserved.
//

#import "SwipeMenuController.h"

#define SHIFT_FOR_DETAIL_DEFAULT 130
#define SLIDE_FACTOR 1.5

typedef enum {
    SPLIT_DIRECTION_NONE,
    SPLIT_DIRECTION_LEFT,
    SPLIT_DIRECTION_RIGHT,
}SPLIT_DIRECTION;

@interface SwipeMenuController ()

@end

@implementation SwipeMenuController
{
    UIViewController *_leftMasterController;
    UIViewController *_rightMasterController;
    UIViewController *_detailController;
    
    UIPanGestureRecognizer *_panGesture;
    
    BOOL _swipingEnabled;
    SPLIT_TYPE _splitType;
    SPLIT_STATE _splitState;
    
    CGFloat _minDetailPositionX;
    CGFloat _maxDetailPositionX;
    
    CGFloat _leftMasterWidth;
    CGFloat _rightMasterWidth;
    
    UIView *_viewForPopupErrors;
    UIView *_viewForPopupAlerts;
    NSMutableArray *_popupAlertsArray;
    
    UIView *_viewForPresentControllers;
    NSMutableArray *_presentControllersArray;
    UIBarButtonItem *_leftDetailBarButton;
}

- (id)initWithLeftMasterController:(UIViewController *)leftController
              RightMsterController:(UIViewController *)rightController {
    self = [super init];
    if (self) {
        _leftMasterController = leftController;
        _rightMasterController = rightController;
        _splitState = SPLIT_STATE_CENTER;
        _swipingEnabled = YES;
        _popupAlertsArray = [[NSMutableArray alloc] init];
        _presentControllersArray = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void)dealloc {
    [self unsubscribeForNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setType];
    [self setMinAndMax];
    [self setDefaultMastersWidth];
    [self subscribeForNotifications];
	[self addingMasters];
    [self addingViewForPresentControllers];
    [self addingViewForPopupAlerts];
    [self addingViewForPopupError];
    [self addingPanGesture];
    [self createNavButtons];
}

-(void)createNavButtons{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"menu_button"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn sizeToFit];
 
    _leftDetailBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [backBtn addTarget:self action:@selector(switchLeftMasterViewCotroller) forControlEvents:UIControlEventTouchUpInside];
    

 
}

- (void)setType {
    _splitType = (_leftMasterController ?
                  (_rightMasterController ?
                   SPLIT_TYPE_BOTH :
                   SPLIT_TYPE_LEFT) :
                  (_rightMasterController ?
                   SPLIT_TYPE_RIGHT :
                   SPLIT_TYPE_NONE));
}

- (void)setMinAndMax {
    CGFloat screenWidth = self.view.frame.size.width;
    
    switch (_splitType) {
        default:
        case SPLIT_TYPE_NONE:
            _minDetailPositionX = 0;
            _maxDetailPositionX = 0;
            break;
        case SPLIT_TYPE_LEFT:
            _minDetailPositionX = 0;
            _maxDetailPositionX = screenWidth;
            break;
        case SPLIT_TYPE_RIGHT:
            _minDetailPositionX = -screenWidth;
            _maxDetailPositionX = 0;
            break;
        case SPLIT_TYPE_BOTH:
            _minDetailPositionX = -screenWidth;
            _maxDetailPositionX = screenWidth;
            break;
    }
}

- (void)setDefaultMastersWidth {
    _rightMasterWidth = -_minDetailPositionX - SHIFT_FOR_DETAIL_DEFAULT;
    _leftMasterWidth = _maxDetailPositionX - SHIFT_FOR_DETAIL_DEFAULT;
}


- (UIViewController*)leftMasterController{
    return _leftMasterController;
}

- (void)addingMasters {
    if (_leftMasterController) {
        [self addChildViewController:_leftMasterController];
        [self.view addSubview:_leftMasterController.view];
        [self setLeftMasterWidth:_leftMasterWidth];
    }

    if (_rightMasterController) {
        [self addChildViewController:_rightMasterController];
        [self.view addSubview:_rightMasterController.view];
        [self setRightMasterWidth:_rightMasterWidth];
    }
}



- (void)setLeftMasterWidth:(CGFloat)leftMasterWidth {
    _leftMasterController.view.frame = CGRectMake(0.0,
                                                  0.0,
                                                  leftMasterWidth,
                                                  self.view.frame.size.height);
    _leftMasterWidth = leftMasterWidth;
    if (_splitState == SPLIT_STATE_RIGHT) {
        [self changeStateTo:_splitState];
    }
}

- (void)setRightMasterWidth:(CGFloat)rightMasterWidth {
    _rightMasterController.view.frame = CGRectMake(self.view.frame.size.width - rightMasterWidth,
                                                  0.0,
                                                  rightMasterWidth,
                                                  self.view.frame.size.height);
    _rightMasterWidth = rightMasterWidth;
    if (_splitState == SPLIT_STATE_LEFT) {
        [self changeStateTo:_splitState];
    }
}

- (void)setDetailViewController:(UIViewController *)detailContorller {
    [self addChildViewController:detailContorller];
    [self.view insertSubview:detailContorller.view belowSubview:_viewForPresentControllers];
    detailContorller.view.frame = CGRectMake((_detailController ? _detailController.view.frame.origin.x : 0.0),
                                             0.0,
                                             self.view.frame.size.width,
                                             self.view.frame.size.height);
    
    if (_panGesture) {
        if ([detailContorller isKindOfClass:[UINavigationController class]]){
            
            UIViewController *vc = [(UINavigationController *)detailContorller topViewController];
            [vc.view addGestureRecognizer:_panGesture];
        }else{
            [detailContorller.view addGestureRecognizer:_panGesture];
        }

    }
  
    if (_detailController) {
        [_detailController.view removeFromSuperview];
        [_detailController removeFromParentViewController];
    }
    _detailController = detailContorller;
    
    if ([detailContorller isKindOfClass:[UINavigationController class]]){
        UINavigationController *nv = (UINavigationController*)detailContorller;
        [nv topViewController].navigationItem.leftBarButtonItem = _leftDetailBarButton;
    }
    
    [self changeStateTo:SPLIT_STATE_CENTER];
}

- (void)switchLeftMasterViewCotroller{
    if (_splitState==SPLIT_STATE_CENTER){
        [self changeStateTo:SPLIT_STATE_RIGHT];
    }else{
        [self changeStateTo:SPLIT_STATE_CENTER];
    }
}

#pragma mark - popup errors

- (void)addingViewForPopupError {
    _viewForPopupErrors = [[UIView alloc] initWithFrame:(CGRect){.size = self.view.frame.size}];
    _viewForPopupErrors.userInteractionEnabled = NO;
    [self.view addSubview:_viewForPopupErrors];
}

- (void)addPopupError:(UIView *)popup {
    [_viewForPopupErrors addSubview:popup];
}

#pragma mark - popup alerts

- (void)addingViewForPopupAlerts {
    _viewForPopupAlerts = [[UIView alloc] initWithFrame:(CGRect){.size = self.view.frame.size}];
    _viewForPopupAlerts.userInteractionEnabled = NO;
    [self.view addSubview:_viewForPopupAlerts];
}

- (void)addPopupAlert:(UIView *)popupAlert animated:(BOOL)animated animationStyle:(ANIMATION_STYLE)animationStyle {
    [_viewForPopupAlerts addSubview:popupAlert];
    
    if (animated) {
        [self animateView:popupAlert
       withAnimationStyle:animationStyle
                    apear:YES
               completion:nil];
    }
    
    // enabling interaction
    [_viewForPopupErrors setUserInteractionEnabled:YES];
    [_popupAlertsArray addObject:popupAlert];
}

- (void)removePopupAlert:(UIView *)popupAlert animated:(BOOL)animated animationStyle:(ANIMATION_STYLE)animationStyle {
    if (animated) {
        typeof (self) __weak __self = self;
        [self animateView:popupAlert
       withAnimationStyle:animationStyle
                    apear:NO
               completion:^{
            [__self removePopupAlert:popupAlert];
        }];
        return;
    }
    [self removePopupAlert:popupAlert];
}

- (void)removePopupAlert:(UIView *)popupAlert {
    [popupAlert removeFromSuperview];
    [_popupAlertsArray removeObject:popupAlert];
    // disable interaction if need
    [_viewForPopupErrors setUserInteractionEnabled:[_popupAlertsArray count] > 0];
}

#pragma mark - ppresent controllers

- (void)addingViewForPresentControllers {
    _viewForPresentControllers = [[UIView alloc] initWithFrame:(CGRect){.size = self.view.frame.size}];
    _viewForPresentControllers.userInteractionEnabled = NO;
    [self.view addSubview:_viewForPresentControllers];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated animationStyle:(ANIMATION_STYLE)animationStyle {
    [_viewForPresentControllers addSubview:viewControllerToPresent.view];
    [self addChildViewController:viewControllerToPresent];
    
    if (animated) {
        [self    animateView:viewControllerToPresent.view
          withAnimationStyle:animationStyle
                       apear:YES
                  completion:nil];
    }
    
    // enabling interaction
    [_viewForPresentControllers setUserInteractionEnabled:YES];
    [_presentControllersArray addObject:viewControllerToPresent];
}

- (void)dismissViewControllerAnimated:(BOOL)animated animationStyle:(ANIMATION_STYLE)animationStyle {
    if ([_presentControllersArray count] == 0) return;
    UIViewController *viewController = [_presentControllersArray objectAtIndex:[_presentControllersArray count] - 1];

    if (animated) {
        typeof(self) __weak __self = self;
        [self animateView:viewController.view
       withAnimationStyle:animationStyle
                    apear:NO
               completion:^{
            [__self dismissViewController:viewController];
        }];
        return;
    }
    [self dismissViewController:viewController];
}

- (void)dismissViewController:(UIViewController *)viewController {
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
    [_presentControllersArray removeObject:viewController];
    // disable interaction if need
    [_viewForPresentControllers setUserInteractionEnabled:[_presentControllersArray count] > 0];
    
}

#pragma mark - show/hide animation

- (void)animateView:(UIView *)view withAnimationStyle:(ANIMATION_STYLE)animationStyle apear:(BOOL)apear completion:(void (^)(void))completion {
    //TODO:fade
    
    CGRect outOfBoundsFrame;
    switch (animationStyle) {
        case ANIMATION_STYLE_FROM_RIGHT:
            outOfBoundsFrame = (CGRect){.size = view.frame.size,
                .origin = CGPointMake(view.frame.origin.x + self.view.frame.size.width,
                                      view.frame.origin.y)};
            break;
        case ANIMATION_STYLE_FROM_LEFT:
            outOfBoundsFrame = (CGRect){.size = view.frame.size,
                .origin = CGPointMake(view.frame.origin.x - self.view.frame.size.width,
                                      view.frame.origin.y)};
            break;
        case ANIMATION_STYLE_FROM_BOTTOM:
            outOfBoundsFrame = (CGRect){.size = view.frame.size,
                .origin = CGPointMake(view.frame.origin.x,
                                      view.frame.origin.y + self.view.frame.size.height)};
            break;
        case ANIMATION_STYLE_FROM_TOP:
            outOfBoundsFrame = (CGRect){.size = view.frame.size,
                .origin = CGPointMake(view.frame.origin.x,
                                      view.frame.origin.y - self.view.frame.size.height)};
            break;
        default:
            outOfBoundsFrame = view.frame;
            break;
    }
    
    CGRect startFrame = (apear ? outOfBoundsFrame : view.frame);
    CGRect endFrame = (apear ? view.frame : outOfBoundsFrame);
    if (animationStyle == ANIMATION_STYLE_FADE) {
            view.alpha = (apear ? 0.0 : 1.0);
        }
    [view setFrame:startFrame];
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [view setFrame:endFrame];
                         if (animationStyle == ANIMATION_STYLE_FADE) {
                             view.alpha = (apear ? 1.0 : 0.0);
                         }
                     } completion:^(BOOL finished) {
                         if (completion) completion();
                     }];
}

#pragma mark - pan recognizer

- (void)addingPanGesture {
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
    [_detailController.view addGestureRecognizer:_panGesture];
}

- (void)panGestureHandler:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:_detailController.view];
    CGFloat newPositionX = _detailController.view.frame.origin.x + translation.x;
    
    // show left or right menu on background
    if (_splitType == SPLIT_TYPE_BOTH) {
        if (newPositionX > 0 && ![_rightMasterController.view isHidden]) {
            _rightMasterController.view.hidden = YES;
            _leftMasterController.view.hidden = NO;
        }
        else
            if (newPositionX <= 0 && [_rightMasterController.view isHidden]) {
                _rightMasterController.view.hidden = NO;
                _leftMasterController.view.hidden = YES;
            }
    }
    
    // move detail view 
    CGFloat newCenterPositionX = _detailController.view.center.x;
    if (newPositionX <= _leftMasterWidth && newPositionX >= -_rightMasterWidth) {
        newCenterPositionX += translation.x;
    }
    else
    {
        //iOS feature for end of scroll
        if (newPositionX <= _maxDetailPositionX && newPositionX >= _minDetailPositionX) {
            newCenterPositionX += translation.x/2;
        } else {
            // in other variant we should set boundary point
            newCenterPositionX += (newPositionX > _maxDetailPositionX ? _maxDetailPositionX : _minDetailPositionX) - _detailController.view.frame.origin.x;
        }
    }
    _detailController.view.center = CGPointMake(newCenterPositionX, _detailController.view.center.y);
    
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
    
    // move detail view on end coordinates
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        // go to closest point
        CGPoint velocity = [sender velocityInView:_detailController.view];
        CGFloat magnitude = velocity.x;
        CGFloat slideFactor = magnitude / 400;
        
        SPLIT_STATE endState = [self getNewStateWithPositionX:newPositionX slideFactor:slideFactor];
        [self changeStateTo:endState];
    }
}

- (SPLIT_STATE)getNewStateWithPositionX:(CGFloat)newPositionX slideFactor:(CGFloat)slideFactor {
    //find direction
    SPLIT_DIRECTION direction = SPLIT_DIRECTION_NONE;
    if (ABS(slideFactor) > SLIDE_FACTOR) {
        direction = (slideFactor > 0 ? SPLIT_DIRECTION_RIGHT : SPLIT_DIRECTION_LEFT);
    } else {
        direction = SPLIT_DIRECTION_NONE;
    }
    
    // find end position of pan gest
    SPLIT_STATE endState = _splitState;
    if (newPositionX > 0) {
        switch (direction) {
            case SPLIT_DIRECTION_NONE:
            default:
                if ((_leftMasterWidth)/2  < newPositionX)
                    endState = SPLIT_STATE_RIGHT;
                else
                    endState = SPLIT_STATE_CENTER;
                break;
                
            case SPLIT_DIRECTION_LEFT:
                endState = SPLIT_STATE_CENTER;
                break;
                
            case SPLIT_DIRECTION_RIGHT:
                endState = SPLIT_STATE_RIGHT;
                break;
        }
    } else {
        switch (direction) {
            case SPLIT_DIRECTION_NONE:
            default:
                if ((-_rightMasterWidth)/2  > newPositionX)
                    endState = SPLIT_STATE_LEFT;
                else
                    endState = SPLIT_STATE_CENTER;
                break;
                
            case SPLIT_DIRECTION_LEFT:
                endState = SPLIT_STATE_LEFT;
                break;
                
            case SPLIT_DIRECTION_RIGHT:
                endState = SPLIT_STATE_CENTER;
                break;
        }
    }
    
    //listing only by one step
    if ((_splitState == SPLIT_STATE_LEFT && endState == SPLIT_STATE_RIGHT) ||
        (_splitState == SPLIT_STATE_RIGHT && endState == SPLIT_STATE_LEFT)) {
        endState = SPLIT_STATE_CENTER;
    }
    
    //lock unused states
    if ((endState == SPLIT_STATE_LEFT && _splitType == SPLIT_TYPE_LEFT) ||
        (endState == SPLIT_STATE_RIGHT && _splitType == SPLIT_TYPE_RIGHT) ||
        (_splitType == SPLIT_TYPE_NONE)) {
        endState = SPLIT_STATE_CENTER;
    }
    
    return endState;
}

- (void)changeStateTo:(SPLIT_STATE)newState {
    CGFloat center = roundf(_detailController.view.frame.size.width / 2);
    CGFloat newCenterPositionX;
    
    switch (newState) {
        default:
        case SPLIT_STATE_CENTER:
            newCenterPositionX = center;
            break;
        case SPLIT_STATE_RIGHT:
            newCenterPositionX = center + _leftMasterWidth;
            break;
        case SPLIT_STATE_LEFT:
            newCenterPositionX = center - _rightMasterWidth;
            break;
    }
    
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _detailController.view.center = CGPointMake(newCenterPositionX, _detailController.view.center.y);
                     }
                     completion:nil];
    _splitState = newState;
}

- (void)setSwipeLocked:(BOOL)locked {
    _swipingEnabled = _panGesture.enabled = !locked;
}

#pragma mark - notification handle


- (void)subscribeForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openOrCloseLeft)
                                                 name:SPLIT_MENU_OPEN_OR_CLOSE_LEFT_NOTIFICATION
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openOrCloseRight)
                                                 name:SPLIT_MENU_OPEN_OR_CLOSE_RIGHT_NOTIFICATION
                                               object:nil];
}

- (void)unsubscribeForNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SPLIT_MENU_OPEN_OR_CLOSE_LEFT_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SPLIT_MENU_OPEN_OR_CLOSE_RIGHT_NOTIFICATION object:nil];
}

- (void)openOrCloseLeft {
    if (!_swipingEnabled) return;
    [self changeStateTo:(_splitState == SPLIT_STATE_RIGHT ? SPLIT_STATE_CENTER : SPLIT_STATE_RIGHT)];
}

- (void)openOrCloseRight {
    if (!_swipingEnabled) return;
    [self changeStateTo:(_splitState == SPLIT_STATE_LEFT ? SPLIT_STATE_CENTER : SPLIT_STATE_LEFT)];
}

#pragma mark - receive mem warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
