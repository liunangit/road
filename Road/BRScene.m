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
#import "BRTaskZoneModel.h"
#import "BRSingleTaskDialog.h"
#import "BRPublishHeader.h"

#define DEBUG_AREA_LOCALTION

@interface BRScene ()

@property (nonatomic, strong) BRMapModel *mapModel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIImageView *mapImageView;

@end

@implementation BRScene

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTaskDone:) name:kTaskDoneNotification object:nil];
    }
    return self;
}

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
    mapModel.taskZoneList = [self parseTaskZones:mapData[@"TaskZones"]];
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

- (NSArray *)parseTaskZones:(NSArray *)taskZoneList
{
    if (taskZoneList.count == 0) {
        return nil;
    }
    
    NSMutableArray *zones = [NSMutableArray arrayWithCapacity:taskZoneList.count];
    for (NSDictionary *zone in taskZoneList) {
        BRTaskZoneModel *taskZone = [[BRTaskZoneModel alloc] init];
        taskZone.area = [self parseAraeMode:zone[@"Area"]];
        taskZone.zoneID = zone[@"ZoneID"];
        taskZone.zoneName = zone[@"ZoneName"];
        taskZone.tasks = zone[@"Tasks"];
        [zones addObject:taskZone];
    }
    
    return zones;
}

- (BRAreaModel *)parseAraeMode:(NSDictionary *)areaDic
{
    if (areaDic.count == 0) {
        return nil;
    }
    
    BRAreaModel *areaModel = [[BRAreaModel alloc] init];
    areaModel.xScale = [areaDic[@"X"] unsignedIntegerValue];
    areaModel.yScale = [areaDic[@"Y"] unsignedIntegerValue];
    areaModel.widthScale = [areaDic[@"Width"] unsignedIntegerValue];
    areaModel.heightScale = [areaDic[@"Height"] unsignedIntegerValue];
    areaModel.faction = (BRFaction)[areaDic[@"Faction"] integerValue];
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
    [self refreshFactions];
  }

- (void)refreshFactions
{
    for (BRTownModel *model in self.mapModel.townList) {
#ifdef DEBUG_AREA_LOCALTION
        UIView *v = [[UIView alloc] initWithFrame:model.area.rectInMap];
        v.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f];
        [self.mapImageView addSubview:v];
#endif
        [self setupFactionWithArea:model.area inMap:self.mapImageView];
    }
 
    for (BRTaskZoneModel *model in self.mapModel.taskZoneList) {
#ifdef DEBUG_AREA_LOCALTION
        UIView *v = [[UIView alloc] initWithFrame:model.area.rectInMap];
        v.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f];
        [self.mapImageView addSubview:v];
#endif
        [self setupFactionWithArea:model.area inMap:self.mapImageView];
    }
}

- (void)setupFactionWithArea:(BRAreaModel *)area inMap:(UIView *)map
{
    static CGFloat factionSize = 30.0f;
    UIImageView *factionImageView = [[UIImageView alloc] initWithFrame:CGRectMake((area.rectInMap.size.width - factionSize)/2 + area.rectInMap.origin.x, area.rectInMap.origin.y, factionSize, factionSize)];
    factionImageView.alpha = 0.5f;
    NSString *imageName = nil;
    
    switch (area.faction) {
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
    factionImageView.image = [UIImage imageNamed:imageName];
    [map addSubview:factionImageView];
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
            return;
        }
    }
    
    for (BRTaskZoneModel *taskZone in self.mapModel.taskZoneList) {
        if (CGRectContainsPoint(taskZone.area.rectInMap, point)) {
            BRTaskModel *taskModel = [[BRTaskManger defaultManager] taskWithID:[taskZone.tasks firstObject]];
            if (taskModel.status == BRTaskStatus_Done ||
                taskModel.status == BRTaskStatus_Finished) {
                return;
            }
            BRSingleTaskDialog *taskDialog = [[BRSingleTaskDialog alloc] init];
            taskDialog.taskModel = taskModel;
            [taskDialog showInMap:self.mapImageView];
            return;
        }
    }
}

- (void)didTaskDone:(NSNotification *)notification
{
    BRTaskModel *doneModel = notification.object;
    for (BRTaskZoneModel *taskZone in self.mapModel.taskZoneList) {
        BRTaskModel *taskModel = [[BRTaskManger defaultManager] taskWithID:[taskZone.tasks firstObject]];
        if ([taskModel.taskID isEqualToString:doneModel.taskID]) {
            taskZone.area.faction = Alliance;
            break;
        }
    }

    [self setupScene];
}

@end
