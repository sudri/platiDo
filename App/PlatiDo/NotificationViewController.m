//
//  NotificationViewController.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 27.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationTableViewCell.h"
#import "UIImage+ImageEffects.h"

#define EMPTY_CELL_HEIGHT 110.0

@interface NotificationViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>{

}

@property (nonatomic, weak) IBOutlet UITableView    * tableView;

@property (weak, nonatomic) IBOutlet UIImageView    * blurredImageView;
//@property (weak, nonatomic) IBOutlet UIImageView    * bluredBgImage;

@property (weak, nonatomic) IBOutlet UIView         * gradientView;

@property (weak, nonatomic) IBOutlet UIView         * bottomView;
@property (weak, nonatomic) IBOutlet UIButton       * closeButton;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tableview settings
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.bottomView.frame), 0.0f);
    self.tableView.estimatedRowHeight = EMPTY_CELL_HEIGHT;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (UIImage *)takeSnapshotOfView:(UIView *)view
//{
//    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width, view.frame.size.height));
//    [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) afterScreenUpdates:YES];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return image;
//}
//- (UIImage *)getSnapshotView:(UIView*)view rect:(CGRect)rect{
//    UIGraphicsBeginImageContextWithOptions(rect.size, NO, view.window.screen.scale);
//    [view drawViewHierarchyInRect:rect afterScreenUpdates:NO];
//    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    
//    return snapshotImage;
//}
//- (UIImage *)blurWithImageEffects:(UIImage *)image
//{
//    return [image applyBlurWithRadius:30 tintColor:[UIColor colorWithWhite:1 alpha:0.2] saturationDeltaFactor:1.5 maskImage:nil];
//}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
////    self.bluredBgImage.frame = CGRectMake(self.bottomView.frame.origin.x,
////                              self.view.frame.size.height - 50 - scrollView.contentOffset.y,
////                              self.bottomView.frame.size.width,
////                              self.bottomView.frame.size.height + scrollView.contentOffset.y);
//    
//    UIImage *snapshot = [self getSnapshotView:self.view rect:CGRectMake(self.view.frame.origin.x,
//                                                                        self.view.frame.size.height - 50,
//                                                                        self.view.frame.size.width,
//                                                                        50)];
//    self.bluredBgImage.layer = [self blurWithImageEffects:snapshot];
//}


#pragma mark - User Actions


- (IBAction)closeTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self.view removeFromSuperview];
    }];
}

#pragma mark - Setters

- (void)setBlurredImage:(UIImage *)blurredImage
{
    _blurredImage = blurredImage;
    self.blurredImageView.image = _blurredImage;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationTableViewCell"];
    if (indexPath.row == 2 || indexPath.row == 4) {
        [cell.descriprionTextView setText:@"очень много текста какой текст очень много текста какой текст очень много текста какой текст очень много текста какой текст очень много текста какой текст очень много текста какой текст очень много текста какой текст очень много текста какой текст очень много текста какой текст очень много текста какой текст очень много текста какой текст"];
    }
    return cell;
}

@end
