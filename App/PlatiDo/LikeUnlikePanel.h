//
//  LikeUnlikePanel.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 23.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LikeUnlikePanel;

@protocol LikeUnlikePanelProtocol <NSObject>
- (void)likeTapped:(LikeUnlikePanel*)sender;
- (void)unlikeTapped:(LikeUnlikePanel*)sender;
@end


@interface LikeUnlikePanel : UIView
@property (nonatomic, strong) id <LikeUnlikePanelProtocol> delegate;

- (void)setLikeCount:(NSInteger)likeCount;
- (void)setUnLikeCount:(NSInteger)likeCount;

- (void)setLikeSelected:(BOOL)isSelected;
- (void)setUnLikeSelected:(BOOL)isSelected;

@property (nonatomic, assign) BOOL enabled;
@end
