//
//  GTIOWebViewController.m
//  GTIO
//
//  Created by Scott Penrose on 7/13/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOWebViewController.h"

#import "GTIOButton.h"

#import "GTIOWebView.h"
#import "GTIONavigationTitleView.h"
#import "GTIOToolBarButton.h"
#import "GTIOActionSheet.h"

#import "GTIORouter.h"
#import "GTIOMailComposer.h"

static NSString * const kGTIOEmailThisLink = @"email this link";
static NSString * const kGTIOOpenInSafari = @"open in Safari";

@interface GTIOWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) GTIOWebView *webView;
@property (nonatomic, strong) GTIONavigationTitleView *navigationTitleView;

@property (nonatomic, strong) GTIOToolBarButton *backBarButton;
@property (nonatomic, strong) GTIOToolBarButton *forwardBarButton;
@property (nonatomic, strong) GTIOToolBarButton *reloadBarButton;
@property (nonatomic, strong) GTIOToolBarButton *actionsBarButton;

@end

@implementation GTIOWebViewController

@synthesize webView = _webView;
@synthesize navigationTitleView = _navigationTitleView;
@synthesize URL = _URL;
@synthesize backBarButton = _backBarButton, forwardBarButton = _forwardBarButton, reloadBarButton = _reloadBarButton, actionsBarButton = _actionsBarButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setHidesBottomBarWhenPushed:YES];
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
    
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [self.webView stopLoading];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.leftNavigationButton = backButton;
    
    // Toolbar setup
    [self.navigationController setToolbarHidden:NO];
    [self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:@"webview-tab-bg.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    
    self.backBarButton = [GTIOToolBarButton buttonWithToolBarButtonType:GTIOToolBarButtonTypeBack tapHandler:^(id sender){
        [self.webView goBack];
    }];
    self.forwardBarButton = [GTIOToolBarButton buttonWithToolBarButtonType:GTIOToolBarButtonTypeForward tapHandler:^(id sender){
        [self.webView goForward];
    }];
    self.reloadBarButton = [GTIOToolBarButton buttonWithToolBarButtonType:GTIOToolBarButtonTypeReload tapHandler:^(id sender){
        [self.webView reload];
    }];
    self.actionsBarButton = [GTIOToolBarButton buttonWithToolBarButtonType:GTIOToolBarButtonTypeAction tapHandler:^(id sender){ 
        // Actionsheet setup
        GTIOButton *emailThisLinkButton = [[GTIOButton alloc] init];
        [emailThisLinkButton setText:kGTIOEmailThisLink];
        [emailThisLinkButton setState:[NSNumber numberWithInt:1]];
        
        GTIOButton *openInSafariButton = [[GTIOButton alloc] init];
        [openInSafariButton setText:kGTIOOpenInSafari];
        [openInSafariButton setAction:[GTIOButtonAction buttonActionWithDestination:[NSString stringWithFormat:@"gtio://safari/url"]]];
        [openInSafariButton setState:[NSNumber numberWithInt:1]];
        
        // ActionSheet
        GTIOActionSheet *actionSheet = [[GTIOActionSheet alloc] initWithButtons:[NSArray arrayWithObjects:emailThisLinkButton, openInSafariButton, nil] buttonTapHandler:^(GTIOActionSheet *actionSheet, GTIOButton *buttonModel){
            
            if ([buttonModel.text isEqualToString:kGTIOEmailThisLink]) {
                GTIOMailComposer *mailComposer = [[GTIOMailComposer alloc] init];
                [mailComposer.mailComposeViewController setSubject:self.navigationTitleView.title];
                [mailComposer.mailComposeViewController setMessageBody:[self.webView.request.URL absoluteString] isHTML:NO];
                [mailComposer setDidFinishHandler:^(MFMailComposeViewController *controller, MFMailComposeResult result, NSError *error){ 
                    [mailComposer.mailComposeViewController dismissModalViewControllerAnimated:YES];
                }];
                [self.navigationController presentModalViewController:mailComposer.mailComposeViewController animated:YES];
            } else if ([buttonModel.text isEqualToString:kGTIOOpenInSafari]) {
                [[UIApplication sharedApplication] openURL:self.webView.request.URL];
            }
            
            [actionSheet dismiss];
        }];
        [actionSheet show];
    }];
    
    UIBarButtonItem *backSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [backSpacer setWidth:3.0f];
    
    UIBarButtonItem *actionSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [actionSpacer setWidth:(self.view.frame.size.width / 2) - (self.reloadBarButton.customView.frame.size.width) - self.actionsBarButton.customView.frame.size.width - backSpacer.width - 2];

    UIBarButtonItem *flexibleSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self setToolbarItems:[NSArray arrayWithObjects:backSpacer, self.backBarButton, flexibleSpacer, self.forwardBarButton, flexibleSpacer, self.reloadBarButton, actionSpacer, self.actionsBarButton, backSpacer, nil]];
	
    self.webView = [[GTIOWebView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height } }];
    [self.webView setBackgroundColor:[UIColor whiteColor]];
    [self.webView.scrollView setScrollIndicatorInsets:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.webView.scrollView setContentInset:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.webView setDelegate:self];
    [self.view addSubview:self.webView];
    
    [self updateButtonState];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
    [self.webView loadRequest:request];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webView = nil;
    self.navigationTitleView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Buttons

- (void)updateButtonState
{
    [self.backBarButton setEnabled:[self.webView canGoBack]];
    [self.forwardBarButton setEnabled:[self.webView canGoForward]];
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

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self updateButtonState];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self updateButtonState];
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationTitleView = [[GTIONavigationTitleView alloc] initWithTitle:title italic:YES];
    [self useTitleView:self.navigationTitleView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self updateButtonState];
}

@end
