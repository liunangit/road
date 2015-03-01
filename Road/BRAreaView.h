//
//  BRAreaView.h
//  Road
//
//  Created by honey.vi on 15/3/1.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRAreaModel.h"

@interface BRAreaView : UIView

@property (nonatomic) BRAreaModel *areaModel;
@property (nonatomic) BOOL isPlayerLocation;
@property (nonatomic) BOOL isAreaViewVisible;

- (id)initWithMap:(UIView *)mapView;

@end
