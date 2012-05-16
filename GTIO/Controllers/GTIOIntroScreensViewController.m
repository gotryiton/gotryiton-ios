//
//  GTIOIntroScreensViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/14/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOIntroScreensViewController.h"

#import <SDWebImage/SDImageCache.h>

#import "GTIOIntroScreenViewController.h"
#import "GTIOConfigManager.h"

#import "GTIOConfig.h"
#import "GTIOIntroScreen.h"
#import "GTIOTrack.h"

#import "GTIOIntroScreenToolbarView.h"

@interface GTIOIntroScreensViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) GTIOIntroScreenToolbarView *toolbarView;

- (NSInteger)currentScrollViewPageNumber;

@end

@implementation GTIOIntroScreensViewController

@synthesize scrollView = _scrollView, toolbarView = _toolbarView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

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
    
    UIImageView *statusBarBackgroundImageView = [[UIImageView alloc] initWithFrame:(CGRect){ { 0, -20 }, { self.view.frame.size.width, 20 } }];
    [statusBarBackgroundImageView setImage:[UIImage imageNamed:@"status-bar-bg.png"]];
    [self.view addSubview:statusBarBackgroundImageView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.frame.size.width, self.view.frame.size.height - 44 } }];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setDelegate:self];
    [self.view addSubview:self.scrollView];
    
    self.toolbarView = [[GTIOIntroScreenToolbarView alloc] initWithFrame:(CGRect){ { 0, self.scrollView.frame.origin.y + self.scrollView.frame.size.height }, { self.view.frame.size.width, 44 } }];
    [self.view addSubview:self.toolbarView];
    
    // Setup intro pages
    GTIOConfig *config = [[GTIOConfigManager sharedManager] config];
    
    NSArray *introScreensSorted = [config.introScreens sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        GTIOIntroScreen *introScreen1 = obj1;
        GTIOIntroScreen *introScreen2 = obj2;
        
        return [introScreen1.track.pageNumber compare:introScreen2.track.pageNumber];
    }];
    
    CGFloat xOffset = 0.0f;
    for (GTIOIntroScreen *introScreen in introScreensSorted) {        
        GTIOIntroScreenViewController *introScreenViewController = [[GTIOIntroScreenViewController alloc] initWithNibName:nil bundle:nil];
        [introScreenViewController setIntroScreen:introScreen];
        [introScreenViewController.view setFrame:(CGRect){ { xOffset, 0 }, self.scrollView.frame.size }];
        [self.scrollView addSubview:introScreenViewController.view];
        [self addChildViewController:introScreenViewController];
        
        xOffset += self.scrollView.frame.size.width;
    }
    
    [self.scrollView setContentSize:(CGSize){ xOffset, self.scrollView.frame.size.height }];
    
    [self.toolbarView.pageControl setNumberOfPages:[config.introScreens count]];
    [self.toolbarView.pageControl setCurrentPage:0];
    [self.toolbarView.pageControl addTarget:self action:@selector(pageControlTouched:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    for (UIViewController *viewController in self.childViewControllers) {
        [viewController removeFromParentViewController];
    }
    self.scrollView = nil;
    self.toolbarView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - PageControl

- (void)pageControlTouched:(id)sender
{
    GTIOPageControl *pageControl = sender;
    [self.scrollView setContentOffset:(CGPoint){ pageControl.currentPage * self.scrollView.frame.size.width, 0 }];
}

#pragma mark - UIScrollView Helpers

- (NSInteger)currentScrollViewPageNumber
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGPoint point = self.scrollView.contentOffset;
    point.x += pageWidth / 2; // Grab the center
    NSInteger page = (int)point.x / pageWidth;
    return page;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.toolbarView.pageControl setCurrentPage:[self currentScrollViewPageNumber]];
}

@end
