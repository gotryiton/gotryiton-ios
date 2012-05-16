//
//  GTIOIntroScreenViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/16/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOIntroScreenViewController.h"

#import <SDWebImage/SDImageCache.h>

@interface GTIOIntroScreenViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation GTIOIntroScreenViewController

@synthesize introScreen = _introScreen;
@synthesize imageView = _imageView;

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
