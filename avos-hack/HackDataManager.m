//
//  HackDataManager.m
//  avos-hack
//
//  Created by admin on 14-3-1.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "HackDataManager.h"

@implementation HackDataManager
static HackDataManager *singletonInstance;

+ (void)initialize {
    if (singletonInstance == nil) {
        singletonInstance = [[HackDataManager alloc] init];
    }
    
}

+ (HackDataManager *)sharedInstance {
    return singletonInstance;
}

+ (void)showAlertWithText:(NSString *)text {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:text message:@"是不是网断了?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

+ (void)showMessageWithText:(NSString *)text {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:text delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
@end
