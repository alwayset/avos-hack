//
//  PlaceViewController.h
//  avos-hack
//
//  Created by Eric Tao on 3/2/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface PlaceViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *placePicture;
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property AVObject *parentPlace;

@end
