//
//  GTIOIntroScreenViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/16/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOIntroImageViewController.h"

#import "SDImageCache.h"

@interface GTIOIntroImageViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation GTIOIntroImageViewController

@synthesize introScreen = _introScreen;
@synthesize imageView = _imageView;

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [[SDImageCache sharedImageCache] imageFromKey:self.introScreen.introScreenID];
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.imageView setImage:image];
    [self.imageView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    [self.view addSubview:self.imageView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
