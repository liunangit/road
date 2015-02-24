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

//#define DEBUG_AREA_LOCALTION

@interface BRScene () <BRDialogDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) BRMapModel *mapModel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIImageView *mapImageView;
@property (nonatomic, strong) BRStatusBar *statusBar;
@property (nonatomic, weak) UIView *overlay;

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
    UIImageView *factionImageView = [[UIImageView alloc] initWithFrame:CGRectMake((area.rectInMap.size.width - factionSize)/2 + area.rectInMap.origin.x, (area.rectInMap.size.height- factionSize)/2 + area.rectInMap.origin.y, factionSize, factionSize)];
    factionImageView.alpha = 0.8f;
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

- (void)onTapMap:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:sender.view];
    for (BRTownModel *townModel in self.mapModel.townList) {
        if (CGRectContainsPoint(townModel.area.rectInMap, point)) {
            BRDialog *dialog = [[BRDialog alloc] init];
            dialog.delegate = self;
            dialog.townModel = townModel;
            self.overlay = dialog;
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
            taskDialog.delegate = self;
            self.overlay = taskDialog;
            [taskDialog showInMap:self.mapImageView];
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
            break;
        }
    }

    [self setupScene];
}

@end
