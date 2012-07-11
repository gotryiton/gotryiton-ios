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

@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) NSMutableArray *products;

@end

@implementation GTIOMyHeartsViewController

@synthesize segmentedControl = _segmentedControl, posts = _posts, products = _products;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
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
    
    self.segmentedControl = [[GTIODualViewSegmentedControlView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height } leftControlTitle:@"posts" leftControlPostsType:GTIOPostTypeHeart rightControlTitle:@"products" rightControlPostsType:GTIOPostTypeHeartedProducts];
    [self.view addSubview:self.segmentedControl];
    
    self.posts = [NSMutableArray array];
    self.products = [NSMutableArray array];
    
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/posts/hearted-by-user/%@", [GTIOUser currentUser].userID] usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOPost class]]) {
                    [self.posts addObject:object];
                }
            }
            [self.segmentedControl setPosts:self.posts GTIOPostType:GTIOPostTypeHeart user:[GTIOUser currentUser]];
            [self.segmentedControl setPosts:self.products GTIOPostType:GTIOPostTypeHeartedProducts user:[GTIOUser currentUser]];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@", [error localizedDescription]);
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
