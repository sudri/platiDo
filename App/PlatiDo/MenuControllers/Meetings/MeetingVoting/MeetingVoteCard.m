//
//  MeetingVoteCard.m
//  PlatiDo
//
//  Created by Smart Labs on 07.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "MeetingVoteCard.h"
#import "UIColor+Additions.h"

@implementation MeetingVoteCard

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self loadView];
    }
    return self;
}

- (void)loadView
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    MeetingVoteCard *view = [[bundle loadNibNamed:@"MeetingVoteCard" owner:self options:nil] firstObject];
    view.frame = self.bounds;
    [self addSubview:view];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    self.layer.borderColor = [UIColor colorWithHex:0xAAAAAA].CGColor;
    self.layer.borderWidth = 0.5f;
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    self.layer.shadowOpacity = 0.3f;
    self.layer.shadowPath = shadowPath.CGPath;
    
    self.zaButton.layer.cornerRadius = 3;
    self.againstButton.layer.cornerRadius = 3;
    self.abstentionButton.layer.cornerRadius = 3;
    
}

- (void)addUpTarget:(id)target action:(SEL)action
{
    [self.zaButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{

}

@end
