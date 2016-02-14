//
//  ErrorProcessing.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 19.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "ErrorProcessing.h"
#import "AlertViewCustom.h"
#import "AppDelegate.h"

@interface ErrorProcessing()

@property (strong, nonatomic) NSDictionary *error_messages_keys;

@end

@implementation ErrorProcessing

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.error_messages_keys = @{@"invalid_sign"                                    : NSLocalizedString(@"Invalid sign", nil),
                                     @"validation_errors"                               : NSLocalizedString(@"Validation error", nil),
                                     @"phone_already_registered"                        : NSLocalizedString(@"Phone already registered", nil),
                                     @"failed_to_create_user"                           : NSLocalizedString(@"Failed to create user", nil),
                                     @"user_already_verified"                           : NSLocalizedString(@"User already varified", nil),
                                     @"invalid_verification_code"                       : NSLocalizedString(@"Invalid verification code", nil),
                                     @"verification_attemts_exceeded"                   : NSLocalizedString(@"Verification attemts exceeded", nil),
                                     @"failed_to_save_data"                             : NSLocalizedString(@"Failed to save data", nil),
                                     @"access_denied"                                   : NSLocalizedString(@"Access denied", nil),
                                     @"failed_to_update_user"                           : NSLocalizedString(@"Failed to update user", nil),
                                     @"could_not_create_token"                          : NSLocalizedString(@"Server error", nil),
                                     @"user_is_not_linked_to_building"                  : NSLocalizedString(@"User is not linked to building", nil),
                                     @"address_is_not_detailed_enough"                  : NSLocalizedString(@"Address is not detailed enough", nil),
                                     @"failed_to_add_address"                           : NSLocalizedString(@"Failed to add address", nil),
                                     @"failed_to_add_user_apartment"                    : NSLocalizedString(@"Failed to add user apartment", nil),
                                     @"user_apartment_already_exists"                   : NSLocalizedString(@"User apartment already exists", nil),
                                     @"building_does_not_belong_to_any_company_yet"     : NSLocalizedString(@"Building does not belong to any company yet", nil),
                                     @"user_apartment_ownership_is_not_confirmed"       : NSLocalizedString(@"User apartment ownership is not confirmed", nil),
                                     @"not_found"                                       : NSLocalizedString(@"Request not found", nil),
                                     @"request_already_closed"                          : NSLocalizedString(@"Request already closed", nil),
                                     @"stats_reporting_forbidden"                       : NSLocalizedString(@"Stats reporting forbidden", nil),
                                     @"discussion_closed"                               : NSLocalizedString(@"Discussion closed", nil),
                                     @"it_is_forbidden_to_like_your_discussion"         : NSLocalizedString(@"It is forbidden to like your discussion", nil),
                                     @"it_is_forbidden_to_like_your_comment"            : NSLocalizedString(@"It is forbidden to like your comment", nil),
                                     @"questions_are_invalid"                           : NSLocalizedString(@"Questions are invalid", nil),
                                     @"voting_already_closed"                           : NSLocalizedString(@"Voting already closed", nil),
                                     @"already_voted"                                   : NSLocalizedString(@"Already voted", nil),
                                     @"user_apartment_already_confirmed"                : NSLocalizedString(@"User apartment already confirmed", nil),
                                     @"user_is_not_linked_to_a_building"                : NSLocalizedString(@"User is not linked to a building", nil),
                                     @"apartment_not_exists"                            : NSLocalizedString(@"Apartment not exists", nil),
                                     @"failed_to_validate_apartment_ownership"          : NSLocalizedString(@"Failed to validate apartment ownership", nil),
                                     @"failed_to_save_ownership"                        : NSLocalizedString(@"Failed to save ownership", nil)
                                     };
    }
    return self;
}

- (void)processError:(NSError *)error{
    
    NSString *showErrorString = @"";
    
    // connection error
    if ([shareAppDelegate netStatus] == NotReachable) {
        showErrorString = @"Ошибка интернет соединения";
    }
    
    
    // auth error
    NSHTTPURLResponse *response = [error.userInfo valueForKey:@"com.alamofire.serialization.response.error.response"];
    if (response.statusCode == 401){
        showErrorString  = NSLocalizedString(@"Invalid sign", nil);
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        [app showAuthorization];
    }
    
    // validation error
    NSData *responseData = [error.userInfo valueForKey:@"com.alamofire.serialization.response.error.data"];
    if (responseData.length>2){
        NSError* err;
        id dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                  options:kNilOptions
                                                    error:&err];
      
        
        if ([dict isKindOfClass:[NSDictionary class]]){
            NSString *message = [dict valueForKey:@"_message"];
            if (![message isEqualToString:@"validation_errors"]){
                showErrorString = [self.error_messages_keys valueForKey:message];
            }
        }
    }
    
    if (showErrorString.length){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                            message:showErrorString
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }

}

@end
