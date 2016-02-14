//
//  PrivateAnimatedTransition.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 21.07.15.
//  Copyright (c) 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

/// Instances of this private class perform the default transition animation which is to slide child views horizontally.
@interface PrivateAnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) UIScrollView *parentContainerScroll;
@property (nonatomic, assign) NSInteger numberSelected;
@end

