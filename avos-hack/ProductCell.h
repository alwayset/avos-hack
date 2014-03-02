//
//  ProductCell.h
//  avos-hack
//
//  Created by Eric Tao on 3/2/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productPicture;
@property (weak, nonatomic) IBOutlet UILabel *productName;

@end
