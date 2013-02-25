//
//  ViewController.h
//  ZDo
//
//  Created by john song on 13-2-24.
//  Copyright (c) 2013年 john song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordLogic.h"
#import "NoteCell.h"
@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NoteCellDelgate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) RecordLogic *recordLogic;
@end
