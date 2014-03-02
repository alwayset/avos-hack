//
//  PlaceViewController.m
//  avos-hack
//
//  Created by Eric Tao on 3/2/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import "PlaceViewController.h"
#import "ProductCell.h"
@interface PlaceViewController ()
@property NSMutableArray *products;
@end

@implementation PlaceViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadProducts];
    [self setContent];
}

- (void)setContent {
    self.placePicture.layer.masksToBounds = YES;
    self.placePicture.layer.cornerRadius = 6;
    AVFile *pic = self.parentPlace[@"picture"];
    [pic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            self.placePicture.image = [UIImage imageWithData:data];
        }
    }];
    self.placeNameLabel.text = self.parentPlace[@"placeName"];
}
- (IBAction)back:(id)sender {
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"ProductCell" forIndexPath:indexPath];
    AVObject *aProduct = [_products objectAtIndex:indexPath.row];
    cell.productName.text = aProduct[@"productName"];
    AVFile *file = aProduct[@"image"];
    [file getThumbnail:YES width:100 height:100 withBlock:^(UIImage *image, NSError *error) {
        cell.productPicture.image = image;
    }];
    /*
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            cell.productPicture.image = [UIImage imageWithData:data];
        }
    }];
     */
    [cell setCornerRadius];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74.0;
}

- (void)loadProducts {
    AVRelation *relation = [self.parentPlace relationforKey:@"products"];
    AVQuery *query = [relation query];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _products = [NSMutableArray arrayWithArray:objects];
            [self.tableview reloadData];
        }
    }];
}

@end
