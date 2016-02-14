//
//  DashBoardTableViewCell.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 27.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DashboardItem;


@interface DashBoardTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;

@property (strong, nonatomic) DashboardItem* item;
@end
