//
//  CheckInPopView.m
//  avos-hack
//
//  Created by Eric Tao on 3/1/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import "CheckInPopView.h"

@implementation CheckInPopView
@synthesize place;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.adImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.adImage];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)setContent {
    AVObject *adver = place[@"ad"];
    AVFile *image = adver[@"image"];
    [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            self.adImage.image = [UIImage imageWithData:data];
        }
    }];
}

@end
