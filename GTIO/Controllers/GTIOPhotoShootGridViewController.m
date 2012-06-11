//
//  GTIOPhotoShootGridViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/31/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPhotoShootGridViewController.h"

#import "GTIOPhotoShootGridView.h"

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
    
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"select one photo" italic:NO];
    [self useTitleView:navTitleView];
    
    GTIOButton *backButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setLeftNavigationButton:backButton];
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
