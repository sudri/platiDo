//
//  MeetingVoteCard.h
//  PlatiDo
//
//  Created by Smart Labs on 07.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingVoteCard : UIView

@property (weak, nonatomic) IBOutlet UIButton *zaButton;
@property (weak, nonatomic) IBOutlet UIButton *againstButton;
@property (weak, nonatomic) IBOutlet UIButton *abstentionButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)addUpTarget:(id)target action:(SEL)action;

@end
