//
//  NSString+Brackets.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 06.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "NSString+Brackets.h"

@implementation NSString (Brackets)

- (NSString *)stringWithBreckets{

    if (self.length  < 3) {
        return self;
    }
    NSMutableString *resultString = [[NSMutableString alloc] initWithString:self];

//    NSLog(@"with 0 - %@",[resultString substringWithRange:NSMakeRange(0, 1)]);
    if (![[resultString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"("]) {
        [resultString insertString:@"(" atIndex:0];
    }
//    NSLog(@"with %lu - %@",(unsigned long)resultString.length, [resultString substringWithRange:NSMakeRange(resultString.length - 1, 1)]);
    if (![[resultString substringWithRange:NSMakeRange(resultString.length - 1, 1)] isEqualToString:@")"]) {
        [resultString insertString:@")" atIndex:resultString.length];
    }

    return resultString;
}

- (NSString *)stringDeleteBreckets{
   
    if (self.length  < 3) {
        return self;
    }

    NSMutableString *resultString = [[NSMutableString alloc] initWithString:self];

//    NSLog(@"0 - %@",[resultString substringWithRange:NSMakeRange(0, 1)]);
    if ([[resultString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"("]) {
        [resultString deleteCharactersInRange:NSMakeRange(0,1)];
    }
//    NSLog(@"%lu - %@",(unsigned long)resultString.length, [resultString substringWithRange:NSMakeRange(resultString.length - 1, 1)]);
    if ([[resultString substringWithRange:NSMakeRange(resultString.length - 1, 1)] isEqualToString:@")"]) {
        [resultString deleteCharactersInRange:NSMakeRange(resultString.length - 1,1)];
    }

    return resultString;
}
@end
