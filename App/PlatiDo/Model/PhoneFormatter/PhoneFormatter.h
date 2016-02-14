//
//  PhoneFormatter.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 26.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneFormatter : NSObject

// phone; sms; part; build number;
+ (NSString*)formatPhoneNumber:(NSString*)simpleNumber deleteLastChar:(BOOL)deleteLastChar;
+ (NSString*)formatSMSNumber:(NSString*)simpleNumber deleteLastChar:(BOOL)deleteLastChar;
+ (NSString*)formatBuildNumber:(NSString*)simpleNumber deleteLastChar:(BOOL)deleteLastChar;
+ (NSString*)formatPartNumber:(NSString*)simpleNumber deleteLastChar:(BOOL)deleteLastChar;

// date
+ (NSString*)formatShortDate:(NSDate*)sourceDate;
+ (NSString*)formatStringDate:(NSDate*)sourceDate;
+ (NSDate*)dateFromServerString:(NSString*)sourceString;
@end
