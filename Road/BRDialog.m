//
//  BRDialog.m
//  Road
//
//  Created by liunan on 15/2/8.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "BRDialog.h"
#import "BRTaskModel.h"
#import "BRTaskManger.h"
#import "BRSingleTaskDialog.h"

@interface BRDialog () <UITableViewDataSource, UITableViewDelegate, BRDialogDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) BRSingleTaskDialog *singleTaskDialog;

@end

@implementation BRDialog

- (void)showInView:(UIView *)view
{
    if (!view) {
        return;
    }
    
    if (self.tableView) {
        [self removeFromSuperview];
    }
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75f];
    self.frame = view.bounds;
    CGFloat tableWidth = 300;
    CGFloat tableHeight = 200;
    CGRect tableViewFrame = CGRectMake((view.bounds.size.width - tableWidth) / 2, (view.bounds.size.height - tableHeight) / 2, tableWidth, tableHeight);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    [view addSubview:self];
    self.containerView = view;
}

- (void)hide
{
    if ([self.delegate respondsToSelector:@selector(onRemoveDialog:)]) {
        [self.delegate onRemoveDialog:self];
    }
    
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [self removeFromSuperview];
    self.containerView = nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor blackColor];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.townModel.taskList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.text = self.townModel.townName;
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"taskCell"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor blackColor];
    }
    
    NSString *taskID = self.townModel.taskList[indexPath.row];
    BRTaskModel *taskModel = [[BRTaskManger defaultManager] taskWithID:taskID];
    NSString *cellText = nil;
    
    if (taskModel.status == BRTaskStatus_New) {
        cellText = taskModel.title;
    }
    else if (taskModel.status == BRTAskStatus_Accept) {
        cellText = [NSString stringWithFormat:@"%@(已接受)", taskModel.title];
    }
    else {
        cellText = [NSString stringWithFormat:@"%@(已完成)", taskModel.title];
    }
    
    cell.textLabel.text = cellText;
    
//    if (taskModel.status == BRTaskStatus_Finished) {
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    else {
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *taskID = self.townModel.taskList[indexPath.row];
    BRTaskModel *taskModel = [[BRTaskManger defaultManager] taskWithID:taskID];
    BRSingleTaskDialog *taskDialog = [[BRSingleTaskDialog alloc] init];
    taskDialog.taskModel = taskModel;
    [taskDialog showInDialog:self];
    self.singleTaskDialog = taskDialog;
    taskDialog.delegate = self;
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.singleTaskDialog) {
        [self hide];
    }
}

- (void)onRemoveDialog:(BRSingleTaskDialog *)taskDialog
{
    self.singleTaskDialog = nil;
    [self.tableView reloadData];
}

@end
