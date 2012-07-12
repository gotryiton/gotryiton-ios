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
#import "GTIOWebView.h"

#import "GTIORouter.h"

NSString * const kGTIOStyleResourcePath = @"/iphone/style-tab";

@interface GTIOInternalWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) GTIOWebView *webView;

@end

@implementation GTIOInternalWebViewController

@synthesize URL = _URL, navigationTitle = _navigationTitle;
@synthesize webView = _webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"checkered-bg.png"]]];
    
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    UIImageView *statusBarBackgroundImageView = [[UIImageView alloc] initWithFrame:(CGRect){ { 0, -(statusBarHeight + self.navigationController.navigationBar.frame.size.height) }, { self.view.frame.size.width, statusBarHeight } }];
    [statusBarBackgroundImageView setImage:[UIImage imageNamed:@"status-bar-bg.png"]];
    [self.view addSubview:statusBarBackgroundImageView];
    
    if ([[self.URL absoluteString] isEqualToString:[NSString stringWithFormat:@"%@%@", kGTIOBaseURLString, kGTIOStyleResourcePath]]) {
        GTIONavigationNotificationTitleView *navTitleView = [[GTIONavigationNotificationTitleView alloc] initWithNotifcationCount:[NSNumber numberWithInt:0] tapHandler:nil];
        [self useTitleView:navTitleView];
    } else {
        GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:self.navigationTitle italic:YES];
        [self useTitleView:navTitleView];
        
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
    
    // TODO: Need error state
    // TODO: Need loading spinner
    
    double delayInSeconds = 7.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSURL *URL2 = [NSURL URLWithString:@"gtio://internal-webview/test+url/%22Aardvarks+lurk%2C+OK%3F%22"];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL2];
        [self.webView.delegate webView:self.webView shouldStartLoadWithRequest:request navigationType:UIWebViewNavigationTypeLinkClicked];
    });
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webView = nil;
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
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    id viewController = [[GTIORouter sharedRouter] viewControllerForURL:request.URL];
    
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
        return NO;
    }
    
    return YES;
}

@end
