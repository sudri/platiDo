//
//  MeetingVoteViewController.h
//  PlatiDo
//
//  Created by Smart Labs on 07.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meeting.h"

@interface MeetingVoteViewController : UIViewController

@property (nonatomic, strong) UIImage *blurredImage;
@property (nonatomic, strong) Meeting *meeting;
@property (weak, nonatomic) IBOutlet UIImageView *blurredIMageView;

@end
