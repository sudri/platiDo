//
//  CheckList.h
//  
//
//  Created by Valera Voroshilov on 03.08.15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CheckListItem;

@interface CheckList : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * payed;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSSet *items;
@end

@interface CheckList (CoreDataGeneratedAccessors)

- (void)addItemsObject:(CheckListItem *)value;
- (void)removeItemsObject:(CheckListItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
