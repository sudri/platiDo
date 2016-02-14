//
//  CurrentUser.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 24.07.15.
//  Copyright (c) 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, OwnershipStatus) {
    OwnershipStatusNotconfirm         = 0,
    OwnershipStatusConfirm            = 1
};

#define CurrentUserInstance [CurrentUser sharedInstance]

typedef enum : NSUInteger {
    NotificationSettingsNewAccount          = (1 << 0),
    NotificationSettingsLettingReadings     = (1 << 1),
    NotificationSettingsChangesMyRequest    = (1 << 2),
    NotificationSettingsNewPoll             = (1 << 3),
    NotificationSettingsNewTopic            = (1 << 4),
    NotificationSettingsNewPost             = (1 << 5),
    NotificationSettingsComments            = (1 << 6)
} NotificationSettings;


@interface CurrentUser : NSObject <NSCoding>
+ (CurrentUser*)sharedInstance;

- (void)refreshUserWithDictionary:(NSDictionary*)dictionary;

@property (nonatomic, assign) BOOL isPinEntryScreenShowed;
@property (nonatomic, assign) OwnershipStatus ownershipStatus;

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *pinCode;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong, readonly) NSString *phoneNumberShort;
@property (nonatomic, strong) NSString *uidUser;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *surname;
@property (nonatomic, strong) NSString *midName;
@property (nonatomic, strong) NSDictionary *myCompany;

@property (nonatomic, assign) BOOL isLinkedCompany;
//address
@property (nonatomic, strong) NSString *town;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *building;
@property (nonatomic, strong) NSString *partBuilding;
@property (nonatomic, strong) NSString *apartament;

@property (nonatomic, strong) NSString *verificationCode;//not save
@property (nonatomic, strong) NSString *tempToken;
@property (nonatomic, strong) NSString *tempTownCode;

@property (nonatomic, assign) NotificationSettings notificationSettings;


- (void)resetUser;
- (void)saveYourSelf;

@end
