//
//  PhotoCollectionViewDataSource.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 11.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PhotoCollectionViewDataSourceProtocol <NSObject>
- (void)collectionViewSetVisible:(BOOL)isVisible;
@end

@interface PhotoCollectionViewDataSource : NSObject  <UICollectionViewDelegate, UICollectionViewDataSource>

- (id)initWithDelegate:(id <PhotoCollectionViewDataSourceProtocol>)delegate;
- (void)showPhotoFrom:(UIViewController*)controller PickerwithComblock:(void (^)(UIImage *image))comBlock;

@property (nonatomic,strong) NSMutableArray *attachmentImages;
@property (nonatomic,strong) id <PhotoCollectionViewDataSourceProtocol> delegate;

@end
