//
//  GTIOIntroScreensViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/14/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOIntroScreensViewController.h"

#import "SDImageCache.h"

#import "GTIOIntroImageViewController.h"
#import "GTIOSignInViewController.h"

#import "GTIOConfigManager.h"

#import "GTIOConfig.h"
#import "GTIOIntroScreen.h"
#import "GTIOTrack.h"

#import "GTIOIntroScreenToolbarView.h"

@interface GTIOIntroScreensViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) GTIOIntroScreenToolbarView *toolbarView;

@property (nonatomic, assign) BOOL forceScroll;

- (NSInteger)currentScrollViewPageNumber;

@end

@implementation GTIOIntroScreensViewController

@synthesize scrollView = _scrollView, toolbarView = _toolbarView;
@synthesize forceScroll = _forceScroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.forceScroll = NO;
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *statusBarBackgroundImageView = [[UIImageView alloc] initWithFrame:(CGRect){ { 0, -20 }, { self.view.frame.size.width, 20 } }];
    [statusBarBackgroundImageView setImage:[UIImage imageNamed:@"status-bar-bg.png"]];
    [self.view addSubview:statusBarBackgroundImageView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.frame.size.width, self.view.frame.size.height } }];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setDelegate:self];
    [self.view addSubview:self.scrollView];
    
    GTIOConfig *config = [[GTIOConfigManager sharedManager] config];
    
    // Setup intro pages if there are any
    CGFloat xOffset = 0.0f;
    if ([config.introScreens count] > 0) {
        [self.scrollView setFrame:(CGRect){ self.scrollView.frame.origin, { self.scrollView.frame.size.width, self.scrollView.frame.size.height - 44 } }];
        self.toolbarView = [[GTIOIntroScreenToolbarView alloc] initWithFrame:(CGRect){ { 0, self.scrollView.frame.origin.y + self.scrollView.frame.size.height }, { self.view.frame.size.width, 44 } }];
        [self.toolbarView.signInButton setTapHandler:^(id sender) {
            // Go to last page
            NSInteger currentPage = [self.childViewControllers count] - 1;
            [self.toolbarView hideButtons:YES];
            self.forceScroll = YES;
            [self.scrollView setContentOffset:(CGPoint){ currentPage * self.scrollView.frame.size.width, 0 } animated:YES];
        }];
        __block typeof(self) blockSelf = self;
        [self.toolbarView.nextButton setTapHandler:^(id sender) {
            NSInteger currentPage = [blockSelf currentScrollViewPageNumber];
            // Hide next button if last page
            if (currentPage == [blockSelf.childViewControllers count] - 2) {
                self.forceScroll = YES;
                [blockSelf.toolbarView hideButtons:YES];
            }
            // Scroll to next page
            if (currentPage < [blockSelf.childViewControllers count] - 1) {
                [self.scrollView setContentOffset:(CGPoint){ (currentPage + 1) * self.scrollView.frame.size.width, 0 } animated:YES];
            }
            
        }];
        [self.view addSubview:self.toolbarView];
        
        NSArray *introScreensSorted = [config.introScreens sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            GTIOIntroScreen *introScreen1 = obj1;
            GTIOIntroScreen *introScreen2 = obj2;
            
            return [introScreen1.track.pageNumber compare:introScreen2.track.pageNumber];
        }];
        
        for (GTIOIntroScreen *introScreen in introScreensSorted) {
            GTIOIntroImageViewController *introScreenViewController = [[GTIOIntroImageViewController alloc] initWithNibName:nil bundle:nil];
            [introScreenViewController setIntroScreen:introScreen];
            [introScreenViewController.view setFrame:(CGRect){ { xOffset, 0 }, self.scrollView.frame.size }];
            [self.scrollView addSubview:introScreenViewController.view];
            [self addChildViewController:introScreenViewController];
            
            xOffset += self.scrollView.frame.size.width;
        }
    }

    // Add last page as sign up
    GTIOSignInViewController *signInViewController = [[GTIOSignInViewController alloc] initWithNibName:nil bundle:nil];
    [signInViewController.view setFrame:(CGRect){ { xOffset, 0 }, self.scrollView.frame.size }];
    [self.scrollView addSubview:signInViewController.view];
    [self addChildViewController:signInViewController];
    xOffset += self.scrollView.frame.size.width;
    
    [self.scrollView setContentSize:(CGSize){ xOffset, self.scrollView.frame.size.height }];
    
    [self.toolbarView.pageControl setNumberOfPages:[self.childViewControllers count]];
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
    [self.scrollView setContentOffset:(CGPoint){ pageControl.currentPage * self.scrollView.frame.size.width, 0 } animated:YES];
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
    
    if (!self.forceScroll) {
        if (self.toolbarView.pageControl.currentPage == [self.childViewControllers count] - 1) {
            [self.toolbarView hideButtons:YES];
        } else {
            [self.toolbarView hideButtons:NO];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.forceScroll = NO;
}

@end