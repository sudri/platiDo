//
//  PhotoCollectionViewDataSource.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 11.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "PhotoCollectionViewDataSource.h"
#import "AttachmentCollectionViewCell.h"

@interface PhotoCollectionViewDataSource() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic)  UIImagePickerController *ipc;
@property (weak, nonatomic)    UICollectionView *collectionView;
@property (nonatomic, copy) void (^comBlock)(UIImage *image);
@end

@implementation PhotoCollectionViewDataSource

- (id)initWithDelegate:(id <PhotoCollectionViewDataSourceProtocol>)delegate{
    self = [super init];
    if (self){
        self.attachmentImages = [NSMutableArray new];
        [self checkCollectionH];
        self.delegate = delegate;
    }
    return self;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [_ipc dismissViewControllerAnimated:YES completion:^{
         self.comBlock(nil);
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    [_ipc dismissViewControllerAnimated:YES completion:^{
        self.comBlock(image);
    }];
    
    [_attachmentImages addObject:image];
    [self checkCollectionH];
    [self.collectionView reloadData];;
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:_attachmentImages.count -1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AttachmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AttachmentCollectionViewCellID"
                                                                                   forIndexPath:indexPath];
    [cell updateAppiarence:_attachmentImages[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView performBatchUpdates:^{
        NSArray *selectedItemsIndexPaths = [self.collectionView indexPathsForSelectedItems];
        [_attachmentImages removeObjectAtIndex:indexPath.row];
        [self.collectionView deleteItemsAtIndexPaths:selectedItemsIndexPaths];
    } completion:^(BOOL finished) {
        [self checkCollectionH];
    }];
}

- (void)showPhotoFrom:(UIViewController*)controller PickerwithComblock:(void (^)(UIImage *image))comBlockNew{
  
    if (_attachmentImages.count<6){
        _ipc = [[UIImagePickerController alloc] init];
        _ipc.delegate = self;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
              _comBlock = comBlockNew;
            [controller presentViewController:_ipc animated:YES completion:NULL];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Camera Available." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.collectionView = collectionView;
    return _attachmentImages.count;
}


- (void)checkCollectionH{
    
    if (![self.delegate respondsToSelector:@selector(collectionViewSetVisible:)]) return;
    
    if (_attachmentImages.count==0){
        [self.delegate collectionViewSetVisible:NO];
    } else {
        [self.delegate collectionViewSetVisible:YES];
    }
}

@end
