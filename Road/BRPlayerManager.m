//
//  BRPlayerManager.m
//  Road
//
//  Created by liunan on 15/2/22.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "BRPlayerManager.h"
#import "BRPlayerModel.h"

@interface BRPlayerManager ()

@property (nonatomic, strong) BRPlayerModel *player;

@end

@implementation BRPlayerManager

+ (id)defaultManager
{
    static BRPlayerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BRPlayerManager alloc] init];
    });
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _player = [[BRPlayerModel alloc] init];
    }
    return self;
}

- (void)addDate:(NSInteger)date
{
    self.player.date += date;
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayerDateDidChangedNotification object:nil];
}

- (NSInteger)currentDate
{
    return self.player.date;
}

- (NSString *)currentDateStr
{
    NSInteger totalDays = self.currentDate;
    NSInteger year = totalDays / 365;
    totalDays = totalDays % 365;
    
    NSInteger month = totalDays / 12;
    totalDays = totalDays % 12;
    
    NSInteger day = totalDays;
    return [NSString stringWithFormat:@"%zd年%zd月%zd日", year, month, day];
}

@end
