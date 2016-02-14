//
//  UserRequestTypeModel.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 01.09.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "UserRequestTypeModel.h"
#import "CurrentUser.h"

#define USER_REQUEST_TYPES_KEY @"UserRequestTypeKey"

@implementation UserRequestTypeModel


- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        self.label = [coder decodeObjectForKey:@"label"];
        self.value = [coder decodeObjectForKey:@"value"];
       
    }
    return self;
}

- (void)bla
{
    
    
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.label forKey:@"label"];
    [coder encodeObject:self.value forKey:@"value"];
}



+ (void)saveArrayInDefaults: (NSArray *) arrayOfUserRequestTypes{

    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:arrayOfUserRequestTypes]
                                              forKey:USER_REQUEST_TYPES_KEY];
}

+ (NSArray *)getArrayOfUserRequestTypes{

    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:USER_REQUEST_TYPES_KEY];
    
    NSArray *objectArray = [NSArray new];
    
    if (dataRepresentingSavedArray != nil)
    {
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        if (oldSavedArray != nil){
            objectArray = [[NSMutableArray alloc] initWithArray:oldSavedArray];
        }
        else{
            objectArray = [[NSMutableArray alloc] init];
        }
    }
    if ([CurrentUserInstance ownershipStatus]==OwnershipStatusNotconfirm){
        NSMutableArray *mutableArray = [objectArray mutableCopy];
        NSMutableArray *result = [NSMutableArray new];
        for (UserRequestTypeModel *object in mutableArray){
            if (![object.value isEqualToString:@"apartment"]){
                [result addObject:object];
            }
        }
        objectArray = result;
    }
   
    return objectArray;
}

@end
