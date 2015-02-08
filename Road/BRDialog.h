//
//  BRDialog.h
//  Road
//
//  Created by liunan on 15/2/8.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRTownModel.h"

@interface BRDialog : UIView

@property (nonatomic, strong) BRTownModel *townModel;

- (void)showInView:(UIView *)view;
- (void)hide;

@end
