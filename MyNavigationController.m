//
//  MyNavigationController.m
//  avos-hack
//
//  Created by Eric Tao on 3/1/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import "MyNavigationController.h"

#import "HackDataManager.h"
@interface MyNavigationController ()


@end

@implementation MyNavigationController {
    NSMutableArray *_beacons;
    CLLocationManager *_locationManager;
    NSMutableArray *_rangedRegions;
    NSUUID *_uuid;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _uuid = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
	// Do any additional setup after loading the view.
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:_uuid identifier:@"avos"];
    [_locationManager startRangingBeaconsInRegion:region];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    // CoreLocation will call this delegate method at 1 Hz with updated range information.
    // Beacons will be categorized and displayed by proximity.
    _beacons = [NSMutableArray arrayWithArray:beacons];
    
        NSArray *near_arr = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityNear]];
    NSArray *far_arr = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityFar]];
    
    NSArray *unknown_arr = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityUnknown]];
    
    [_beacons removeObjectsInArray:far_arr];
    [_beacons removeObjectsInArray:unknown_arr];
    [_beacons removeObjectsInArray:near_arr];

    if (_beacons.count > 0) {
        [HackDataManager showMessageWithText:@"成功啦！"];
    }
    
    
    
    
}

@end
