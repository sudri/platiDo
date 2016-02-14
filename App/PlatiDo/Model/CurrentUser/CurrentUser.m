//
//  CurrentUser.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 24.07.15.
//  Copyright (c) 2015 Valera Voroshilov. All rights reserved.
//

//#define debug 1

#import "CurrentUser.h"
#import "RegistarationAPI.h"

static CurrentUser* sCurrentUserInstance;
#define kCurrentUserDefaultsObject @"kCurrentUserDefaultsObject"


@implementation CurrentUser
+ (CurrentUser*)sharedInstance{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sCurrentUserInstance = [self initFromUserDefaults];
        if (sCurrentUserInstance == nil){
           sCurrentUserInstance = [[self alloc] init];
        }
        
#ifdef debug
        sCurrentUserInstance.isRegistered = NO;
#endif
    });
    return sCurrentUserInstance;
}

- (void)refreshUserWithDictionary:(NSDictionary*)user{
    self.token                  = [user valueForKey:@"_auth_token"];
    self.uidUser                = [user valueForKey:@"id"];
    self.phoneNumber            = [user valueForKey:@"phone"];
    self.email                  = [user valueForKey:@"email"];
    self.name                   = [user valueForKey:@"name"];
    self.surname                = [user valueForKey:@"surname"];
    self.midName                = [user valueForKey:@"mid_name"];
    self.userId                 = [user valueForKey:@"userId"];
    
    
    self.town                   = [user valueForKey:@"city"];
    self.street                 = [user valueForKey:@"street"];
    self.building               = [user valueForKey:@"building_number"];
    self.partBuilding           = [user valueForKey:@"building_part"];
    self.apartament             = [user valueForKey:@"apartment_number"];
    
    self.ownershipStatus        = [[user valueForKey:@"is_ownership_confirmed"] integerValue];
    self.isLinkedCompany        = [[user valueForKey:@"is_linked_to_company"] boolValue];
    [self saveYourSelf];
}


- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
    
        self.myCompany              = [decoder decodeObjectForKey:@"myCompany"];
        self.uidUser                = [decoder decodeObjectForKey:@"uidUser"];
        self.phoneNumber            = [decoder decodeObjectForKey:@"phoneNumber"];
        self.email                  = [decoder decodeObjectForKey:@"email"];
        self.token                  = [decoder decodeObjectForKey:@"token"];
        self.name                   = [decoder decodeObjectForKey:@"name"];
        self.surname                = [decoder decodeObjectForKey:@"surname"];
        self.midName                = [decoder decodeObjectForKey:@"midName"];
        self.pinCode                = [decoder decodeObjectForKey:@"pinCode"];
        self.userId                 = [decoder decodeObjectForKey:@"userId"];
        self.isPinEntryScreenShowed = [decoder decodeBoolForKey:@"isPinEntryScreenShowed"];
        self.ownershipStatus        = [[decoder decodeObjectForKey:@"ownershipStatus"] integerValue];
        
        //address
        self.town                   = [decoder decodeObjectForKey:@"town"];
        self.street                 = [decoder decodeObjectForKey:@"street"];
        self.building               = [decoder decodeObjectForKey:@"building"];
        self.partBuilding           = [decoder decodeObjectForKey:@"partBuilding"];
        self.apartament             = [decoder decodeObjectForKey:@"apartament"];
        
    }
    return self;
}


- (void)resetUser{
  
    self.myCompany              = @{};
    self.uidUser                = @"";
    self.phoneNumber            = @"";
    self.token                  = @"";
    self.name                   = @"";
    self.surname                = @"";
    self.midName                = @"";
    self.pinCode                = @"";
    self.userId                 = @"";
    self.ownershipStatus = OwnershipStatusNotconfirm;
    
    self.town                   = @"";
    self.street                 = @"";
    self.building               = @"";
    self.partBuilding           = @"";
    self.apartament             = @"";
    
    [self saveYourSelf];
}

- (NSString*)phoneNumberShort{
    NSString *str = [CurrentUserInstance.phoneNumber substringWithRange:(NSRange){2,CurrentUserInstance.phoneNumber.length-2}];
    return str;
}

+ (CurrentUser*)initFromUserDefaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:kCurrentUserDefaultsObject];
    CurrentUser *user = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return user;
}

- (void)saveYourSelf{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:kCurrentUserDefaultsObject];
    [defaults synchronize];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.myCompany                forKey:@"myCompany"];
    [encoder encodeObject:self.uidUser                  forKey:@"uidUser"];
    [encoder encodeObject:self.phoneNumber              forKey:@"phoneNumber"];
    [encoder encodeObject:self.email                    forKey:@"email"];
    [encoder encodeObject:self.token                    forKey:@"token"];
    [encoder encodeObject:self.name                     forKey:@"name"];
    [encoder encodeObject:self.surname                  forKey:@"surname"];
    [encoder encodeObject:self.midName                  forKey:@"midName"];
    [encoder encodeObject:self.pinCode                  forKey:@"pinCode"];
    [encoder encodeObject:self.userId                   forKey:@"userId"];
    [encoder encodeBool:self.isPinEntryScreenShowed     forKey:@"isPinEntryScreenShowed" ];
    [encoder encodeInteger:self.ownershipStatus forKey:@"ownershipStatus"];

    //address
    [encoder encodeObject:self.town                     forKey:@"town"];
    [encoder encodeObject:self.street                   forKey:@"street"];
    [encoder encodeObject:self.building                 forKey:@"building"];
    [encoder encodeObject:self.partBuilding             forKey:@"partBuilding"];
    [encoder encodeObject:self.apartament               forKey:@"apartament"];
    
    

}

@end
