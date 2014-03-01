//
//  HackDataManager.h
//  avos-hack
//
//  Created by admin on 14-3-1.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HackDataManager : NSObject
+ (HackDataManager *)sharedInstance;
+ (void)initialize;

+ (void)showAlertWithText:(NSString *)text;
+ (void)showMessageWithText:(NSString *)text;
@end
