//
//  BRSingleTaskDialog.h
//  Road
//
//  Created by liunan on 15/2/19.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRDialog.h"

@class BRTaskModel;
@class BRSingleTaskDialog;


@interface BRSingleTaskDialog : UIView

@property (nonatomic, strong) BRTaskModel *taskModel;
@property (nonatomic, weak) id<BRDialogDelegate> delegate;

- (void)showInDialog:(BRDialog *)dialog;
- (void)showInMap:(UIView *)mapView;
- (void)hide;

@end
