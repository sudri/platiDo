//
//  CheckListItem.h
//  
//
//  Created by Valera Voroshilov on 03.08.15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CheckList;

@interface CheckListItem : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * measure;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * tariff;
@property (nonatomic, retain) CheckList *checkList;

@end
