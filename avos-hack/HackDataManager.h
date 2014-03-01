//
//  HackDataManager.h
//  avos-hack
//
//  Created by admin on 14-3-1.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
@interface HackDataManager : NSObject
@property (nonatomic,retain) NSMutableArray* nearUsers;

- (void)loadNearUsersArr;
+ (HackDataManager *)sharedInstance;
+ (void)initialize;

+ (void)showAlertWithText:(NSString *)text;
+ (void)showMessageWithText:(NSString *)text;
- (void)checkInPlace:(AVObject*)place;
@end
