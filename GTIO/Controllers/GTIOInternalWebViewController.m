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
#import "GTIONotificationsViewController.h"

NSString * const kGTIOStyleResourcePath = @"/iphone/style-tab";

@interface GTIOInternalWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) GTIONavigationTitleView *navTitleView;

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
            GTIONotificationsViewController *notificationsViewController = [[GTIONotificationsViewController alloc] initWithNibName:nil bundle:nil];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:notificationsViewController];
            [self presentModalViewController:navigationController animated:YES];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
