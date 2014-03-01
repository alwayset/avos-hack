//
//  CircleButton.m
//  avos-hack
//
//  Created by admin on 14-3-1.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "CircleButton.h"

@implementation CircleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.3]];
        [self.layer setCornerRadius:self.frame.size.width/2];
        [self.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.layer setBorderWidth:1.0f];
    }
    return self;
}
- (void) setImage:(UIImage *)image
{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*0.22, self.frame.size.height*0.22, self.frame.size.width*0.56  , self.frame.size.height*0.56)];
    [imageView setImage:image];
    [self addSubview:imageView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        [UIView animateWithDuration:0.1
                         animations:^{
                             [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
                         }];
    } else {
        [UIView animateWithDuration:0.2
                         animations:^{
                             [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.3]];
                         }];
    }
}
@end
