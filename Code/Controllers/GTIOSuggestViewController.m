//
//  GTIOSuggestViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 2/1/12.
//  Copyright (c) 2012 Two Toasters, LLC. All rights reserved.
//

#import "GTIOSuggestViewController.h"
#import "GTIOBarButtonItem.h"
#import "GTIOProduct.h"
#import "GTIOHeaderView.h"

@interface GTIOSuggestViewController () {
    NSString* _outfitID;
    BOOL _isShowingLoading;
}

@property (nonatomic, retain) IBOutlet UIWebView* webView;
@property (nonatomic, retain) IBOutlet UIView *toolbar;
@property (nonatomic, retain) IBOutlet UIButton* backButtonItem;
@property (nonatomic, retain) IBOutlet UIButton* forwardButtonItem;
@property (retain, nonatomic) IBOutlet UIButton* recommendButtonItem;
@property (nonatomic, retain) GTIOProduct* currentProduct;
@property (retain, nonatomic) IBOutlet UIView *loadingOverlay;

- (IBAction)suggestButtonWasPressed:(id)sender;
- (void)loadWebView;
- (void)showLoading;
- (void)hideLoading;

@end

@implementation GTIOSuggestViewController

@synthesize webView = _webView;
@synthesize toolbar = _toolbar;
@synthesize backButtonItem = _backButtonItem;
@synthesize forwardButtonItem = _forwardButtonItem;
@synthesize recommendButtonItem = _recommendButtonItem;
@synthesize currentProduct = _currentProduct;
@synthesize loadingOverlay = _loadingOverlay;


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
    [_toolbar release];
    [_loadingOverlay release];
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
    [self setToolbar:nil];
    [self setRecommendButtonItem:nil];
    [self setLoadingOverlay:nil];
    [self setLoadingOverlay:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setTitle:(NSString *)title
{
    self.navigationItem.titleView = [GTIOHeaderView viewWithText:title];
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
    self.title = @"SUGGEST";
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
        self.currentProduct = nil; // Clear out current product before scraping the next one.
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:GTIORestResourcePath(@"/scrape") delegate:self block:^(RKObjectLoader* loader) {
            loader.params = [NSDictionary dictionaryWithObjectsAndKeys:
                             [GTIOUser currentUser].token, @"gtioToken",
                             [url absoluteString], @"url", nil];
            loader.method = RKRequestMethodPOST;
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
        NSString* productID = [string stringByReplacingOccurrencesOfString:@"gtio://recommend/" withString:@""];
        // TODO: handle selected outfit id.
        NSString* path = [NSString stringWithFormat:@"/product/%@", productID];
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:GTIORestResourcePath(path)
                                                          delegate:self
                                                             block:^(RKObjectLoader* loader) {
            loader.method = RKRequestMethodPOST;
            loader.params = [NSDictionary dictionaryWithObjectsAndKeys:
                             [GTIOUser currentUser].token, @"gtioToken", nil];
        }];
        [self showLoading];
        return YES;
    } else if ([string rangeOfString:@"gtio://"].location != NSNotFound ||
               [string rangeOfString:@"gtio:://"].location != NSNotFound) {
        NSLog(@"GTIO:// url is not handled: %@", url);
        return YES;
    }
    return NO;
}

- (void)suggest:(GTIOProduct*)product
{
    [self hideLoading];
//    TTAlert(@"Suggesting Product!, not yet implemented");
    [product encodeWebView:self.webView];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOSuggestionMadeNotification
                                                        object:_outfitID
                                                      userInfo:[NSDictionary dictionaryWithObject:product forKey:kGTIOProductNotificationKey]];
}

- (IBAction)suggestButtonWasPressed:(id)sender
{
    if (self.currentProduct) {
        [self suggest:self.currentProduct];
    } else {
        // /scrape has not yet returned.
        [self showLoading];
    }
}

#pragma mark Loading Methods

- (void)showLoading {
    NSLog(@"Show Loading...");
    _isShowingLoading = YES;
    self.loadingOverlay.frame = self.view.bounds;
    [self.view addSubview:self.loadingOverlay];
}

- (void)hideLoading {
    NSLog(@"Hide Loading...");
    _isShowingLoading = NO;
    [self.loadingOverlay removeFromSuperview];
}

- (BOOL)isShowingLoading {
    return _isShowingLoading;
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    /* Special Urls:
       gtio://recommend/[product_id]
       gtio://recommend/bottomNav/hide
       gtio://recommend/bottomNav/show
    */
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
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.backButtonItem.enabled = [webView canGoBack];
    self.forwardButtonItem.enabled = [webView canGoForward];
    [self toggleToolbar:webView.request.URL];
    if ([self isLocalURL:webView.request.URL]) {
        self.title = @"SUGGEST";
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"WebView: %@ Error: %@", webView.request, [error localizedDescription]);
}

#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error
{
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object {
    NSLog(@"Object: %@", object);
    GTIOProduct* product = object;
    // Update Nav Bar Title based on this object.
    NSAssert(product, @"Expected a product, didn't get one. %@", objectLoader);
    self.title = product.brand;
    if ([objectLoader.resourcePath isEqualToString:GTIORestResourcePath(@"/scrape")]) {
        // Update nav bar title.
        self.currentProduct = product;
        if ([self isShowingLoading]) {
            // if the user already tapped the recommend button (we're showing the loading overlay),
            // then we should select this product as the one to recommend
            [self suggest:self.currentProduct];
        }
        
    } else {
        // User recommended this product.
        [self suggest:product];
    }
}

@end
