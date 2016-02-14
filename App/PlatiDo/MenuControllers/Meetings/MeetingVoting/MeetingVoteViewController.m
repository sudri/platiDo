//
//  MeetingVoteViewController.m
//  PlatiDo
//
//  Created by Smart Labs on 07.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "MeetingVoteViewController.h"
#import "MeetingVoteCard.h"

@interface MeetingVoteViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *fonView;

@end

@implementation MeetingVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.blurredIMageView.image = self.blurredImage;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.fonView addGestureRecognizer:tap];
    
    CGRect pageFrame = [[UIScreen mainScreen] bounds];
    pageFrame.size.height = self.scrollView.frame.size.height;
    
    for (int i = 0; i < self.meeting.questions.count; i++) {
        CGRect frame;
        frame.origin.x = (pageFrame.size.width * i)+10;
        frame.origin.y = 0;
        frame.size = pageFrame.size;
        frame.size.width = pageFrame.size.width - 20;
        frame.size.height = pageFrame.size.height - 5;
        
        MeetingVoteCard *mvc = [[MeetingVoteCard alloc] initWithFrame:frame];
        mvc.descriptionLabel.text = [self.meeting.questions[i] title];
        mvc.titleLabel.text       = [NSString stringWithFormat:NSLocalizedString(@"Vote N%d", nil),i+1];
        // [mvc addUpTarget:self action:@selector(close)];
        [self.scrollView addSubview:mvc];
        
    }
    
    self.scrollView.contentSize = CGSizeMake(pageFrame.size.width * self.meeting.questions.count, pageFrame.size.height);
}



- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (IBAction)changePAge:(UIPageControl *)sender {
    
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (void)close
{
    for (UIView *view in self.scrollView.subviews)
    {
        if ([view isKindOfClass:[MeetingVoteCard class]])
        {
            NSLog(@"%@", ((MeetingVoteCard *)view).zaButton);
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
