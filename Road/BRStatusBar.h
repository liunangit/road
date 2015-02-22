//
//  BRStatusBar.h
//  Road
//
//  Created by liunan on 15/2/21.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _BRStatusBarType {
    BRStatusBarHorizontal,
    BRStatusBarVertical,
} BRStatusBarType;

@interface BRStatusBar : UIView

@property (nonatomic) BRStatusBarType type;

- (id)initWithType:(BRStatusBarType)type;

@end
