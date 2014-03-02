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
@synthesize cardView;
@synthesize displayNameLabel;
@synthesize profilePicture;
@synthesize followButton;
@synthesize phoneNumberLabel;
@synthesize emailLabel;
@synthesize companyLabel;
@synthesize addressLabel;
@synthesize wechatLabel;
@synthesize selectedUser;
//@synthesize blur;
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
    [cardView.layer setMasksToBounds:YES];
    [cardView.layer setCornerRadius:10];
    [cardView removeFromSuperview];
    [cardView setFrame:CGRectMake(35, 120, 250, 277)];
    [cardView setAlpha:0];
    
//    [blur removeFromSuperview];
//    [blur setFrame:CGRectMake(35, 120, 250, 277)];
//    [blur setAlpha:0];
    
    
    [profilePicture.layer setCornerRadius:(profilePicture.frame.size.height/2)];
    [profilePicture.layer setMasksToBounds:YES];
    profilePicture.layer.borderColor = [[UIColor whiteColor] CGColor];
    profilePicture.layer.borderWidth = 2.0f;
    
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
- (void)showCard
{
    [self.view addSubview:cardView];
    
    [UIView animateWithDuration:0.5 animations:^{
        [cardView setFrame:CGRectMake(35, 140, 250, 277)];
        [cardView setAlpha:1];
        
    } completion:^(BOOL finished) {
        
//        [blur setFrame:CGRectMake(35, 140, 250, 277)];
//        [blur setAlpha:1];
 //       [self.view addSubview:blur];
    }];
}
- (IBAction)closeClicked:(id)sender {
    [self hideCard];
}
- (void)hideCard
{
//    [blur setFrame:CGRectMake(35, 120, 250, 277)];
//    [blur setAlpha:0];
//    [blur removeFromSuperview];
    [UIView animateWithDuration:0.5
                     animations:^{
                         [cardView setFrame:CGRectMake(35, 120, 250, 277)];
                         [cardView setAlpha:0];
                         
                     } completion:^(BOOL finished) {
                         [cardView removeFromSuperview];
                         
                     }];
}
- (IBAction)followClicked:(id)sender {
    [[AVUser currentUser] follow:selectedUser.objectId andCallback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [HackDataManager showMessageWithText:@"关注成功"];
        } else {
            if (error.code==kAVErrorDuplicateValue) {
                [[AVUser currentUser] unfollow:selectedUser.objectId andCallback:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [HackDataManager showMessageWithText:@"已取消关注"];
                    }
                }];
                
            } else [HackDataManager showMessageWithText:error.description];
        }
        
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AVUser* user = [[HackDataManager sharedInstance].nearUsers objectAtIndex:indexPath.row];
    AVFile* file = user[@"profilePicture"];
    profilePicture.image = [UIImage imageWithData:[file getData]];
    displayNameLabel.text = user[@"displayName"];
    phoneNumberLabel.text = user[@"phoneNumber"];
    companyLabel.text = user[@"company"];
    emailLabel.text = user[@"myEmail"];
    addressLabel.text = user[@"address"];
    wechatLabel.text = user[@"wechat"];
    selectedUser = user;
    [self showCard];
    
    /*
    AVUser* user = [[HackDataManager sharedInstance].nearUsers objectAtIndex:indexPath.row];
    [[AVUser currentUser] follow:user.objectId andCallback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [HackDataManager showMessageWithText:@"关注成功"];
        } else {
            if (error.code==kAVErrorDuplicateValue) {
                //重复关注
            }
        }
        
    }];
     */
}

@end
