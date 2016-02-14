//
//  VoteItemsContainer.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 01.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteItemsContainer : UIView
- (void)addItem:(UIView*)view;
- (void)clear;
@property (nonatomic, assign) BOOL isNumerate;

@property (nonatomic, assign) NSInteger offsetItems;
@property (nonatomic, strong) NSMutableArray *items;
@end
