//
//  DisscutionTableViewCell.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 09.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscussionEntity.h"

@interface DisscutionTableViewCell : UITableViewCell

@property (nonatomic, strong) DiscussionEntity *discussion;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aspect;

@end
