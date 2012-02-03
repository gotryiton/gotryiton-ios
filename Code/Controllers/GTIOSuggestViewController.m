//
//  GTIOSuggestViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 2/1/12.
//  Copyright (c) 2012 Two Toasters, LLC. All rights reserved.
//

#import "GTIOSuggestViewController.h"
#import "GTIOBarButtonItem.h"

@interface GTIOSuggestViewController () {
    NSString* _outfitID;
}

@property (nonatomic, retain) IBOutlet UIWebView* webView;
@property (nonatomic, retain) IBOutlet UIToolbar* toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* backButtonItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* forwardButtonItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* recommendButtonItem;

- (void)loadWebView;

@end

@implementation GTIOSuggestViewController

@synthesize webView = _webView;
@synthesize toolbar = _toolbar;
@synthesize backButtonItem = _backButtonItem;
@synthesize forwardButtonItem = _forwardButtonItem;
@synthesize recommendButtonItem = _recommendButtonItem;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.leftBarButtonItem = [GTIOBarButtonItem backButton];
    }
    return self;
}

- (id)initWithOutfitID:(NSString*)outfitID
{
    self = [self initWithNibName:@"GTIOSuggestViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _outfitID = [outfitID retain];
    }
    return self;
}

- (void)dealloc
{
    [_outfitID release];
    [_webView release];
    [_toolbar release];
    [_backButtonItem release];
    [_forwardButtonItem release];
    [_recommendButtonItem release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadWebView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showToolbar
{
    [UIView animateWithDuration:0.5 animations:^{
        self.toolbar.frame = CGRectOffset(self.toolbar.bounds,
                                          0,
                                          self.view.bounds.size.height - self.toolbar.bounds.size.height);
        self.webView.frame = CGRectMake(0,
                                        0,
                                        self.view.bounds.size.width,
                                        self.view.bounds.size.height - self.toolbar.bounds.size.height);
    }];
}

- (void)hideToolbar
{
    [UIView animateWithDuration:0.5 animations:^{
        self.toolbar.frame = CGRectOffset(self.toolbar.bounds, 0, self.view.height);
        self.webView.frame = self.view.bounds;
    }];
}

- (void)loadWebView {
    NSString* url = [NSString stringWithFormat:@"%@/iphone/rec/%@?gtioToken=%@",
                     kGTIOBaseURLString,
                     _outfitID,
                     [GTIOUser currentUser].token];
    NSURLRequest* request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

- (IBAction)goBack:(id)sender
{
    [self.webView goBack];
}

- (IBAction)goForward:(id)sender
{
    [self.webView goForward];
}

- (BOOL)isLocalURL:(NSURL*)url {
    NSString* host = [[NSURL URLWithString:kGTIOBaseURLString] host];
    return [[url host] isEqualToString:host];
}

- (void)toggleToolbar:(NSURL*)url {
    if ([self isLocalURL:url]) {
        [self hideToolbar];
    } else {
        [self showToolbar];
    }
}

- (void)scrapeURL:(NSURL*)url {
    if (![self isLocalURL:url]) {
        NSLog(@"Scraping: %@", [url absoluteString]);
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:GTIORestResourcePath(@"/rest/v4/scrape") delegate:self block:^(RKObjectLoader* loader) {
            loader.params = [NSDictionary dictionaryWithObjectsAndKeys:
                             [GTIOUser currentUser].token, @"token",
                             [url absoluteString], @"url", nil];
        }];
    }
}

- (BOOL)handleSpecialURL:(NSURL*)url {
    NSString* string = [url absoluteString];
    if ([string isEqualToString:@"gtio://recommend/bottomNav/hide"]) {
        [self hideToolbar];
        return YES;
    } else if ([string isEqualToString:@"gtio://recommend/bottomNav/show"]) {
        [self showToolbar];
        return YES;
    } else if ([string rangeOfString:@"gtio://recommend/"].location != NSNotFound) {
        NSString* outfitID = [string stringByReplacingOccurrencesOfString:@"gtio://recommend/" withString:@""];
        // TODO: handle selected outfit id.
        TTAlert([NSString stringWithFormat:@"TODO: Recommend %@", outfitID]);
        return YES;
    }
    return NO;
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    /* Special Urls:
       gtio://recommend/[product_id]
       gtio://recommend/bottomNav/hide
       gtio://recommend/bottomNav/show
    */
//    NSLog(@"Should Load Request: %@ navigationType: %d", request, navigationType);
    if (![self handleSpecialURL:request.URL]) {
        [self toggleToolbar:request.URL];
        if (navigationType != UIWebViewNavigationTypeOther) {
            [self scrapeURL:request.URL];
        }
        return YES;
    }
    return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    NSLog(@"Started Load: %@", webView.request);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSLog(@"Finished Load: %@", webView.request);
    self.backButtonItem.enabled = [webView canGoBack];
    self.forwardButtonItem.enabled = [webView canGoForward];
    [self toggleToolbar:webView.request.URL];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"WebView Error: %@", [error localizedDescription]);
}

#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error
{
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Objects: %@", objects);
}

@end
