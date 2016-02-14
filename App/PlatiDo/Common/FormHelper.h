//
//  FromHelper.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 21.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol FormHelperProtocol <NSObject>

@optional
- (void)scrollDidUp;
- (void)scrollDidDown;
- (UIView*)viewPreferToVisible;

@end


@interface FormHelper : NSObject
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView  *scrollContentView;
@property (nonatomic, weak) UIView  *formView;
@property (nonatomic, weak) UIView  *rootView;
@property (nonatomic, weak) id<FormHelperProtocol> delegate;

- (void)registerMe;
- (void)unregisterMe;
- (void)reset;
- (void)updateVisibleWithAnim:(BOOL)isAnim;
@end
