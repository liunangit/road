//
//  BRTownModel.m
//  Road
//
//  Created by liunan on 15/2/8.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "BRTownModel.h"

@interface BRTownModel ()

@property (nonatomic) CGRect rect;

@end

@implementation BRTownModel

- (CGRect)rectInMap
{
    if (self.rect.size.width > 0 && self.rect.size.height > 0) {
        return self.rect;
    }
    
    CGFloat x = self.xScale / 1000.0f * self.mapSize.width;
    CGFloat y = self.yScale / 1000.0f * self.mapSize.height;
    CGFloat width = self.widthScale / 1000.0f * self.mapSize.width;
    CGFloat height = self.heightScale / 1000.0f * self.mapSize.height;
    self.rect = CGRectMake(x, y, width, height);
    return self.rect;
}

@end
