//
//  BRUtils.h
//  Road
//
//  Created by liunan on 15/2/21.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _BRDeviceType {
    BRDeviceiPhone,
    BRDeviceiPad,
} BRDeviceType;

@interface BRUtils : NSObject

+ (BOOL)isPad;
+ (CGFloat)statusBarHeight;

@end
