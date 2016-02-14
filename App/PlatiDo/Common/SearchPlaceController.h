//
//  SearchPlaceController.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 19.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchPlaceController : UIViewController
@property (copy, nonatomic) void (^complitationBlock)(NSString *street);
@end
