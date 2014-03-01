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
    
    status.data=@{@"event":place[@"objectId"]};
    
    [AVStatus sendStatusToFollowers:status andCallback:^(BOOL succeeded, NSError *error) {
        
    }];
}
@end
