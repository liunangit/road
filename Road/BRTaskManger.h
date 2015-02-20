//
//  BRTaskManger.h
//  Road
//
//  Created by 刘楠 on 15/2/9.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRTaskModel.h"

@interface BRTaskManger : NSObject

+ (BRTaskManger *)defaultManager;
- (BRTaskModel *)taskWithID:(NSString *)taskID;

- (void)setTask:(NSString *)taskID status:(BRTaskStatus)status;
- (BRTaskStatus)taskStatus:(NSString *)taskID;

@end
