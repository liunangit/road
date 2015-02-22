//
//  BRUtils.m
//  Road
//
//  Created by liunan on 15/2/21.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "BRUtils.h"

@implementation BRUtils

+ (BOOL)isPad
{
    UIUserInterfaceIdiom device = [UIDevice currentDevice].userInterfaceIdiom;
    return device == UIUserInterfaceIdiomPad;
}

+ (CGFloat)statusBarHeight
{
    if ([self isPad]) {
        return 40;
    }
    else {
        return 60;
    }
}

@end
