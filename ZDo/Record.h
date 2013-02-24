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

@property (nonatomic, retain) NSNumber * completeTime;
@property (nonatomic, retain) NSNumber * createTime;
@property (nonatomic, retain) NSNumber * expireTime;
@property (nonatomic, retain) NSString * record;

@end
