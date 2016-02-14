//
//  CounterReportItemView.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 10.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "CounterReportItemView.h"
#import "ArchiveCounterModel.h"

@implementation CounterReportItemView

-(void)awakeFromNib{

//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
//                                                         attribute:NSLayoutAttributeHeight
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:nil
//                                                         attribute:NSLayoutAttributeNotAnAttribute
//                                                        multiplier:1
//                                                          constant:45]];
}

-(void)setArchiveCounterModel:(ArchiveCounterModel *)archiveCounterModel{

    _archiveCounterModel = archiveCounterModel;
    [self.counterNameLabel setText:_archiveCounterModel.title];
    [self.counterImageView setImage:[UIImage imageNamed:[_archiveCounterModel getIconForType]]];
    [self.counterReportLabel setText:[NSString stringWithFormat:@"%@ %@", _archiveCounterModel.value, _archiveCounterModel.metrics]];
    if ([_archiveCounterModel.subtitle length] > 0){
        [self.userCommentLabel setText:[NSString stringWithFormat:@"(%@)", _archiveCounterModel.subtitle]];
    }
}

@end
