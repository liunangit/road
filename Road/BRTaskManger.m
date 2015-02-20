//
//  BRTaskManger.m
//  Road
//
//  Created by 刘楠 on 15/2/9.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "BRTaskManger.h"

@interface BRTaskManger ()

@property (nonatomic, strong) NSMutableDictionary *taskDic;
@property (nonatomic, strong) NSMutableDictionary *taskStatusDic;

@end

@implementation BRTaskManger

+ (BRTaskManger *)defaultManager
{
    static dispatch_once_t onceToken;
    static BRTaskManger *manager = nil;
    
    dispatch_once(&onceToken, ^(void) {
        manager = [[BRTaskManger alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _taskStatusDic = [[NSMutableDictionary alloc] init];
        NSString *configPath = [[NSBundle mainBundle] pathForResource:@"task" ofType:@"plist"];
        self.taskDic = [NSMutableDictionary dictionary];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:configPath];
        
        NSArray *allKeys = [dic allKeys];
        for (NSString *taskID in allKeys) {
            BRTaskModel *taskModel = [self parseTaskModel:dic[taskID]];
            if (taskModel) {
                taskModel.taskID = taskID;
                self.taskDic[taskID] = taskModel;
                taskModel.status = [self taskStatus:taskID];
            }
        }
        
    }
    return self;
}

- (BRTaskModel *)taskWithID:(NSString *)taskID
{
    if (taskID.length == 0) {
        return nil;
    }
    return self.taskDic[taskID];
}

- (BRTaskModel *)parseTaskModel:(NSDictionary *)taskDic
{
    if (taskDic.count == 0) {
        return nil;
    }
    
    BRTaskModel *taskModel = [[BRTaskModel alloc] init];
    taskModel.title = taskDic[@"Title"];
    taskModel.content = taskDic[@"Content"];
    taskModel.costTime = [taskDic[@"Cost"] integerValue];
    taskModel.difficulty = [taskDic[@"Difficulty"] integerValue];
    taskModel.preTasks = taskDic[@"PreTask"];
    taskModel.battleDesc = taskDic[@"BattleDesc"];
    return taskModel;
}

- (void)setTask:(NSString *)taskID status:(BRTaskStatus)status
{
    self.taskStatusDic[taskID] = [NSNumber numberWithInteger:status];
}

- (BRTaskStatus)taskStatus:(NSString *)taskID
{
    return (BRTaskStatus)[self.taskStatusDic[taskID] integerValue];
}

@end
