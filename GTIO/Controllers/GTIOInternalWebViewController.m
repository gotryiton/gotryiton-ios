//
//  GTIOInternalWebViewController.m
//  GTIO
//
//  Created by Scott Penrose on 7/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOInternalWebViewController.h"

#import "GTIONavigationTitleView.h"
#import "GTIONavigationNotificationTitleView.h"

#import "GTIORouter.h"
#import "GTIOTrack.h"
#import "GTIONotificationsViewController.h"

NSString * const kGTIOStyleResourcePath = @"/iphone/style-tab";

@interface GTIOInternalWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) GTIONavigationTitleView *navTitleView;

@property (nonatomic, strong) GTIONotificationsViewController *notificationsViewController;

@end

@implementation GTIOInternalWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"checkered-bg.png"]]];
    
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    UIImageView *statusBarBackgroundImageView = [[UIImageView alloc] initWithFrame:(CGRect){ { 0, -(statusBarHeight + self.navigationController.navigationBar.frame.size.height) }, { self.view.frame.size.width, statusBarHeight } }];
    [statusBarBackgroundImageView setImage:[UIImage imageNamed:@"status-bar-bg.png"]];
    [self.view addSubview:statusBarBackgroundImageView];
    
    if ([[self.URL absoluteString] isEqualToString:[NSString stringWithFormat:@"%@%@", kGTIOBaseURLString, kGTIOStyleResourcePath]]) {
        GTIONavigationNotificationTitleView *navTitleView = [[GTIONavigationNotificationTitleView alloc] initWithTapHandler:^(void) {
            [self toggleNotificationView:YES];
        }];
        [self useTitleView:navTitleView];
    } else {
        _navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:self.navigationTitle italic:YES];
        [self useTitleView:_navTitleView];
        
        GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        self.leftNavigationButton = backButton;
    }
    
    self.webView = [[GTIOWebView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height } }];
    [self.webView setBackgroundColor:[UIColor whiteColor]];
    [self.webView.scrollView setDecelerationRate:UIScrollViewDecelerationRateNormal];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.webView.scrollView setScrollIndicatorInsets:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.webView.scrollView setContentInset:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.webView setDelegate:self];
    [self.view addSubview:self.webView];
    
    [self.webView loadGTIORequestWithURL:self.URL];
    [GTIOProgressHUD showHUDAddedTo:self.webView animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webView = nil;
    self.navTitleView = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Fix for the tab bar going opaque when you go to a view that hides it and back to a view that has the tab bar
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOTabBarViewsResize object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self closeNotificationView:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - GTIONotificationViewDisplayProtocol

- (void)toggleNotificationView:(BOOL)animated
{
    if(self.notificationsViewController == nil) {
        self.notificationsViewController = [[GTIONotificationsViewController alloc] initWithNibName:nil bundle:nil];
    }
    
    // if a child, remove it
    if([self.childViewControllers containsObject:self.notificationsViewController]) {
        [self closeNotificationView:YES];
    } else {
        [self openNotificationView:YES];
    }
}

- (void)closeNotificationView:(BOOL)animated
{
    if(self.notificationsViewController.parentViewController) {
        [self.notificationsViewController willMoveToParentViewController:nil];
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.notificationsViewController.view setAlpha:0.0];
                         }
                         completion:^(BOOL finished) {
                             [self.notificationsViewController.view removeFromSuperview];
                             [self.notificationsViewController removeFromParentViewController];
                             [self.notificationsViewController didMoveToParentViewController:nil];
                         }];
    }
}

- (void)openNotificationView:(BOOL)animated
{
    if(self.notificationsViewController.parentViewController == nil) {
        [GTIOTrack postTrackWithID:kGTIONotificationViewTrackingId handler:nil];
        [self.notificationsViewController willMoveToParentViewController:self];
        [self addChildViewController:self.notificationsViewController];
        [self.notificationsViewController.view setAlpha:0.0];
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.view addSubview:self.notificationsViewController.view];
                             [self.notificationsViewController.view setAlpha:1.0];
                         }
                         completion:^(BOOL finished) {
                             [self.notificationsViewController didMoveToParentViewController:self];
                         }];
    }
}

#pragma mark - Properties

- (void)setNavigationTitle:(NSString *)navigationTitle
{
    navigationTitle = [navigationTitle stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    _navigationTitle = navigationTitle;
    
    [self.navTitleView setTitle:_navigationTitle];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // Open http links here but not gtio://
    if (![request.URL.scheme isEqualToString:kGTIOHttpURLScheme]) {
        id viewController = [[GTIORouter sharedRouter] viewControllerForURL:request.URL];
        
        if (viewController) {
            [self.navigationController pushViewController:viewController animated:YES];
            return NO;
        }
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [GTIOProgressHUD hideHUDForView:self.webView animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [GTIOProgressHUD hideHUDForView:self.webView animated:YES];
    // TODO show error state
}

@end
