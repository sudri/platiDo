//
//  NotificationTableViewCell.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 27.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriprionTextView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
