//
//  BRTownModel.h
//  Road
//
//  Created by liunan on 15/2/8.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRTaskModel;

@interface BRTownModel : NSObject

@property (nonatomic, copy) NSString *townID;
@property (nonatomic, copy) NSString *townName;

@property (nonatomic) NSUInteger xScale;
@property (nonatomic) NSUInteger yScale;
@property (nonatomic) NSUInteger widthScale;
@property (nonatomic) NSUInteger heightScale;
@property (nonatomic, strong) NSArray *taskList;

@property (nonatomic, readonly) CGRect rectInMap;
@property (nonatomic) CGSize mapSize;

@end
