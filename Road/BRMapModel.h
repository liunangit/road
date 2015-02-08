//
//  BRMapModel.h
//  Road
//
//  Created by liunan on 15/2/8.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRTownModel.h"
#import "BRTaskModel.h"

@interface BRMapModel : NSObject

@property (nonatomic, copy) NSString *mapFile;
@property (nonatomic, copy) NSString *mapName;
@property (nonatomic, strong) NSArray *townList;
@property (nonatomic) CGSize mapSize;

@end
