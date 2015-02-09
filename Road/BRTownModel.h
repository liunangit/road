//
//  BRTownModel.h
//  Road
//
//  Created by liunan on 15/2/8.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRAreaModel;

@interface BRTownModel : NSObject

@property (nonatomic, copy) NSString *townID;
@property (nonatomic, copy) NSString *townName;
@property (nonatomic, strong) BRAreaModel *area;
@property (nonatomic, strong) NSArray *taskList;

@end
