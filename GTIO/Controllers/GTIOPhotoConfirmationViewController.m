//
//  GTIOPhotoConfirmationViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/31/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPhotoConfirmationViewController.h"

#import "GTIOCameraViewController.h"

#import "GTIOPhotoConfirmationToolbarView.h"
#import "GTIOPhotoFilterSelectorView.h"

#import "GTIOFilterManager.h"

#import "SDWebImageManager.h"

static CGFloat const kGTIOToolbarHeight = 53.0f;

@interface GTIOPhotoConfirmationViewController () <SDWebImageManagerDelegate>

@property (nonatomic, strong) UIImage *filteredPhoto;

@property (nonatomic, strong) GTIOPhotoConfirmationToolbarView *photoConfirmationToolbarView;
@property (nonatomic, strong) GTIOPhotoFilterSelectorView *photoFilterSelectorView;

@property (nonatomic, strong) UIImageView *photoImageView;

@property (nonatomic, assign) GTIOFilterType currentFilterType;

@end

@implementation GTIOPhotoConfirmationViewController

@synthesize originalPhoto = _originalPhoto, originalPhotoURL = _originalPhotoURL;
@synthesize productID = _productID;
@synthesize photoImageView = _photoImageView;
@synthesize photoConfirmationToolbarView = _photoConfirmationToolbarView;
@synthesize photoFilterSelectorView = _photoFilterSelectorView;
@synthesize filteredPhoto = _filteredPhoto, currentFilterType = _currentFilterType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_photoImageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [self setWantsFullScreenLayout:YES];
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view setBackgroundColor:[UIColor blackColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.photoImageView setFrame:(CGRect){ CGPointZero, { self.view.frame.size.width, self.view.frame.size.height - kGTIOToolbarHeight } }];
    [self.view addSubview:self.photoImageView];
    
    // Toolbar
    self.photoConfirmationToolbarView = [[GTIOPhotoConfirmationToolbarView alloc] initWithFrame:(CGRect){ 0, self.view.frame.size.height - kGTIOToolbarHeight, self.view.frame.size.width, kGTIOToolbarHeight }];
    [self.photoConfirmationToolbarView.closeButton setTapHandler:^(id sender) {
        [[GTIOFilterManager sharedManager] clearFilters];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.photoConfirmationToolbarView.confirmButton setTapHandler:^(id sender) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  self.originalPhoto, @"originalPhoto",
                                  self.filteredPhoto, @"filteredPhoto",
                                  GTIOFilterTypeName[self.currentFilterType], @"filterName",
                                  nil];
        if (self.productID) {
            [userInfo setValue:self.productID forKey:@"productID"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOPhotoAcceptedNotification object:nil userInfo:userInfo];
        [[GTIOFilterManager sharedManager] clearFilters];
    }];
    [self.view addSubview:self.photoConfirmationToolbarView];
    
    // Filter View
    self.photoFilterSelectorView = [[GTIOPhotoFilterSelectorView alloc] initWithFrame:(CGRect){ 0 , self.photoConfirmationToolbarView.frame.origin.y - 101, { self.view.frame.size.width, 101 } }];
    [self.photoFilterSelectorView setPhotoFilterSelectedHandler:^(GTIOFilterType filterType) {
        self.currentFilterType = filterType;
        self.filteredPhoto = [[GTIOFilterManager sharedManager] photoWithFilterType:filterType];
    }];
    [self.view addSubview:self.photoFilterSelectorView];
}

//- (void)didReceiveMemoryWarning {
//    return;
//}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // TODO: cleaing up photoConfirmationToolbarView is causing a crash on iOS 5.
//    self.photoConfirmationToolbarView = nil;
    self.photoFilterSelectorView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setOriginalPhoto:(UIImage *)originalPhoto
{
    _originalPhoto = originalPhoto;
    [self setFilteredPhoto:_originalPhoto];
    
    [[GTIOFilterManager sharedManager] setOriginalImage:_originalPhoto];
    [[GTIOFilterManager sharedManager] applyAllFilters];
}

- (void)setOriginalPhotoURL:(NSURL *)originalPhotoURL
{
    _originalPhotoURL = originalPhotoURL;
    
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SDWebImageManager sharedManager] downloadWithURL:_originalPhotoURL delegate:self options:0 success:^(UIImage *image) {
        [GTIOProgressHUD hideHUDForView:self.view animated:YES];
        [self setOriginalPhoto:image];
    } failure:^(NSError *error) {
        [GTIOProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"Failed to download product image");
        [[[GTIOAlertView alloc] initWithTitle:@"Error" message:@"Could now download product image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void)setFilteredPhoto:(UIImage *)filteredPhoto
{
    _filteredPhoto = filteredPhoto;
    [self.photoImageView setImage:_filteredPhoto];
}

@end
