//
//  RecordLogic.h
//  ZDo
//
//  Created by john song on 13-2-24.
//  Copyright (c) 2013年 john song. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Record;
@interface RecordLogic : NSObject
+(RecordLogic *)sharedRecordLogic;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(NSArray *)recordList;
-(void)deleteRecord : (Record*)record;
-(BOOL)createRecord : (NSString*)record;
-(void)completeRecord : (Record *)record;
@end
