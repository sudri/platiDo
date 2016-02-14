//
//  JKLLockScreenViewController.h
//  JKLib
//
//  @date   2015. 03. 25.
//  @author Choi JoongKwan
//  @email  joongkwan.choi@gmail.com
//  @brief  Lock Screen View Controller class
//

#import <UIKit/UIKit.h>
#import "ClearPinCode.h"
#import "MagicPinLabel.h"

typedef NS_ENUM(NSInteger, LockScreenMode) {
    LockScreenModeNormal = 0,       // [일반 모드]
    LockScreenModeNew,              // [신규 모드]
    LockScreenModeChange,           // [변경 모드]
    LockScreenModeVerification,     // [확인 모드]
};

@protocol JKLLockScreenViewControllerDelegate;
@protocol JKLLockScreenViewControllerDataSource;

@interface JKLLockScreenViewController : UIViewController

@property (nonatomic, unsafe_unretained) LockScreenMode lockScreenMode;
@property (nonatomic, weak) IBOutlet id<JKLLockScreenViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet id<JKLLockScreenViewControllerDataSource> dataSource;




@property (nonatomic, strong) NSString *titleLabelText;
@property (nonatomic, strong) NSString *detailLabelText;
@property (nonatomic, strong) NSString *cancelBtnText;

- (void)updateTitles;


@end

@protocol JKLLockScreenViewControllerDelegate <NSObject>
@optional
- (void)unlockWasSuccessfulLockScreenViewController:(JKLLockScreenViewController *)lockScreenViewController pincode:(NSString *)pincode;    // support for number
- (void)unlockWasSuccessfulLockScreenViewController:(JKLLockScreenViewController *)lockScreenViewController;                                // support for touch id
- (void)unlockWasCancelledLockScreenViewController:(JKLLockScreenViewController *)lockScreenViewController;
- (void)unlockWasRequestLoginAuthViewController:(JKLLockScreenViewController *)lockScreenViewController;
- (void)unlockWasFailureLockScreenViewController:(JKLLockScreenViewController *)lockScreenViewController;
@end

@protocol JKLLockScreenViewControllerDataSource <NSObject>
@required
- (BOOL)lockScreenViewController:(JKLLockScreenViewController *)lockScreenViewController pincode:(NSString *)pincode;
@optional
- (BOOL)allowTouchIDLockScreenViewController:(JKLLockScreenViewController *)lockScreenViewController;
@end
