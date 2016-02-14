//
//  ChartItem.h
//  ChartsTest
//
//  Created by Valera Voroshilov on 02.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartItem : UIView
@property (nonatomic, strong) UILabel *title;
- (void)setProcend:(NSInteger)procend;
@end
