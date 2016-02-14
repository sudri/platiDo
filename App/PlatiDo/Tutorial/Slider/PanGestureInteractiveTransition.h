//
//  PanGestureInteractiveTransition.h
//  Container Transitions
//
//  Created by Alek Astrom on 2014-05-11.
//
//

#import "AWPercentDrivenInteractiveTransition.h"
#import "PanGestureInteractiveTransition.h"


@interface PanGestureInteractiveTransition : AWPercentDrivenInteractiveTransition

- (id)initWithGestureRecognizerInView:(UIView *)view recognizedBlock:(void (^)(UIPanGestureRecognizer *recognizer))gestureRecognizedBlock;

@property (nonatomic, readonly) UIPanGestureRecognizer *recognizer;
@property (nonatomic, copy) void (^gestureRecognizedBlock)(UIPanGestureRecognizer *recognizer);

@end
