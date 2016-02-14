//
//  ClearPinCode.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 26.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "ClearPinCode.h"
#import "MagicPinLabel.h"

@implementation ClearPinCode{
    NSMutableString *_pinCode;
    NSInteger _wasCompleted;
}




- (void)appendChar:(NSString*)str{
    if (_pinCode==nil){
        _pinCode = [@"" mutableCopy];
    }
    
    if (_wasCompleted<=3){
        MagicPinLabel *pinlbl = self.pinLabels[_wasCompleted];
        [pinlbl setNumber:str];
        _wasCompleted++;
        [_pinCode appendString:str];
        if (_wasCompleted==4){
            if ([self.delegate respondsToSelector:@selector(didenterCodeTo:pincode:)]){
                [self.delegate didenterCodeTo:self pincode:_pinCode];
            }
        }
    } 
}

@end
