//
//  InfoSettingCell.h
//  avos-hack
//
//  Created by admin on 14-3-2.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoSettingCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIView *backView;
- (void)setCornerRadius;
@end
