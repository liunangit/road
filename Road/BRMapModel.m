//
//  BRMapModel.m
//  Road
//
//  Created by liunan on 15/2/8.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "BRMapModel.h"
#import "BRAreaModel.h"

@interface BRMapModel ()

@property (nonatomic) CGSize theMapSize;

@end

@implementation BRMapModel

- (void)setMapSize:(CGSize)mapSize
{
    self.theMapSize = mapSize;
    
    for (BRTownModel *townModel in self.townList) {
        townModel.area.mapSize = mapSize;
    }
}

@end
