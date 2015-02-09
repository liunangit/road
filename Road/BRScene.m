//
//  BRScene.m
//  Road
//
//  Created by liunan on 15/2/8.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "BRScene.h"
#import "BRMapModel.h"
#import "BRDialog.h"
#import "BRTaskManger.h"
#import "BRAreaModel.h"

#define DEBUG_TOWN_LOCALTION

@interface BRScene ()

@property (nonatomic, strong) BRMapModel *mapModel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIImageView *mapImageView;

@end

@implementation BRScene

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupScene];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setSceneDataFile:(NSString *)dataFile
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:dataFile ofType:@"plist"];
    NSDictionary *mapData = [NSDictionary dictionaryWithContentsOfFile:filePath];
    self.mapModel = [self parseMapData:mapData];
}

- (BRMapModel *)parseMapData:(NSDictionary *)mapData
{
    if (mapData.count == 0) {
        return nil;
    }
    
    BRMapModel *mapModel = [[BRMapModel alloc] init];
    mapModel.mapName = mapData[@"MapName"];
    mapModel.mapFile = mapData[@"Map"];
    mapModel.townList = [self parseTownModel:mapData[@"Towns"]];
    return mapModel;
}

- (NSArray *)parseTownModel:(NSArray *)townList
{
    if (townList.count == 0) {
        return nil;
    }
    
    NSMutableArray *townModelList = [NSMutableArray arrayWithCapacity:townList.count];
    for (NSDictionary *town in townList) {
        BRTownModel *townModel = [[BRTownModel alloc] init];
        townModel.townID = town[@"TownID"];
        townModel.townName = town[@"TownName"];
        townModel.taskList = town[@"Tasks"];
        townModel.area = [self parseAraeMode:town[@"Area"]];
        [townModelList addObject:townModel];
    }
    
    return townModelList;
}

- (BRAreaModel *)parseAraeMode:(NSDictionary *)areDic
{
    if (areDic.count == 0) {
        return nil;
    }
    
    BRAreaModel *areaModel = [[BRAreaModel alloc] init];
    areaModel.xScale = [areDic[@"X"] unsignedIntegerValue];
    areaModel.yScale = [areDic[@"Y"] unsignedIntegerValue];
    areaModel.widthScale = [areDic[@"Width"] unsignedIntegerValue];
    areaModel.heightScale = [areDic[@"Height"] unsignedIntegerValue];
    return areaModel;
}

- (void)setupScene
{
    if (self.mapImageView) {
        [self.mapImageView removeFromSuperview];
        self.mapImageView = nil;
    }
    
    UIImage *mapImage = [UIImage imageNamed:self.mapModel.mapFile];
    if (!mapImage) {
        return;
    }
    
    CGRect mapImageViewRect = [self mapViewSizeWithImageSize:mapImage.size];
    self.mapImageView = [[UIImageView alloc] initWithFrame:mapImageViewRect];
    self.mapImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.mapImageView];
    
    self.mapImageView.image = mapImage;
    self.mapModel.mapSize = self.mapImageView.bounds.size;
    
    if (self.tapGestureRecognizer) {
        [self.mapImageView removeGestureRecognizer:self.tapGestureRecognizer];
        self.tapGestureRecognizer = nil;
    }
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMap:)];
    [self.mapImageView addGestureRecognizer:self.tapGestureRecognizer];
    
#ifdef DEBUG_TOWN_LOCALTION
    for (BRTownModel *model in self.mapModel.townList) {
        UIView *v = [[UIView alloc] initWithFrame:model.area.rectInMap];
        v.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f];
        [self.mapImageView addSubview:v];
    }
#endif
}

- (CGRect)mapViewSizeWithImageSize:(CGSize)mapSize
{
    if (fabs(mapSize.width) < 1 || fabs(mapSize.height) < 1) {
        return CGRectZero;
    }
    
    CGSize sceneSize = self.view.bounds.size;
    CGFloat sceneScale = sceneSize.width / sceneSize.height;
    CGFloat mapScale = mapSize.width / mapSize.height;
    CGRect rect = CGRectZero;
    
    if (sceneScale > mapScale) {
        rect.origin.y = 0;
        rect.size.height = sceneSize.height;
        rect.size.width = rect.size.height * mapScale;
        rect.origin.x = (sceneSize.width - rect.size.width) / 2;
    }
    else {
        rect.origin.x = 0;
        rect.size.width = sceneSize.width;
        rect.size.height = mapSize.height / mapSize.width * rect.size.width;
        rect.origin.y = (sceneSize.height - rect.size.height) / 2;
    }
    return rect;
}

- (void)onTapMap:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:sender.view];
    for (BRTownModel *townModel in self.mapModel.townList) {
        if (CGRectContainsPoint(townModel.area.rectInMap, point)) {
            BRDialog *dialog = [[BRDialog alloc] init];
            dialog.townModel = townModel;
            [dialog showInView:self.view];
            break;
        }
    }
}

@end
