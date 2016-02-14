//
//  ClearPinCode.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 26.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClearPinCode;

@protocol ClearPinCodeViewDelegate <NSObject>
@required
- (void)didenterCodeTo:(ClearPinCode *)lockScreenPincodeView pincode:(NSString *)pincode;
@end

@interface ClearPinCode : UIView

@property (nonatomic, strong) NSArray *pinLabels;
@property (nonatomic, weak) id<ClearPinCodeViewDelegate> delegate;
- (void)appendChar:(NSString*)str;


@end

