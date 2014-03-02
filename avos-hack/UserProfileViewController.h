//
//  UserProfileViewController.h
//  avos-hack
//
//  Created by admin on 14-3-2.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoSettingCell.h"
@interface UserProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) InfoSettingCell* phoneCell;
@property (strong, nonatomic) InfoSettingCell* addressCell;
@property (strong, nonatomic) InfoSettingCell* companyCell;
@property (strong, nonatomic) InfoSettingCell* emailCell;
@property (strong, nonatomic) InfoSettingCell* wechatCell;

@end
