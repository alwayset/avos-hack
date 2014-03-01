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
#import <CoreBluetooth/CoreBluetooth.h>

@implementation HackDataManager
static HackDataManager *singletonInstance;


+ (void)initialize {
    if (singletonInstance == nil) {
        singletonInstance = [[HackDataManager alloc] init];
        singletonInstance.peripheralManager = [[CBPeripheralManager alloc] init];
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

- (void)advertiseUserAtPlace:(AVObject *)place {
    NSNumber *majorValue = place[@"majorValue"];
    NSNumber *minorValue = [AVUser currentUser][@"minorValue"];
    CLBeaconRegion *userBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"] major:majorValue.integerValue minor:minorValue.integerValue identifier:@"users"];
    NSDictionary *peripheralData = [userBeaconRegion peripheralDataWithMeasuredPower:@-59];
    [self.peripheralManager startAdvertising:peripheralData];
}

- (void)stopAdvertise {
    [self.peripheralManager stopAdvertising];
}

@end
