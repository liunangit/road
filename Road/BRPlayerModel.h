//
//  BRPlayerModel.h
//  Road
//
//  Created by liunan on 15/2/22.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BRAreaModel;

@interface BRPlayerModel : NSObject

@property (nonatomic) NSInteger date;
@property (nonatomic, strong) BRAreaModel *location;

@end
