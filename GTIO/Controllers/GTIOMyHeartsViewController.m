//
//  GTIOMyHeartsViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/5/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMyHeartsViewController.h"
#import "GTIOProgressHUD.h"
#import "GTIODualViewSegmentedControlView.h"
#import "GTIOUserProfile.h"

@interface GTIOMyHeartsViewController ()

@property (nonatomic, strong) GTIODualViewSegmentedControlView *segmentedControl;

@end

@implementation GTIOMyHeartsViewController

@synthesize segmentedControl = _segmentedControl;

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
	
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"my      \u2019s" italic:YES];
    UIImageView *heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile.icon.heart.png"]];
    [heart setFrame:(CGRect){ 23, 11, heart.image.size }];
    [navTitleView addSubview:heart];
    [self useTitleView:navTitleView];
    
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [GTIOProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setLeftNavigationButton:backButton];
    
    self.segmentedControl = [[GTIODualViewSegmentedControlView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, 30 } leftControlTitle:@"posts" leftControlPostsType:GTIOPostTypeHeart rightControlTitle:@"products" rightControlPostsType:GTIOPostTypeHeartedProducts];
    [self.view addSubview:self.segmentedControl];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/user/hearts" usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            for (id object in loadedObjects) {
                // set posts for segmented control
            }
        };
    }];
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
