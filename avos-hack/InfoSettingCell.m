//
//  InfoSettingCell.m
//  avos-hack
//
//  Created by admin on 14-3-2.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "InfoSettingCell.h"

@implementation InfoSettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCornerRadius
{
    
    //[self.backView setFrame:CGRectMake(20, 10, 280, 80)];
    [self.backView.layer setMasksToBounds:YES];
    [self.backView.layer setCornerRadius:6.0f];
    //self.profilePic.backgroundColor = [UIColor blackColor];
    /*
     if (!backView) {
     backView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 280, 80)];
     [backView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
     [backView.layer setMasksToBounds:YES];
     [backView.layer setCornerRadius:10.0f];
     [self.contentView addSubview:backView];
     
     [backView addSubview:self.profilePic];
     [backView addSubview:self.displayNameLabel];
     [backView addSubview:self.timeLabel];
     [backView addSubview:self.pointIcon];
     
     
     
     }
     */
    
}

@end
