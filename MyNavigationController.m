//
//  MyNavigationController.m
//  avos-hack
//
//  Created by Eric Tao on 3/1/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import "MyNavigationController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "HackDataManager.h"
#import "CheckInPopView.h"
@interface MyNavigationController ()
@property (nonatomic,retain) NSMutableArray* gotBeacons;


@property CheckInPopView *checkinView;

@end

@implementation MyNavigationController {
    NSMutableArray *_beacons;
    CLLocationManager *_locationManager;
    NSMutableArray *_rangedRegions;
    NSUUID *_uuid;
    AVObject *_place;

}
@synthesize gotBeacons;
@synthesize checkinView;
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
        //[HackDataManager showMessageWithText:@"成功啦！"];
        CLBeacon* beacon = [_beacons objectAtIndex:0];
        if (!gotBeacons || ![gotBeacons containsObject:beacon.major]) {
            if (!gotBeacons) gotBeacons = [[NSMutableArray alloc] init];
            [gotBeacons addObject:beacon.major];
            AVQuery* query = [AVQuery queryWithClassName:@"Place"];
            [query whereKey:@"majorValue" equalTo:beacon.major];
            [query includeKey:@"ad"];
            [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                if (error) {
                    
                } else {
                    _place = object;
                    [self popAd];
                    [[HackDataManager sharedInstance] checkInPlace:object];
                    [[HackDataManager sharedInstance] advertiseUserAtPlace:_place];
                }
            }];
        }
    }
}

- (void)hideCheckinView {
    [checkinView removeFromSuperview];
}

- (void)popAd {
    checkinView = [[CheckInPopView alloc] initWithFrame:CGRectMake(30, 80, 260, 400)];
    checkinView.userInteractionEnabled = YES;
    [checkinView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCheckinView)]];
    checkinView.place = _place;
    [checkinView setContent];
    checkinView.layer.cornerRadius = 8.0;
    checkinView.layer.masksToBounds = YES;
    checkinView.alpha = 0;
    [self.view addSubview:checkinView];
    [UIView animateWithDuration:0.6 animations:^{
        checkinView.alpha = 1;
    }];
    
}

@end
