//
//  BRAreaView.m
//  Road
//
//  Created by honey.vi on 15/3/1.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "BRAreaView.h"

@interface BRAreaView ()

@property (nonatomic, strong) UIImageView *factionImageView;
@property (nonatomic, strong) UIImageView *playerView;
@property (nonatomic, weak) UIView *mapView;
@property (nonatomic, strong) UILabel *areaIDLabel;

@end

@implementation BRAreaView

- (id)initWithMap:(UIView *)mapView
{
    self = [super init];
    if (self) {
        _mapView = mapView;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setAreaModel:(BRAreaModel *)areaModel
{
    _areaModel = areaModel;
    self.frame = areaModel.rectInMap;
    
    if (!self.factionImageView) {
        static CGFloat size = 30;
        self.factionImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.factionImageView.frame = CGRectMake((self.bounds.size.width - size)/2, (self.bounds.size.height - size)/2, size, size);
        self.factionImageView.alpha = 0.8f;
        [self insertSubview:self.factionImageView atIndex:0];
    }
    
    NSString *imageName = nil;
    switch (areaModel.faction) {
        case Horde:
            imageName = @"horde.png";
            break;
        case Alliance:
            imageName = @"alliance.png";
            break;
        default:
            imageName = @"neutral.png";
            break;
    }
    self.factionImageView.image = [UIImage imageNamed:imageName];
}

- (void)setIsPlayerLocation:(BOOL)isPlayerLocation
{
    _isPlayerLocation = isPlayerLocation;
    
    if (isPlayerLocation) {
        if (!self.playerView) {
            static CGFloat playerSize = 10.0f;
            self.playerView = [[UIImageView alloc] init];
            self.playerView.frame = CGRectMake((self.bounds.size.width - playerSize) / 2, (self.bounds.size.height - playerSize) / 2, playerSize, playerSize);
            self.playerView.backgroundColor = [UIColor redColor];
            [self addSubview:self.playerView];
            [self bringSubviewToFront:self.playerView];
        }
        self.playerView.hidden = NO;
    }
    else {
        self.playerView.hidden = YES;
    }
}

- (void)setIsAreaViewVisible:(BOOL)isAreaViewVisible
{
    if (isAreaViewVisible) {
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.75f];
        if (!self.areaIDLabel) {
            self.areaIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
            [self addSubview:self.areaIDLabel];
        }
        self.areaIDLabel.text = self.areaModel.areaID;
        self.areaIDLabel.hidden = NO;
    }
    else {
        self.backgroundColor = [UIColor clearColor];
        self.areaIDLabel.hidden = YES;
    }
}

@end
