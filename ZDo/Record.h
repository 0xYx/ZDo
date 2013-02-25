//
//  Record.h
//  ZDo
//
//  Created by john song on 13-2-24.
//  Copyright (c) 2013年 john song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Record : NSManagedObject

@property (nonatomic, retain) NSDate * completeTime;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSDate * expireTime;
@property (nonatomic, retain) NSString * record;

@end
