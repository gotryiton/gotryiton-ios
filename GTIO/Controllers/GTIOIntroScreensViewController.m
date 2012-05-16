//
//  GTIOIntroScreensViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/14/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOIntroScreensViewController.h"

#import <SDWebImage/SDImageCache.h>

#import "GTIOConfigManager.h"

#import "GTIOConfig.h"
#import "GTIOIntroScreen.h"

@interface GTIOIntroScreensViewController ()

@end

@implementation GTIOIntroScreensViewController

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
    [self.view setBackgroundColor:[UIColor redColor]];
    
    GTIOConfig *config = [[GTIOConfigManager sharedManager] config];
    GTIOIntroScreen *introScreen = [config.introScreens objectAtIndex:0];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromKey:introScreen.introScreenID];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:(CGRect){ CGPointZero, imageView.image.size }];
    [self.view addSubview:imageView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
