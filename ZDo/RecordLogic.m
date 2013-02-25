//
//  RecordLogic.m
//  ZDo
//
//  Created by john song on 13-2-24.
//  Copyright (c) 2013年 john song. All rights reserved.
//

#import "RecordLogic.h"
#import <CoreData/CoreData.h>
#import "Record.h"
static RecordLogic *sharedRecordLogic = nil;
@implementation RecordLogic
+(RecordLogic *)sharedRecordLogic{
    if(sharedRecordLogic == nil){
        sharedRecordLogic = [[super allocWithZone:NULL] init];
    }
    return sharedRecordLogic;
}

-(NSArray *)recordList{
//    NSSortDescriptor *sortDescriptor;
//    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createTime"
//                                                 ascending:NO];
//    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//    NSArray *sortedArray;
//    sortedArray = [[self fetchRecordList] sortedArrayUsingDescriptors:sortDescriptors];
    return [self fetchRecordList];
}

-(void)deleteRecord : (Record*)record{
    [self.managedObjectContext deleteObject:record];
    [self saveContext];
}

-(void)completeRecord : (Record *)record{
    record.completeTime = [NSDate date];
    [self saveContext];
}

-(BOOL)createRecord : (NSString*)record{
    if (!record) {
        return NO;
    }
    Record *recordObject = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:self.managedObjectContext];
    recordObject.record = record;
    recordObject.createTime = [NSDate date];
    [self saveContext];
    return YES;
}

-(NSNumber *)currentTimeInterval{
    return [NSNumber numberWithDouble:[[NSDate date]timeIntervalSince1970]];
}

#pragma mark -
#pragma mark - Core Data Stack

- (NSManagedObjectModel *)managedObjectModel
{
    if (nil != _managedObjectModel) {
        return _managedObjectModel;
    }
    
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (nil != _managedObjectContext) {
        return _managedObjectContext;
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    
    if (self.persistentStoreCoordinator) {
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (nil != _persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSString *storeType = NSSQLiteStoreType;
    NSString *storeName = @"cdNBA.sqlite";
    
    NSError *error = NULL;
    NSURL *storeURL = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:storeName]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:storeType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Error : %@\n", [error localizedDescription]);
        NSAssert1(YES, @"Failed to create store %@ with NSSQLiteStoreType", [storeURL path]);
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's Documents Directory

- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

#pragma mark -
#pragma mark - CURD Operations



- (NSArray *)fetchRecordList
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Record" inManagedObjectContext:self.managedObjectContext]];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"completeTime" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor2,sortDescriptor1, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error = NULL;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Error : %@\n", [error localizedDescription]);
    }
    fetchRequest = nil;
    
    return array;
}
#pragma mark -
#pragma mark - Save Context

- (void)saveContext
{
    NSError *error = NULL;
    NSManagedObjectContext *moc = self.managedObjectContext;
    if (moc && [moc hasChanges] && ![moc save:&error]) {
        NSLog(@"Error %@, %@", error, [error localizedDescription]);
        abort();
    }
}

@end
