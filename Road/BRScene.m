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
#import "BRStatusBar.h"
#import "BRUtils.h"
#import "BRPlayerManager.h"
#import "BRAreaView.h"

#define DEBUG_AREA_LOCALTION

@interface BRScene () <BRDialogDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) BRMapModel *mapModel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIImageView *mapImageView;
@property (nonatomic, strong) BRStatusBar *statusBar;
@property (nonatomic, weak) UIView *overlay;
@property (nonatomic, strong) NSMutableDictionary *areaViewDic; //{areaID:areaView}

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
    [self setupStatusBar];
    [self setupScene];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    
    [[BRPlayerManager defaultManager] setLocation:[mapModel.townList.firstObject area]];
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
    areaModel.areaID = areaDic[@"ID"];
    areaModel.xScale = [areaDic[@"X"] unsignedIntegerValue];
    areaModel.yScale = [areaDic[@"Y"] unsignedIntegerValue];
    areaModel.widthScale = [areaDic[@"Width"] unsignedIntegerValue];
    areaModel.heightScale = [areaDic[@"Height"] unsignedIntegerValue];
    areaModel.faction = (BRFaction)[areaDic[@"Faction"] integerValue];
    areaModel.reachable = areaDic[@"Reachable"];
    return areaModel;
}

- (void)setupStatusBar
{
    if (!self.statusBar) {
        BRStatusBarType barType;
        if ([BRUtils isPad]) {
            barType = BRStatusBarHorizontal;
        }
        else {
            barType = BRStatusBarVertical;
        }
        self.statusBar = [[BRStatusBar alloc] initWithType:barType];
        [self.view addSubview:self.statusBar];
    }
}

- (void)setupScene
{
    if (!self.mapImageView) {
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
        
    }
    
    if (self.tapGestureRecognizer) {
        [self.mapImageView removeGestureRecognizer:self.tapGestureRecognizer];
        self.tapGestureRecognizer = nil;
    }
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMap:)];
    self.tapGestureRecognizer.delegate = self;
    [self.mapImageView addGestureRecognizer:self.tapGestureRecognizer];
    
    [self refreshAreaViews];
}

- (void)refreshAreaViews
{
    if (!self.areaViewDic) {
        self.areaViewDic = [NSMutableDictionary dictionary];
    }
    
    for (BRTownModel *model in self.mapModel.townList) {
        [self refreshAreaView:model.area withMap:self.mapImageView];
    }
 
    for (BRTaskZoneModel *model in self.mapModel.taskZoneList) {
        [self refreshAreaView:model.area withMap:self.mapImageView];
    }
}

- (void)refreshAreaView:(BRAreaModel *)area withMap:(UIView *)map
{
    BRAreaView *areaView = self.areaViewDic[area.areaID];
    if (!areaView) {
        areaView = [[BRAreaView alloc] initWithMap:map];
        self.areaViewDic[area.areaID] = areaView;
        [map addSubview:areaView];
    }
    areaView.areaModel = area;
    
    BRPlayerManager *playerManager = [BRPlayerManager defaultManager];
    BRAreaModel *playerLocation = playerManager.location;
    areaView.isPlayerLocation = [playerLocation.areaID isEqualToString:area.areaID];

#ifdef DEBUG_AREA_LOCALTION
    areaView.isAreaViewVisible = YES;
#else
    areaView.isAreaViewVisible = NO;
#endif
}

- (CGRect)mapViewSizeWithImageSize:(CGSize)mapSize
{
    CGRect mapViewFrame = CGRectZero;
    if (self.statusBar.type == BRStatusBarHorizontal) {
        mapViewFrame.origin.y = kStatusBarHeight;
    }
    else {
        mapViewFrame.origin.x = kStatusBarHeight;
    }
    
    if (fabs(mapSize.width) < 1 || fabs(mapSize.height) < 1) {
        return mapViewFrame;
    }
    
    CGSize mapMaxSize = CGSizeMake(self.view.bounds.size.width - mapViewFrame.origin.x, self.view.bounds.size.height - mapViewFrame.origin.y);
    CGFloat sceneScale = mapMaxSize.width / mapMaxSize.height;
    CGFloat mapScale = mapSize.width / mapSize.height;
    
    if (sceneScale > mapScale) {
        mapViewFrame.size.height = mapMaxSize.height;
        mapViewFrame.size.width = mapViewFrame.size.height * mapScale;
        mapViewFrame.origin.x += (mapMaxSize.width - mapViewFrame.size.width) / 2;
    }
    else {
        mapViewFrame.size.width = mapMaxSize.width;
        mapViewFrame.size.height = mapSize.height / mapSize.width * mapViewFrame.size.width;
        mapViewFrame.origin.y += (mapMaxSize.height - mapViewFrame.size.height) / 2;
    }
    return mapViewFrame;
}

- (BOOL)playerCanReachableToTown:(BRTownModel *)townModel
{
    BRPlayerManager *playerManager = [BRPlayerManager defaultManager];
    BRAreaModel *playerLocation = playerManager.location;
    if (playerLocation == townModel.area) {
        return YES;
    }
    return [playerLocation rachableTo:townModel.area];
}

- (BOOL)playerCanReachableToTaskZone:(BRTaskZoneModel *)taskZoneModel
{
    BRPlayerManager *playerManager = [BRPlayerManager defaultManager];
    BRAreaModel *playerLocation = playerManager.location;
    return [playerLocation rachableTo:taskZoneModel.area];
}

- (void)onTapMap:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:sender.view];
    for (BRTownModel *townModel in self.mapModel.townList) {
        if (CGRectContainsPoint(townModel.area.rectInMap, point)) {
            if ([self playerCanReachableToTown:townModel]) {
                BRDialog *dialog = [[BRDialog alloc] init];
                dialog.delegate = self;
                dialog.townModel = townModel;
                self.overlay = dialog;
                [dialog showInView:self.view];
            }
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
            
            if ([self playerCanReachableToTaskZone:taskZone]) {
                BRSingleTaskDialog *taskDialog = [[BRSingleTaskDialog alloc] init];
                taskDialog.taskModel = taskModel;
                taskDialog.delegate = self;
                self.overlay = taskDialog;
                [taskDialog showInMap:self.mapImageView];
            }
            return;
        }
    }
}

- (void)onRemoveDialog:(UIView *)dialog
{
    if (self.overlay == dialog) {
        self.overlay = nil;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.overlay) {
        return NO;
    }
    return YES;
}

- (void)didTaskDone:(NSNotification *)notification
{
    BRTaskModel *doneModel = notification.object;
    for (BRTaskZoneModel *taskZone in self.mapModel.taskZoneList) {
        BRTaskModel *taskModel = [[BRTaskManger defaultManager] taskWithID:[taskZone.tasks firstObject]];
        if ([taskModel.taskID isEqualToString:doneModel.taskID]) {
            taskZone.area.faction = Alliance;
            [[BRPlayerManager defaultManager] setLocation:taskZone.area];
            break;
        }
    }

    [self setupScene];
}

@end
