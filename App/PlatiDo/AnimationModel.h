//
//  AnimationModel.h
//  ThousandBooks
//
//  Created by Fedor Semenchenko on 20.11.14.
//  Copyright (c) 2014 Fedor Semenchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AnimationModel : NSObject

- (instancetype)initWithViewsArray:(NSArray *)viewsArray;

- (void) shakeTF;

@end
