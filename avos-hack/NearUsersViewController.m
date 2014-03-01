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
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"leftArrow.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    self.navigationController.title = @"附近的人";
    [[NSNotificationCenter defaultCenter] addObserver:self.collectionView selector:@selector(reloadData) name:NearUsersArrLoaded object:nil];
    //self.navigationItem
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    //[self.navigationController.navigationBar setAlpha:0.5];
    [self.navigationItem.backBarButtonItem setImage:[UIImage imageNamed:@"leftArrow"]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
    //[self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setAlpha:0.7];
    UIView* beautifulView = [[UIView alloc] initWithFrame:CGRectMake(0, 42, 320, 2)];
    [beautifulView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.9]];
    [self.navigationController.navigationBar addSubview:beautifulView];
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
