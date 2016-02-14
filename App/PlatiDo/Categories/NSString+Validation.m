//
//  NSString+Validation.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 15.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

- (BOOL) isAllDigits
{
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound;
}

@end
