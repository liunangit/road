//
//  ViewController.m
//  Road
//
//  Created by honey.vi on 15/2/8.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import "ViewController.h"
#import "BRScene.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    BRScene *scene = [[BRScene alloc] init];
    [scene setSceneDataFile:@"map01"];
    [self presentViewController:scene animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
