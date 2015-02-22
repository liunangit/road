//
//  BRPlayerManager.h
//  Road
//
//  Created by liunan on 15/2/22.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPlayerDateDidChangedNotification @"kPlayerDateDidChangedNotification"

@interface BRPlayerManager : NSObject

@property (nonatomic, readonly) NSInteger currentDate;
@property (nonatomic, readonly) NSString *currentDateStr;

+ (id)defaultManager;
- (void)addDate:(NSInteger)date;

@end
