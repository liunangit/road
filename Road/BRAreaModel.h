//
//  BRAreaModel.h
//  Road
//
//  Created by 刘楠 on 15/2/9.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _BRFaction {
    Neutral = 0,
    Horde,
    Alliance,
} BRFaction;

@interface BRAreaModel : NSObject

@property (nonatomic) NSUInteger xScale;
@property (nonatomic) NSUInteger yScale;
@property (nonatomic) NSUInteger widthScale;
@property (nonatomic) NSUInteger heightScale;
@property (nonatomic) CGSize mapSize;
@property (nonatomic, readonly) CGRect rectInMap;
@property (nonatomic) BRFaction faction;

@end
