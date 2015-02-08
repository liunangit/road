//
//  BRMapModel.m
//  Road
//
//  Created by honey.vi on 15/2/8.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "BRMapModel.h"

@interface BRMapModel ()

@property (nonatomic) CGSize theMapSize;

@end

@implementation BRMapModel

- (void)setMapSize:(CGSize)mapSize
{
    self.theMapSize = mapSize;
    
    for (BRTownModel *townModel in self.townList) {
        townModel.mapSize = mapSize;
    }
}

@end
