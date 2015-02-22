//
//  BRStatusBar.m
//  Road
//
//  Created by liunan on 15/2/21.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "BRStatusBar.h"
#import "BRPublishHeader.h"
#import "BRPlayerManager.h"
#import "BRUtils.h"

@interface BRStatusBar ()

@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation BRStatusBar

- (id)initWithType:(BRStatusBarType)type
{
    self = [super init];
    if (self) {
        CGRect frame = CGRectZero;
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _type = type;
        
        if (type == BRStatusBarHorizontal) {
            frame.size.width = screenSize.width;
            frame.size.height = kStatusBarHeight;
        }
        else {
            frame.size.width = kStatusBarHeight;
            frame.size.height = screenSize.height;
        }
        self.frame = frame;
        self.backgroundColor = [UIColor blackColor];
        
        UIFont *font = nil;
        if ([BRUtils isPad]) {
            font = [UIFont systemFontOfSize:14];
        }
        else {
            font = [UIFont systemFontOfSize:10];
        }
        
        UILabel *dateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        dateTitleLabel.text = @"时间:";
        dateTitleLabel.textAlignment = NSTextAlignmentCenter;
        dateTitleLabel.textColor = [UIColor whiteColor];
        dateTitleLabel.backgroundColor = [UIColor blackColor];
        dateTitleLabel.font = font;
        [self addSubview:dateTitleLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.backgroundColor = [UIColor blackColor];
        _dateLabel.text = [[BRPlayerManager defaultManager] currentDateStr];
        _dateLabel.font = font;
        [self addSubview:_dateLabel];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDateChanged:) name:kPlayerDateDidChangedNotification object:nil];
        
        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
        settingBtn.titleLabel.font = font;
        [self addSubview:settingBtn];
        
        if (_type == BRStatusBarHorizontal) {
            dateTitleLabel.frame = CGRectMake(20, 10, self.bounds.size.height, self.bounds.size.height);
            _dateLabel.frame = CGRectMake(dateTitleLabel.frame.origin.x + dateTitleLabel.frame.size.width, dateTitleLabel.frame.origin.y, self.bounds.size.height * 2, self.bounds.size.height);
            settingBtn.frame = CGRectMake(self.bounds.size.width - self.bounds.size.height - 20, dateTitleLabel.frame.origin.y, self.bounds.size.height, self.bounds.size.height);
        }
        else {
            dateTitleLabel.frame = CGRectMake(0, 20, self.bounds.size.width, 30);
            _dateLabel.frame = CGRectMake(0, dateTitleLabel.frame.origin.y + dateTitleLabel.frame.size.height, self.bounds.size.width, 30);
            _dateLabel.textAlignment = NSTextAlignmentCenter;
            settingBtn.frame = CGRectMake(0, self.bounds.size.height - self.bounds.size.width - 20, self.bounds.size.width, self.bounds.size.width);
        }
    }
    return self;
}

- (void)playerDateChanged:(NSNotification *)notification
{
    _dateLabel.text = [[BRPlayerManager defaultManager] currentDateStr];
}

@end
