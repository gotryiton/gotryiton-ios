//
//  GTIOPhotoShootGridViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/31/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPhotoShootGridViewController.h"

#import "GTIOPhotoShootGridView.h"
#import "GTIONavigationTitleLabel.h"

#import "GTIOPhotoConfirmationViewController.h"

@interface GTIOPhotoShootGridViewController ()

@property (nonatomic, strong) GTIOPhotoShootGridView *photoShootGridView;

@end

@implementation GTIOPhotoShootGridViewController

@synthesize images = _images;

@synthesize photoShootGridView = _photoShootGridView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [bgImageView setImage:[[UIImage imageNamed:@"checkered-bg.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 0, 0, 0, 0 }]];
    [self.view addSubview:bgImageView];
    
    UIImageView *statusBGImageView = [[UIImageView alloc] initWithFrame:(CGRect){ 0, -64, self.view.frame.size.width, 20 }];
    [statusBGImageView setImage:[[UIImage imageNamed:@"checkered-bg.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 0, 0, 0, 0 }]];
    [self.view addSubview:statusBGImageView];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"green-pattern-nav-bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    GTIONavigationTitleLabel *titleLabel = [[GTIONavigationTitleLabel alloc] initWithTitle:@"select one photo"];
    // need to shift the label down a bit because of the design
    UIView *titleView = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, titleLabel.bounds.size.width, titleLabel.bounds.size.height + 9 }];
    [titleLabel setFrame:(CGRect){ 0, 9, titleLabel.bounds.size }];
    [titleView addSubview:titleLabel];
    [self.navigationItem setTitleView:titleView];

    UIView *topShadow = [[UIView alloc] initWithFrame:(CGRect){0,0,self.view.bounds.size.width,3}];
    [topShadow setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"top-shadow.png"]]];
    [self.view addSubview:topShadow];
    
    GTIOButton *backButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    self.photoShootGridView = [[GTIOPhotoShootGridView alloc] initWithFrame:self.view.bounds images:self.images];
    [self.photoShootGridView setImageSelectedHandler:^(UIImage *selectedImage) {
        GTIOPhotoConfirmationViewController *photoConfirmationViewController = [[GTIOPhotoConfirmationViewController alloc] initWithNibName:nil bundle:nil];
        [photoConfirmationViewController setPhoto:selectedImage];
        [self.navigationController pushViewController:photoConfirmationViewController animated:YES];
    }];
    [self.view addSubview:self.photoShootGridView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.photoShootGridView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
