//
//  HackDataManager.m
//  avos-hack
//
//  Created by admin on 14-3-1.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "HackDataManager.h"
#import <AVOSCloud/AVOSCloud.h>
#import "constant.h"

@implementation HackDataManager
static HackDataManager *singletonInstance;


+ (void)initialize {
    if (singletonInstance == nil) {
        singletonInstance = [[HackDataManager alloc] init];
        singletonInstance.peripheralManager =   [[CBPeripheralManager alloc] initWithDelegate:(id)singletonInstance queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        singletonInstance.peripheralManager.delegate = singletonInstance;
    }
    
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    
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
- (void)loadNearUsersArr
{
    AVQuery* query = [AVQuery queryWithClassName:@"_User"];
    [query includeKey:@"profilePicture"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.nearUsers = [NSMutableArray arrayWithArray:objects];
            [[NSNotificationCenter defaultCenter] postNotificationName:NearUsersArrLoaded object:nil];
        }
    }];
}

- (void)sendStatuAtPlace:(AVObject*) place
{
    AVStatus *status=[[AVStatus alloc] init];
    
    status.data=@{@"place":place};
    status.type = kAVStatusTypeTimeline;
    
    [AVStatus sendStatusToFollowers:status andCallback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
//            [HackDataManager showMessageWithText:[NSString stringWithFormat:@"成功在%@签到！",place[@"placeName"]]];
        }
    }];
}
- (void)checkInPlace:(AVObject *)place
{
    //写place的user Relation
    [self sendStatuAtPlace:place];
    
}

- (void)addToPlace:(AVObject *)place {
    AVRelation *relation = [place relationforKey:@"nearbyUsers"];
    [relation addObject:[AVUser currentUser]];
    [place saveInBackground];
}

- (void)removeFromPlace:(AVObject *)place {
    AVRelation *relation = [place relationforKey:@"nearbyUsers"];
    [relation removeObject:[AVUser currentUser]];
    [place saveInBackground];
}


- (void)advertiseUserAtPlace:(AVObject *)place {
    NSNumber *majorValue = place[@"majorValue"];
    NSNumber *minorValue = [AVUser currentUser][@"minorValue"];
//    CLBeaconRegion *userBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"] major:majorValue.integerValue minor:minorValue.integerValue identifier:@"users"];
    CLBeaconRegion *userBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"] identifier:@"999"];
    NSDictionary *peripheralData = [userBeaconRegion peripheralDataWithMeasuredPower:nil];
    [self.peripheralManager startAdvertising:peripheralData];
}

- (void)stopAdvertise {
    [self.peripheralManager stopAdvertising];
}

- (void)loadStatusArr
{
    AVStatusQuery *query=[AVStatus inboxQuery:kAVStatusTypeTimeline];
    
    //限制50条
    //query.limit=50;
    
    //限制1397这个messageId以前的, 如果不设置,默认为最新的
    //query.maxId=1397;
    
    //需要同时附带发送者的数据
    [query includeKey:@"source"];
    [query includeKey:@"place"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            
        } else {
            self.status = [NSMutableArray arrayWithArray:objects];
            [[NSNotificationCenter defaultCenter] postNotificationName:StatusArrLoaded object:nil];
        }
    }];
}

+ (NSString*)getTimeStr:(NSDate*) time {
    NSTimeInterval interval = -[time timeIntervalSinceNow];
    int minutes = interval/60;
    int hours = minutes/60;
    int days = hours/24;
    int months = days/30;
    int years = months/12;
    if (years>0) return [NSString stringWithFormat:@"%d年前",years];
    if (months>0) return [NSString stringWithFormat:@"%d个月前",months];
    if (days>0) return [NSString stringWithFormat:@"%d天前",days];
    if (hours>0) return [NSString stringWithFormat:@"%d小时前",hours];
    if (minutes>0) return [NSString stringWithFormat:@"%d分钟前",minutes];
    return @"刚刚";
}
@end
