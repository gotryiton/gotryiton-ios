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

#import "GTIOPhotoManager.h"

#import "GTIOTrack.h"

@interface GTIOPhotoShootGridViewController ()

@property (nonatomic, strong) GTIOPhotoShootGridView *photoShootGridView;

@end

@implementation GTIOPhotoShootGridViewController

@synthesize photoShootGridView = _photoShootGridView;

- (void)loadView
{
    [super loadView];
    
    UIImageView *statusBGImageView = [[UIImageView alloc] initWithFrame:(CGRect){ 0, -64, self.view.frame.size.width, 20 }];
    [statusBGImageView setImage:[[UIImage imageNamed:@"checkered-bg.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 0, 0, 0, 0 }]];
    [self.view addSubview:statusBGImageView];
    
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"select one photo" italic:YES];
    [self useTitleView:navTitleView];
    
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setLeftNavigationButton:backButton];

    [GTIOTrack postTrackWithID:kGTIOTrackPhotoShootStarted handler:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    self.photoShootGridView = [[GTIOPhotoShootGridView alloc] initWithFrame:self.view.bounds images:[[GTIOPhotoManager sharedManager] thumbnailPhotos]];
    [self.photoShootGridView setImageSelectedHandler:^(NSInteger photoIndex) {
        UIImage *selectedPhoto = [[GTIOPhotoManager sharedManager] photoAtIndex:photoIndex];
        GTIOPhotoConfirmationViewController *photoConfirmationViewController = [[GTIOPhotoConfirmationViewController alloc] initWithNibName:nil bundle:nil];
        [photoConfirmationViewController setOriginalPhoto:selectedPhoto];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[GTIOPhotoManager sharedManager] resizeAllImages];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
