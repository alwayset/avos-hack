//
//  WallViewController.m
//  avos-hack
//
//  Created by admin on 14-3-1.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "WallViewController.h"
#import "constant.h"
#import "StatuCell.h"
#import "HackDataManager.h"
#import <AVOSCloud/AVOSCloud.h>
@interface WallViewController ()

@end

@implementation WallViewController

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
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTV) name:StatusArrLoaded object:nil];
}
- (void)reloadTV
{
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [HackDataManager sharedInstance].status.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StatuCell* cell = [tableView dequeueReusableCellWithIdentifier:@"StatuCell" forIndexPath:indexPath];
    AVStatus* statu = [[HackDataManager sharedInstance].status objectAtIndex:indexPath.row];
    AVUser* source = statu.source;
    AVFile* image = source[@"profilePicture"];
    cell.profilePic.image = [UIImage imageWithData:[image getData]];
    cell.displayNameLabel.text = source[@"displayName"];
    cell.timeLabel.text = [HackDataManager getTimeStr:[statu createdAt]];
    cell.placeLabel.text = statu.data[@"place"][@"placeName"];
    [cell setCornerRadius];
    return cell;
}
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section>0) {
        switch (indexPath.row) {
            case ROW_MAIN:{
                
                [[SlideNavigationController sharedInstance] switchToViewController:[SlideNavigationController sharedInstance].wall withCompletion:nil];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                break;
                break;
            }
            case ROW_ACTIVITY:{
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone"
                                                                         bundle: nil];
                UIViewController *vc= [mainStoryboard instantiateViewControllerWithIdentifier:@"ActivitiesCenterViewController"];
                [[SlideNavigationController sharedInstance] switchToViewController:vc withCompletion:nil];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                break;
            }
            case ROW_SETTINGS:{
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone"
                                                                         bundle: nil];
                UIViewController *vc= [mainStoryboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
                [[SlideNavigationController sharedInstance] switchToViewController:vc withCompletion:nil];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                break;
                break;
            }
            default:
                break;
        }
    }
}
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86.0;
}
@end
