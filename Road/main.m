//
//  main.m
//  Road
//
//  Created by liunan on 15/2/8.
//  Copyright (c) 2015年 liunan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

static void UncaughtExceptionHandler(NSException* exp)
{
    NSString *str = [NSString stringWithFormat:@"UncaughtExceptionHandler Exception:%@, callStackSymbols:%@", exp, [exp callStackSymbols]];
    NSString *date = [[NSDate date] description];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches/"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    path = [path stringByAppendingPathComponent:date];
    [str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

int main(int argc, char * argv[]) {
    
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
