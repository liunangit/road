//
//  BRSingleTaskDialog.m
//  Road
//
//  Created by honey.vi on 15/2/19.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "BRSingleTaskDialog.h"
#import "BRTaskModel.h"
#import "BRDialog.h"

@interface BRSingleTaskDialog ()

@property (nonatomic, strong) UIView *containerView;

@end

@implementation BRSingleTaskDialog

- (void)showInDialog:(BRDialog *)dialog
{
    self.frame = dialog.bounds;
    CGFloat containerWidth = 300;
    CGFloat containerHeight = 200;
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake((dialog.bounds.size.width - containerWidth)/2, (dialog.bounds.size.height - containerHeight)/2, containerWidth, containerHeight)];
    containerView.backgroundColor = [UIColor blackColor];
    [self addSubview:containerView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containerWidth, 30)];
    titleLabel.backgroundColor = [UIColor blackColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.taskModel.title;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview:titleLabel];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, titleLabel.bounds.size.height, containerWidth, 150)];
    textView.backgroundColor = [UIColor blackColor];
    textView.textColor = [UIColor whiteColor];
    textView.text = self.taskModel.content;
    textView.font = [UIFont systemFontOfSize:15];
    textView.editable = NO;
    textView.selectable = NO;
    [containerView addSubview:textView];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *okBtnTitle = nil;
    switch (self.taskModel.status) {
        case BRTAskStatus_Accept:
        case BRTaskStatus_Done:
            okBtnTitle = @"完成";
            break;
        case BRTaskStatus_Finished:
            okBtnTitle = @"已完成";
            break;
        default:
            okBtnTitle = @"接受";
            break;
    }
    [okBtn setTitle:okBtnTitle forState:UIControlStateNormal];
    if (self.taskModel.status == BRTAskStatus_Accept ||
        self.taskModel.status == BRTaskStatus_Finished) {
        okBtn.enabled = NO;
    }
    [okBtn addTarget:self action:@selector(okAct) forControlEvents:UIControlEventTouchUpInside];
    okBtn.frame = CGRectMake(0, containerHeight - 20, containerWidth/2, 20);
    [okBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [containerView addSubview:okBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(okBtn.frame.size.width, okBtn.frame.origin.y, containerWidth/2, okBtn.frame.size.height);
    [containerView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelAct) forControlEvents:UIControlEventTouchUpInside];
    
    [dialog addSubview:self];
}

- (void)cancelAct
{
    [self hide];
}

- (void)okAct
{
    if (self.taskModel.status == BRTaskStatus_New) {
        self.taskModel.status = BRTAskStatus_Accept;
    }
    else if (self.taskModel.status == BRTaskStatus_Done) {
        self.taskModel.status = BRTaskStatus_Finished;
    }
    [self hide];
}

- (void)hide
{
    if ([self.delegate respondsToSelector:@selector(onRemoveSingleTaskDialog:)]) {
        [self.delegate onRemoveSingleTaskDialog:self];
    }
    [self removeFromSuperview];
}

@end
