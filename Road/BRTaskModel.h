//
//  BRTaskModel.h
//  Road
//
//  Created by liunan on 15/2/8.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _BRTaskStatus {
    BRTaskStatus_New,
    BRTAskStatus_Accept, //已接任务
    BRTaskStatus_Done,   //已做完但是没有交的任务
    BRTaskStatus_Finished, //已交的任务
} BRTaskStatus;

@interface BRTaskModel : NSObject

@property (nonatomic, copy) NSString *taskID;
@property (nonatomic)       NSInteger costTime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic)       NSInteger difficulty;
@property (nonatomic, strong) NSArray *preTasks;
@property (nonatomic)       BRTaskStatus status;

@end
