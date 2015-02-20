//
//  BRSingleTaskDialog.h
//  Road
//
//  Created by honey.vi on 15/2/19.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRTaskModel;
@class BRDialog;
@class BRSingleTaskDialog;

@protocol BRSingleTaskDialogDelegate <NSObject>

@optional
- (void)onRemoveSingleTaskDialog:(BRSingleTaskDialog *)taskDialog;

@end

@interface BRSingleTaskDialog : UIView

@property (nonatomic, strong) BRTaskModel *taskModel;
@property (nonatomic, weak) id<BRSingleTaskDialogDelegate> delegate;

- (void)showInDialog:(BRDialog *)dialog;
- (void)hide;

@end
