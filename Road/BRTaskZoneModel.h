//
//  BRTaskZoneModel.h
//  Road
//
//  Created by honey.vi on 15/2/20.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRAreaModel.h"

@interface BRTaskZoneModel : NSObject

@property (nonatomic, strong) BRAreaModel *area;
@property (nonatomic, copy) NSString *zoneID;
@property (nonatomic, copy) NSString *zoneName;
@property (nonatomic, strong) NSArray *tasks;

@end
