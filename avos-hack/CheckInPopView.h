//
//  CheckInPopView.h
//  avos-hack
//
//  Created by Eric Tao on 3/1/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
@interface CheckInPopView : UIView

@property AVObject *place;
@property UIImageView *adImage;

- (void)setContent;
@end
