//
//  HeaderDisCommentTableViewCell.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 07.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeaderDisCommentTableViewCell;

@protocol HeaderDisCommentTableViewCellProtocol <NSObject>
-(void)didTapLoadMoreOnCell:(HeaderDisCommentTableViewCell*)cell;
@end

@interface HeaderDisCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) id <HeaderDisCommentTableViewCellProtocol> delegate;
@property (strong, nonatomic) NSArray *images;
- (void)startActivity;
- (void)stopActivity;
- (void)hideLoadComponents:(BOOL)isHide;
@end
