//
//  ProductCell.m
//  avos-hack
//
//  Created by Eric Tao on 3/2/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell

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
    [self.backView.layer setCornerRadius:10.0f];
    [self.productPicture.layer setCornerRadius:6];
    [self.productPicture.layer setMasksToBounds:YES];
    //[self.profilePic setContentMode:UIViewContentModeScaleAspectFill];
    //[self.profilePic setClipsToBounds:YES];
    //self.profilePic.layer.shadowColor = [UIColor blackColor].CGColor;
    //self.profilePic.layer.shadowOffset = CGSizeMake(4, 4);
    // self.profilePic.layer.shadowOpacity = 0.5;
    // self.profilePic.layer.shadowRadius = 2.0;
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
