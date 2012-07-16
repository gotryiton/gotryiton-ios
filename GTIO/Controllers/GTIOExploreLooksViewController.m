//
//  GTIOExploreLooksViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/8/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOExploreLooksViewController.h"

#import <RestKit/RestKit.h>

#import "GTIOPagination.h"
#import "GTIOTab.h"
#import "GTIOPost.h"

#import "GTIOLooksSegmentedControlView.h"
#import "GTIONavigationNotificationTitleView.h"

@interface GTIOExploreLooksViewController ()

@property (nonatomic, strong) GTIOLooksSegmentedControlView *segmentedControlView;

@property (nonatomic, strong) NSMutableArray *tabs;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) GTIOPagination *pagination;

@end

@implementation GTIOExploreLooksViewController

@synthesize segmentedControlView = _segmentedControlView;
@synthesize tabs = _tabs, posts = _posts, pagination = _pagination;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tabs = [NSMutableArray array];
        _posts = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    UIImageView *statusBarBackgroundImageView = [[UIImageView alloc] initWithFrame:(CGRect){ { 0, -(statusBarHeight + self.navigationController.navigationBar.frame.size.height) }, { self.view.frame.size.width, statusBarHeight } }];
    [statusBarBackgroundImageView setImage:[UIImage imageNamed:@"status-bar-bg.png"]];
    [self.view addSubview:statusBarBackgroundImageView];
    
    GTIONavigationNotificationTitleView *navTitleView = [[GTIONavigationNotificationTitleView alloc] initWithNotifcationCount:[NSNumber numberWithInt:1] tapHandler:nil];
    [self useTitleView:navTitleView];
    
    self.segmentedControlView = [[GTIOLooksSegmentedControlView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.frame.size.width, 50 } }];
    [self.view addSubview:self.segmentedControlView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - RestKit Load Objects

- (void)loadData
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/posts/explore" usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects) {
            NSLog(@"Body:%@", loader.response.bodyAsString);
            [self.tabs removeAllObjects];
            [self.posts removeAllObjects];
            self.pagination = nil;
            
            for (id object in objects) {
                if ([object isKindOfClass:[GTIOTab class]]) {
                    [self.tabs addObject:object];
                    [self.tabs addObject:object];
                } else if ([object isKindOfClass:[GTIOPost class]]) {
                    [self.posts addObject:object];
                } else if ([object isKindOfClass:[GTIOPagination class]]) {
                    self.pagination = object;
                }
            }
            
            [self.segmentedControlView setTabs:self.tabs];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            NSLog(@"Failed to load explore looks");
        };
    }];
}

@end
