//
//  UIViewController+ConfirmRightsController.m
//  
//
//  Created by Valera Voroshilov on 13.09.15.
//
//

#import "OwnershipHelper.h"
#import "ConfirmRightsViewController.h"



@interface OwnershipHelper ()
@property (nonatomic, weak)  UIViewController *ownerController;
@property (nonatomic, strong)  ConfirmRightsViewController *confirmRightsViewController;
@property (nonatomic, strong)  UIViewController *managerResponceController;
@end

@implementation OwnershipHelper


- (id)initWithViewController:(UIViewController*)viewController{
    self = [super init];
    if (self){
        self.ownerController = viewController;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.confirmRightsViewController = [storyboard instantiateViewControllerWithIdentifier:@"ConfirmRightsViewController"];
        
        
        
       // self.managerResponceController   = [storyboard instantiateViewControllerWithIdentifier:@"ManagerResponce"];
        [self updateByStatus];
        
        [CurrentUserInstance addObserver:self forKeyPath:NSStringFromSelector(@selector(ownershipStatus)) options:0 context:nil];
    }
    return self;
}

- (void)dealloc{
    [CurrentUserInstance removeObserver:self forKeyPath:@"ownershipStatus"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self updateByStatus];
}

- (void)setCompletionBlock:(void (^)(OwnershipStatus))completionBlock
{
    self.confirmRightsViewController.completionBlock = completionBlock;
}

- (void)updateByStatus{
    OwnershipStatus stat = [CurrentUserInstance ownershipStatus];
    switch (stat) {
        case OwnershipStatusConfirm:{
            [self.confirmRightsViewController removeFromParentViewController];
            [self.confirmRightsViewController.view removeFromSuperview];
            [self.confirmRightsViewController didMoveToParentViewController:nil];
        }
            break;
            
        case OwnershipStatusNotconfirm:{
            [self.ownerController addChildViewController:self.confirmRightsViewController];
            [self.ownerController.view addSubview: self.confirmRightsViewController.view];
            [self.confirmRightsViewController didMoveToParentViewController:self.ownerController];
        }
            break;

    }
}


@end
