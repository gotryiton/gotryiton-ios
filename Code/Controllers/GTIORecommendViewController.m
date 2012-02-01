//
//  GTIORecommendViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 2/1/12.
//  Copyright (c) 2012 Two Toasters, LLC. All rights reserved.
//

#import "GTIORecommendViewController.h"
#import "GTIOBarButtonItem.h"

@interface GTIORecommendViewController () {
    NSString* _outfitID;
}

@property (nonatomic, retain) IBOutlet UIWebView* webView;
@property (nonatomic, retain) IBOutlet UIToolbar* toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* backButtonItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* forwardButtonItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* recommendButtonItem;

- (void)loadWebView;

@end

@implementation GTIORecommendViewController

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
    self = [self initWithNibName:@"GTIORecommendViewController" bundle:[NSBundle mainBundle]];
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

- (void)hideToolbar
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

- (void)showToolbar
{
    [UIView animateWithDuration:0.5 animations:^{
        self.toolbar.frame = CGRectOffset(self.toolbar.bounds, 0, self.view.bounds.size.height);
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

@end
