//
//  CounterReportItemView.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 10.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArchiveCounterModel;

@interface CounterReportItemView : UIView

@property (strong, nonatomic) ArchiveCounterModel   * archiveCounterModel;

@property (weak, nonatomic) IBOutlet UIImageView    *counterImageView;
@property (weak, nonatomic) IBOutlet UILabel        *counterNameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *counterReportLabel;
@property (weak, nonatomic) IBOutlet UILabel        *userCommentLabel;

@end
