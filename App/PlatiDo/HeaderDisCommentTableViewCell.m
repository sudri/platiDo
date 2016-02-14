//
//  HeaderDisCommentTableViewCell.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 07.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "HeaderDisCommentTableViewCell.h"
#import "PhotoCell.h"
#import "UIImageView+AFNetworking.h"


@interface HeaderDisCommentTableViewCell() <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *shadow;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) CAGradientLayer *gradient;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UIButton *loadBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loadBtnHightConstrait;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHConstrait;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewAcpectConstrait;
@end

@implementation HeaderDisCommentTableViewCell
- (void)setImages:(NSArray*)images{
    _images = images;
    
    if (_images.count==0){
        self.collectionViewHConstrait.priority = UILayoutPriorityDefaultHigh;
        self.collectionViewAcpectConstrait.priority = UILayoutPriorityDefaultLow;
    } else {
        self.collectionViewHConstrait.priority      = UILayoutPriorityDefaultLow;
        self.collectionViewAcpectConstrait.priority = UILayoutPriorityDefaultHigh;
    }
    [self.collectionView reloadData];
}


- (void)hideLoadComponents:(BOOL)isHide{
    [self.loadBtn setHidden:isHide];
    [self.activity setHidden:isHide];
    if (isHide){
        self.loadBtnHightConstrait.constant = 0;
    } else {
        self.loadBtnHightConstrait.constant = 32;
    }
}

- (void)startActivity{
    [self.loadBtn setHidden:YES];
    [self.activity startAnimating];
}


- (void)stopActivity{
    [self.loadBtn setHidden:NO];
    [self.activity stopAnimating];
}

- (IBAction)loadMOrePressed:(id)sender {
    [self startActivity];
    if ([self.delegate respondsToSelector:@selector(didTapLoadMoreOnCell:)]){
        [self.delegate didTapLoadMoreOnCell:self];
    }
}

- (void)awakeFromNib {
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.shadow setBackgroundColor:[UIColor clearColor]];
    self.gradient= [CAGradientLayer layer];
    _gradient.frame = self.shadow.bounds;
    _gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    [self.shadow.layer insertSublayer:_gradient atIndex:0];
    self.shadow.alpha = 0.5;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.collectionView reloadData];
    self.gradient.frame = self.shadow.bounds;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    NSString *imageAdress =  _images[indexPath.row];
    
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    [cell.photoView setImage:[UIImage imageNamed:@"childHill"]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageAdress]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    UIImage *cachedImage = [[[cell.photoView class]  sharedImageCache] cachedImageForRequest:request];
    if (cachedImage) {
        cell.photoView.image = cachedImage;
        return cell;
    }
    
    
    
    [cell.photoView setImageWithURLRequest:request
                          placeholderImage:[UIImage imageNamed:@"placeholder"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                              
                              [UIView transitionWithView: cell.photoView
                                                duration:1.0f
                                                 options:UIViewAnimationOptionTransitionCrossDissolve
                                              animations:^{
                                                  cell.photoView.image = image;
                                              } completion:nil];
                              
                          } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                              
                          }];
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return collectionView.bounds.size;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

@end
