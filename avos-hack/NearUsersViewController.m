//
//  NearUsersViewController.m
//  avos-hack
//
//  Created by admin on 14-3-1.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "NearUsersViewController.h"
#import "HackDataManager.h"
#import "CardCell.h"
#import <AVOSCloud/AVOSCloud.h>
#import "constant.h"
@interface NearUsersViewController ()

@end

@implementation NearUsersViewController
@synthesize blurView;
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
    //[self.navigationController.navigationBar setAlpha:0.5];
    //[self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"leftArrow"]];
    //[self.navigationItem.backBarButtonItem setImage:[UIImage imageNamed:@"leftArrow"]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCV) name:NearUsersArrLoaded object:nil];
    [blurView setBlurTintColor:[UIColor colorWithWhite:0 alpha:0.2]];
}
- (void)reloadCV
{
    [self.collectionView reloadData];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [HackDataManager sharedInstance].nearUsers.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1; //1 for now.
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CardCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CardCell" forIndexPath:indexPath];
    AVUser* user = [[HackDataManager sharedInstance].nearUsers objectAtIndex:indexPath.row];
    cell.displayName.text = user[@"displayName"];
    AVFile* profilePic = user[@"profilePicture"];
    cell.profilePic.image = [UIImage imageWithData:[profilePic getData]];
    return cell;
}

@end
