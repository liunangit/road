//
//  BRAreaModel.m
//  Road
//
//  Created by 刘楠 on 15/2/9.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "BRAreaModel.h"

@interface BRAreaModel ()

@property (nonatomic) CGRect rect;

@end

@implementation BRAreaModel

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
