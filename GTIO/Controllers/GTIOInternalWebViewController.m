//
//  GTIOInternalWebViewController.m
//  GTIO
//
//  Created by Scott Penrose on 7/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOInternalWebViewController.h"

#import "GTIONavigationTitleView.h"
#import "GTIOWebView.h"

@interface GTIOInternalWebViewController ()

@property (nonatomic, strong) GTIOWebView *webView;

@end

@implementation GTIOInternalWebViewController

@synthesize URL = _URL, titleURLEncoded = _titleURLEncoded;
@synthesize webView = _webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"checkered-bg.png"]]];
    
    UIImageView *statusBarBackgroundImageView = [[UIImageView alloc] initWithFrame:(CGRect){ { 0, -20 }, { self.view.frame.size.width, 20 } }];
    [statusBarBackgroundImageView setImage:[UIImage imageNamed:@"status-bar-bg.png"]];
    [self.view addSubview:statusBarBackgroundImageView];
    
    
    NSString *title = [self.titleURLEncoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:title italic:YES];
    [self useTitleView:navTitleView];
    
    self.webView = [[GTIOWebView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height } }];
    [self.webView setBackgroundColor:[UIColor whiteColor]];
    [self.webView.scrollView setDecelerationRate:UIScrollViewDecelerationRateNormal];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.webView.scrollView setScrollIndicatorInsets:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.webView.scrollView setContentInset:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.view addSubview:self.webView];
    
    [self.webView loadGTIORequestWithURL:self.URL];
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

@end
