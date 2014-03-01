//
//  MainViewController.m
//  avos-hack
//
//  Created by admin on 14-3-1.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "MainViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "constant.h"
#import "HackDataManager.h"
#import "MBProgressHUD.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface MainViewController ()

@end

@implementation MainViewController
@synthesize signUpView;
@synthesize signupProfilePicView;
@synthesize displayNameField;
@synthesize displayNameLabel;
@synthesize profilePictureView;
@synthesize kmpButton;
@synthesize orderButton;
@synthesize infoView;
@synthesize buttonView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [signUpView removeFromSuperview];
    [infoView removeFromSuperview];
    [buttonView removeFromSuperview];
    [self reloadProfile];
    [self setProfilePictureView];
    [self setSignupProfilePicView];
    [orderButton setImage:[UIImage imageNamed:@"drinkIcon"]];
    [kmpButton setImage:[UIImage imageNamed:@"cardIcon"]];
    if (![AVUser currentUser]) {
        [self showSignupView];
    } else {
        [self showInfoView];
    }
    [self showButtonsView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)reloadProfile
{
    if ([AVUser currentUser]) {
        displayNameLabel.text = [AVUser currentUser][@"displayName"];
        AVFile* profilePic = [AVUser currentUser][@"profilePicture"];
        profilePictureView.image = [UIImage imageWithData:[profilePic getData]];
    }
}

- (void) showSignupView
{
    [signUpView setAlpha:0];
    [signUpView setFrame:CGRectMake(40, 30, 240, 250)];
    [self.view addSubview:signUpView];
    [UIView animateWithDuration:0.7
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [signUpView setAlpha:1];
                         [signUpView setFrame:CGRectMake(40, 60, 240, 250)];
                     } completion:^(BOOL finished) {
                         
                     }];
}
- (void) showInfoView
{
    [infoView setAlpha:0];
    [infoView setFrame:CGRectMake(40, 30, 240, 250)];
    [self.view addSubview:infoView];
    [UIView animateWithDuration:0.7
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [infoView setAlpha:1];
                         [infoView setFrame:CGRectMake(40, 60, 240, 250)];
                     } completion:^(BOOL finished) {
                         
                     }];
}
- (void) showButtonsView
{
    [buttonView setAlpha:0];
    [buttonView setFrame:CGRectMake(0, 370, 320, 54)];
    [self.view addSubview:buttonView];
    [UIView animateWithDuration:0.7
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [buttonView setAlpha:1];
                         [buttonView setFrame:CGRectMake(0, 340, 320, 54)];
                     } completion:^(BOOL finished) {
                         
                     }];
}
- (void) hideSignupView
{
    [self reloadProfile];
    [self.view addSubview:infoView];
    [UIView animateWithDuration:0.7
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [signUpView setAlpha:0];
                         [infoView setAlpha:1];
                     } completion:^(BOOL finished) {
                         [signUpView removeFromSuperview];
                     }];
}
- (void)loginWithUsername:(NSString *)username password:(NSString *)pwd {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"登陆中";
    //[[PaDataManager sharedInstance] showActivityIndicatorInStatusBar:YES];
    [AVUser logInWithUsernameInBackground:username password:pwd block:^(AVUser *user, NSError *error) {
        [hud hide:YES];
        //[[PaDataManager sharedInstance] showActivityIndicatorInStatusBar:NO];
        if (error) {
            if (error.code == kErrorWrongPassword) {
                [HackDataManager showMessageWithText:@"用户名/密码不匹配"];
            } else {
                [HackDataManager showAlertWithText:@"登入失败"];
            }
        } else {
            [HackDataManager showMessageWithText:@"登陆成功"];
            [self hideSignupView];
        }
        
    }];
}
- (void)signupWithName:(NSString*)name ProfilePicture:(UIImage*) image{
    AVUser * user = [AVUser user];
    user.username = [self genRandStringLength];
    user.password = @"888888";
    AVQuery *usernameAvailabilityQuery = [AVUser query];
    [usernameAvailabilityQuery whereKey:@"username" equalTo:user.username];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"注册中";
    //[[HackDataManager sharedInstance] showActivityIndicatorInStatusBar:YES];
    [usernameAvailabilityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [HackDataManager showAlertWithText:@"注册失败"];
            //[[PaDataManager sharedInstance] showActivityIndicatorInStatusBar:NO];
            [hud hide:YES];
        } else {
            if (objects.count == 0) {
                [user setObject:name forKey:@"displayName"];
                NSData* imageData = UIImageJPEGRepresentation(image,1);
                AVFile* profilePic = [AVFile fileWithName:[NSString stringWithFormat:@"%@.jpg",name] data:imageData];
                [profilePic saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [user setObject:profilePic forKey:@"profilePicture"];
                        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                [self loginWithUsername:user.username password:user.password];
                            } else {
                                [HackDataManager showAlertWithText:@"注册失败"];
                            }
                            //[[PaDataManager sharedInstance] showActivityIndicatorInStatusBar:NO];
                            [hud hide:YES];
                        }];
                    } else {
                        [HackDataManager showAlertWithText:@"注册失败"];
                    }
                    //[[PaDataManager sharedInstance] showActivityIndicatorInStatusBar:NO];
                    [hud hide:YES];
                }];
                
            } else {
                [self signupWithName:name ProfilePicture:image];
                //[[PaDataManager sharedInstance] showActivityIndicatorInStatusBar:NO];
                [hud hide:YES];
            }
        }
    }];
}
-(NSString *) genRandStringLength {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:20];
    
    for (int i=0; i<20; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signupProfilePicClicked:(id)sender {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}
- (IBAction)signupFinished:(id)sender {
    
    [self signupWithName:displayNameField.text ProfilePicture:signupProfilePicView.image];
    
    
}
- (IBAction)orderClicked:(id)sender {

    //UIViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"OrderViewController"];
    //[self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)kmpClicked:(id)sender {
    //UIViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"NearUsersViewController"];
    //[self.navigationController pushViewController:vc animated:YES];
}


#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    signupProfilePicView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)setProfilePictureView {
//    if (!profilePictureView) {
        //CGFloat w = 100.0f; CGFloat h = w;
        //CGFloat x = 110;
        //CGFloat y = 60;
//        profilePictureView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
//        [profilePictureView setFrame:CGRectMake(x, y, w, h)];
        [profilePictureView.layer setCornerRadius:(profilePictureView.frame.size.height/2)];
        [profilePictureView.layer setMasksToBounds:YES];
        [profilePictureView setContentMode:UIViewContentModeScaleAspectFill];
        [profilePictureView setClipsToBounds:YES];
        profilePictureView.layer.shadowColor = [UIColor blackColor].CGColor;
        profilePictureView.layer.shadowOffset = CGSizeMake(4, 4);
        profilePictureView.layer.shadowOpacity = 0.5;
        profilePictureView.layer.shadowRadius = 2.0;
        profilePictureView.layer.borderColor = [[UIColor whiteColor] CGColor];
        profilePictureView.layer.borderWidth = 2.0f;
        profilePictureView.userInteractionEnabled = YES;
        profilePictureView.backgroundColor = [UIColor blackColor];
        //UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        //[profilePictureView addGestureRecognizer:portraitTap];
//    }
//    return profilePictureView;
}
- (void)setSignupProfilePicView {
    //    if (!profilePictureView) {
    //CGFloat w = 100.0f; CGFloat h = w;
    //CGFloat x = 110;
    //CGFloat y = 60;
    //        profilePictureView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    //        [profilePictureView setFrame:CGRectMake(x, y, w, h)];
    [signupProfilePicView.layer setCornerRadius:(signupProfilePicView.frame.size.height/2)];
    [signupProfilePicView.layer setMasksToBounds:YES];
    [signupProfilePicView setContentMode:UIViewContentModeScaleAspectFill];
    [signupProfilePicView setClipsToBounds:YES];
    signupProfilePicView.layer.shadowColor = [UIColor blackColor].CGColor;
    signupProfilePicView.layer.shadowOffset = CGSizeMake(4, 4);
    signupProfilePicView.layer.shadowOpacity = 0.5;
    signupProfilePicView.layer.shadowRadius = 2.0;
    signupProfilePicView.layer.borderColor = [[UIColor whiteColor] CGColor];
    signupProfilePicView.layer.borderWidth = 2.0f;
    signupProfilePicView.userInteractionEnabled = YES;
    signupProfilePicView.backgroundColor = [UIColor blackColor];
    //UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
    //[signupProfilePicView addGestureRecognizer:portraitTap];
    //    }
    //    return signupProfilePicView;
}
@end
