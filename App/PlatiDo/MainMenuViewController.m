//
//  RearViewController.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 13.07.15.
//  Copyright (c) 2015 Valera Voroshilov. All rights reserved.
//

#import "MainMenuViewController.h"
#import "MyRevealSegue.h"
#import "UIColor+Additions.h"

@interface MainMenuViewController()

@end


@implementation MainMenuViewController
{
    UIImageView *_tableHeaderView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bluredMenuBg"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    
    _tableHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    _tableHeaderView.contentMode = UIViewContentModeCenter;
    [_tableHeaderView setFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 105)];
    self.tableView.tableHeaderView = _tableHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"work");
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithHex:0x0F2C86 alpha:0.2];
    [cell setSelectedBackgroundView:bgColorView];
}

@end
