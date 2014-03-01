//
//  CardCell.m
//  avos-hack
//
//  Created by admin on 14-3-1.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "CardCell.h"

@implementation CardCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:6];
        //[self.layer setMasksToBounds:NO];
        [self.contentView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.3]];

        
       
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.profilePic.layer setCornerRadius:(self.profilePic.frame.size.height/2)];
    [self.profilePic.layer setMasksToBounds:YES];
    [self.profilePic setContentMode:UIViewContentModeScaleAspectFill];
    [self.profilePic setClipsToBounds:YES];
    self.profilePic.layer.shadowColor = [UIColor blackColor].CGColor;
    self.profilePic.layer.shadowOffset = CGSizeMake(4, 4);
    self.profilePic.layer.shadowOpacity = 0.5;
    self.profilePic.layer.shadowRadius = 2.0;
    self.profilePic.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.profilePic.layer.borderWidth = 2.0f;
    self.profilePic.userInteractionEnabled = YES;
    self.profilePic.backgroundColor = [UIColor blackColor];
}

@end
