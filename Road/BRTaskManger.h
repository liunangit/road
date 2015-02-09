//
//  BRTaskManger.h
//  Road
//
//  Created by 刘楠 on 15/2/9.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BRTaskModel;

@interface BRTaskManger : NSObject

+ (BRTaskManger *)defaultManager;
- (BRTaskModel *)taskWithID:(NSString *)taskID;

@end
