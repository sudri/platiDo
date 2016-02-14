//
//  RateView.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 07.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RateView : UIView

@property (assign) NSUInteger currentRating;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *stars;

@end
