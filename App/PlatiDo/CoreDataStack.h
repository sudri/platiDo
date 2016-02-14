//
//  CoreDataStack.h
//  PlatiDo
//
//  Created by Valera Voroshilov on 04.08.15.
//  Copyright (c) 2015 Valera Voroshilov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define shareCoreDataStack [CoreDataStack sharedInstance]

@interface CoreDataStack : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataStack*)sharedInstance;
- (void)saveContext;

@end
