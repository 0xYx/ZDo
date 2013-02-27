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
@synthesize fetchedResultsController = _fetchedResultsController;
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

-(void)refreshRecord : (Record*)record newNote : (NSString *)note{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createTime == %@",record.createTime];
    [self enumerateClocks:predicate withAction:^(NSArray * result) {
        for (Record * object in result) {
            object.record = note;
        }
        [self saveContext];
    }];

}

-(void)completeRecord : (Record *)record{
    record.completeTime = [NSDate date];
    [self refreshRecord:record newNote:record.record];
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
    NSString *storeName = @"ZDo.sqlite";
    
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

- (void) enumerateClocks:(NSPredicate *) predicate withAction:(void(^)(NSArray * result))action {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Record" inManagedObjectContext:self.managedObjectContext]];
    [request setPredicate:predicate];
    NSError *error;
    NSArray * result = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if(error) {
        NSLog(@"%@", error);
        return;
    } else {
        action(result);
    }
}

#pragma mark -
#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *playerEntity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:playerEntity];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"completeTime" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor2,sortDescriptor1, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];

    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Record"];

    
    NSError *error = NULL;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
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
