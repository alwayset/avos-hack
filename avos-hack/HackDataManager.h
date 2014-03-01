//
//  HackDataManager.h
//  avos-hack
//
//  Created by admin on 14-3-1.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface HackDataManager : NSObject
@property (nonatomic,retain) NSMutableArray* nearUsers;
@property CBPeripheralManager *peripheralManager;

- (void)loadNearUsersArr;
+ (HackDataManager *)sharedInstance;
+ (void)initialize;

+ (void)showAlertWithText:(NSString *)text;
+ (void)showMessageWithText:(NSString *)text;
- (void)checkInPlace:(AVObject*)place;


- (void)advertiseUserAtPlace:(AVObject *)place;
- (void)stopAdvertise;
@end
