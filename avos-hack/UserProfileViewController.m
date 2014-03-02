//
//  UserProfileViewController.m
//  avos-hack
//
//  Created by admin on 14-3-2.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "UserProfileViewController.h"
#import "HackDataManager.h"
#import <AVOSCloud/AVOSCloud.h>
#import "InfoSettingCell.h"
#import "StatuCell.h"
#import "constant.h"
@interface UserProfileViewController ()

@end

@implementation UserProfileViewController
@synthesize displayNameLabel;
@synthesize profilePicture;
@synthesize phoneCell;
@synthesize emailCell;
@synthesize companyCell;
@synthesize wechatCell;
@synthesize addressCell;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadStatus) name:MyStatusArrLoaded object:nil];
}
- (void)reloadStatus
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)reloadHead
{
    displayNameLabel.text = [AVUser currentUser][@"displayName"];
    AVFile* image = [AVUser currentUser][@"profilePicture"];
    profilePicture.image = [UIImage imageWithData:[image getData]];
    [profilePicture.layer setCornerRadius:(profilePicture.frame.size.height/2)];
    [profilePicture.layer setMasksToBounds:YES];
    profilePicture.layer.borderColor = [[UIColor whiteColor] CGColor];
    profilePicture.layer.borderWidth = 2.0f;
    profilePicture.userInteractionEnabled = YES;

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadHead];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)save:(id)sender {
    AVUser* myself = [AVUser currentUser];
    [myself setObject:phoneCell.textField.text forKey:@"phoneNumber"];
    [myself setObject:addressCell.textField.text forKey:@"address"];
    [myself setObject:emailCell.textField.text forKey:@"myEmail"];
    [myself setObject:companyCell.textField.text forKey:@"company"];
    [myself setObject:wechatCell.textField.text forKey:@"wechat"];
    [myself saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [HackDataManager showMessageWithText:@"保存成功"];
        } else {
            [HackDataManager showAlertWithText:@"保存失败"];
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 ) return 5;
    return [HackDataManager sharedInstance].myStatus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                if (!phoneCell) {
                    phoneCell = [tableView dequeueReusableCellWithIdentifier:@"InfoSettingCell" forIndexPath:indexPath];
                    phoneCell.label.text = @"电话";
                    phoneCell.textField.text = [AVUser currentUser][@"phoneNumber"];
                    [phoneCell setCornerRadius];
                    phoneCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                return phoneCell;
                break;
            case 1:
                if (!emailCell) {
                    emailCell = [tableView dequeueReusableCellWithIdentifier:@"InfoSettingCell" forIndexPath:indexPath];
                    emailCell.label.text = @"邮箱";
                    emailCell.textField.text = [AVUser currentUser][@"myEmail"];
                    [emailCell setCornerRadius];
                    emailCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                return emailCell;
                break;
            case 2:
                if (!addressCell) {
                    addressCell = [tableView dequeueReusableCellWithIdentifier:@"InfoSettingCell" forIndexPath:indexPath];
                    addressCell.label.text = @"地址";
                    addressCell.textField.text = [AVUser currentUser][@"address"];
                    [addressCell setCornerRadius];
                    addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                return addressCell;
                break;
            case 3:
                if (!companyCell) {
                    companyCell = [tableView dequeueReusableCellWithIdentifier:@"InfoSettingCell" forIndexPath:indexPath];
                    companyCell.label.text = @"公司";
                    companyCell.textField.text = [AVUser currentUser][@"company"];
                    [companyCell setCornerRadius];
                    companyCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                return companyCell;
                break;
            case 4:
                if (!wechatCell) {
                    wechatCell = [tableView dequeueReusableCellWithIdentifier:@"InfoSettingCell" forIndexPath:indexPath];
                    wechatCell.label.text = @"微信";
                    wechatCell.textField.text = [AVUser currentUser][@"wechat"];
                    [wechatCell setCornerRadius];
                    wechatCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                return wechatCell;
                break;
            default:
                break;
        }
    } else {
        StatuCell* cell = [tableView dequeueReusableCellWithIdentifier:@"StatuCell" forIndexPath:indexPath];
        AVStatus* statu = [[HackDataManager sharedInstance].myStatus objectAtIndex:indexPath.row];
        AVUser* source = statu.source;
        AVFile* image = source[@"profilePicture"];
        cell.profilePic.image = [UIImage imageWithData:[image getData]];
        cell.displayNameLabel.text = source[@"displayName"];
        cell.timeLabel.text = [HackDataManager getTimeStr:[statu createdAt]];
        cell.placeLabel.text = statu.data[@"place"][@"placeName"];
        [cell setCornerRadius];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}
/*
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) return @"名片设置";
    else return @"我去过的";
}
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(40, 0, 320, 22)];
    //label.backgroundColor=[UIColor colorWithWhite:1 alpha:0.6];
    label.textColor=[UIColor blackColor];
    label.font=[UIFont systemFontOfSize:14];
    label.text=(section == 0)? @"名片设置":@"我去过的";
    
    // Create header view and add label as a subview
    UIView *sectionView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    [sectionView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.6]];
    [sectionView addSubview:label];
    return sectionView;
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
    if (indexPath.section == 0) return 50.0;
    else return 86.0;
}
@end
