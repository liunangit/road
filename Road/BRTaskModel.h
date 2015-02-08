//
//  BRTaskModel.h
//  Road
//
//  Created by honey.vi on 15/2/8.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRTaskModel : NSObject

@property (nonatomic, copy) NSString *taskID;
@property (nonatomic)       NSInteger costTime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;

@end
