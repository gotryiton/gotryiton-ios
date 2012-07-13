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

static CGFloat const kGTIOToolbarHeight = 53.0f;

@interface GTIOPhotoConfirmationViewController ()

@property (nonatomic, strong) UIImage *filteredPhoto;

@property (nonatomic, strong) GTIOPhotoConfirmationToolbarView *photoConfirmationToolbarView;
@property (nonatomic, strong) GTIOPhotoFilterSelectorView *photoFilterSelectorView;

@property (nonatomic, strong) UIImageView *photoImageView;

@property (nonatomic, assign) GTIOFilterType currentFilterType;

@end

@implementation GTIOPhotoConfirmationViewController

@synthesize originalPhoto = _originalPhoto;
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
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  self.originalPhoto, @"originalPhoto",
                                  self.filteredPhoto, @"filteredPhoto",
                                  [NSNumber numberWithInteger:self.currentFilterType], @"filterType",
                                  nil];
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.photoConfirmationToolbarView = nil;
    self.photoFilterSelectorView = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[GTIOFilterManager sharedManager] applyAllFilters];
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
}

- (void)setFilteredPhoto:(UIImage *)filteredPhoto
{
    _filteredPhoto = filteredPhoto;
    [self.photoImageView setImage:_filteredPhoto];
}

@end
