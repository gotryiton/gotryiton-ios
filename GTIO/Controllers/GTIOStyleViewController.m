//
//  GTIOShopViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOStyleViewController.h"

#import "GTIOWebView.h"
#import "GTIONavigationNotificationTitleView.h"

@interface GTIOStyleViewController ()

@property (nonatomic, strong) GTIOWebView *webView;

@end

@implementation GTIOStyleViewController

@synthesize webView = _webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"checkered-bg.png"]]];
    
    UIImageView *statusBarBackgroundImageView = [[UIImageView alloc] initWithFrame:(CGRect){ { 0, -20 }, { self.view.frame.size.width, 20 } }];
    [statusBarBackgroundImageView setImage:[UIImage imageNamed:@"status-bar-bg.png"]];
    [self.view addSubview:statusBarBackgroundImageView];
    
    GTIONavigationNotificationTitleView *navTitleView = [[GTIONavigationNotificationTitleView alloc] initWithNotifcationCount:[NSNumber numberWithInt:0] tapHandler:nil];
    [self useTitleView:navTitleView];
    
    self.webView = [[GTIOWebView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height } }];
    [self.webView setBackgroundColor:[UIColor whiteColor]];
    [self.webView.scrollView setDecelerationRate:UIScrollViewDecelerationRateNormal];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.webView.scrollView setScrollIndicatorInsets:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.webView.scrollView setContentInset:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.view addSubview:self.webView];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/iphone/style-tab", kGTIOBaseURLString]];
    [self.webView loadGTIORequestWithURL:URL];
    
    // TODO: Need error state
    // TODO: Need loading spinner
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
