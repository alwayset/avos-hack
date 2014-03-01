//
//  MainViewController.h
//  avos-hack
//
//  Created by admin on 14-3-1.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPImageCropperViewController.h"
#import "CircleButton.h"
#import <CoreLocation/CoreLocation.h>


@interface MainViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UIView *signUpView;
@property (strong, nonatomic) IBOutlet UIImageView *signupProfilePicView;
@property (strong, nonatomic) IBOutlet UITextField *displayNameField;
@property (strong, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (strong, nonatomic) IBOutlet CircleButton *orderButton;
@property (strong, nonatomic) IBOutlet CircleButton *kmpButton;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UIView *buttonView;

@end
