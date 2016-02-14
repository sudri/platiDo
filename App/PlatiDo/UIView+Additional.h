//
//  UIView+Additional.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 22.07.15.
//  Copyright (c) 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additional)
- (UIView *)findViewThatIsFirstResponder;
- (void)shakeAnimation;
- (void)drawShadow;
@end
