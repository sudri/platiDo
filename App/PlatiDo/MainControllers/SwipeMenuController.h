//
//  SNBSwipeMenuController.h
//  SwipeMenu
//
//  Created by Nikita Solovtsov on 05.09.13.
//  Copyright (c) 2013 Nikita Solovtsov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SPLIT_TYPE_NONE,
    SPLIT_TYPE_LEFT,
    SPLIT_TYPE_RIGHT,
    SPLIT_TYPE_BOTH,
}SPLIT_TYPE;

typedef enum {
    SPLIT_STATE_CENTER,
    SPLIT_STATE_LEFT,
    SPLIT_STATE_RIGHT,
}SPLIT_STATE;

typedef enum {
    ANIMATION_STYLE_NONE = 0,
    ANIMATION_STYLE_FROM_LEFT,
    ANIMATION_STYLE_FROM_RIGHT,
    ANIMATION_STYLE_FROM_BOTTOM,
    ANIMATION_STYLE_FROM_TOP,
    ANIMATION_STYLE_FADE,
    
    ANIMATION_STYLE_COUNT,
}ANIMATION_STYLE;

#define SPLIT_MENU_OPEN_OR_CLOSE_LEFT_NOTIFICATION @"SplitMenuOpenLeftNotification"
#define SPLIT_MENU_OPEN_OR_CLOSE_RIGHT_NOTIFICATION @"SplitMenuOpenRightNotification"

@interface SwipeMenuController : UIViewController

//nil if no left or right menu
- (id)initWithLeftMasterController:(UIViewController *)leftController
              RightMsterController:(UIViewController *)rightController;

- (void)setDetailViewController:(UIViewController *)detailContorller;

// lock swipe. Notifications does not work too.
- (void)setSwipeLocked:(BOOL)locked;

//set masters width
- (void)setRightMasterWidth:(CGFloat)rightMasterWidth;
- (void)setLeftMasterWidth:(CGFloat)leftMasterWidth;

// add or remove views above detail (in order: masters, detail, resentedControllers, popupAlert, popupError)
- (void)addPopupAlert:(UIView *)popupAlert animated:(BOOL)animated animationStyle:(ANIMATION_STYLE)animationStyle;
- (void)removePopupAlert:(UIView *)popupAlert animated:(BOOL)animated animationStyle:(ANIMATION_STYLE)animationStyle;

- (void)addPopupError:(UIView *)popupAlert;

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated animationStyle:(ANIMATION_STYLE)animationStyle;
- (void)dismissViewControllerAnimated:(BOOL)animated animationStyle:(ANIMATION_STYLE)animationStyle;

@property (strong, readonly) UIViewController* leftMasterController;

@end
