//
//  GTIOHomeViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/2/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOHomeViewController.h"
#import "TWTAlertViewDelegate.h"
#import "GTIOBarButtonItem.h"
#import "GTIONotificationsOverlayViewController.h"
#import "GTIOOutfit.h"
#import "GTIOOutfitViewController.h"

@interface GTIOHomeViewController (Private)
- (void)loadOutfits;
- (void)snapScrollView:(UIScrollView*)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
@end

@implementation GTIOHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStateChangedNotification:) name:kGTIOUserDidLoginNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStateChangedNotification:) name:kGTIOUserDidLogoutNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStateChangedNotification:) name:kGTIOUserDidEndLoginProcess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationsUpdatedNotification:) name:kGTIONotificationsUpdatedNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(todoBadgeUpdated:) name:kGTIOToDoBadgeUpdatedNotificationName object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_notificationsController release];
    [_lastLoadedAt release];
    [super dealloc];
}

- (void)fadeInTodosBadge {
    _todosBadgeButton.alpha = 1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    GTIOAnalyticsEvent(kUserDidViewHomepageEventName);
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (_backgroundImageView.hidden == YES) {
        _todoButton.titleLabel.alpha = 0;
        _uploadButton.titleLabel.alpha = 0;
        _featuredButton.titleLabel.alpha = 0;
        _browseButton.titleLabel.alpha = 0;
        _todosBadgeButton.alpha = 0;
    }
    
    [self loadOutfits];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_backgroundImageView.hidden == YES) {
        // begin fade in animations
        _backgroundImageView.alpha = 0;
        _backgroundImageView.hidden = NO;
        if (!_animatedInThisLaunch) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:2];
            [UIView setAnimationDelay:1];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(fadeInTodosBadge)];
        }
        _backgroundImageView.alpha = 1;
        if (!_animatedInThisLaunch) {
            [UIView commitAnimations];
        
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:2];
            [UIView setAnimationDelay:2];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        }
        [self scrollViewDidScroll:_scrollView];
//        _uploadButton.titleLabel.alpha = 1;
//        _featuredButton.titleLabel.alpha = 1;
//        _browseButton.titleLabel.alpha = 1;
//        _todoButton.titleLabel.alpha = 1;
//        _todoButton.titleLabel.alpha = 1;
        if (!_animatedInThisLaunch) {
            [UIView commitAnimations];
            _animatedInThisLaunch = YES;
        }
    } else {
        // Reload TODO's and notifications.
        [[GTIOUser currentUser] resumeSession];
    }
}

- (void)updateUserLabel {
    _profileThumbnailView.defaultImage = [UIImage imageNamed:@"empty-profile-pic.png"];
    if ([GTIOUser currentUser].loggedIn) {
        _profileThumbnailView.urlPath = [GTIOUser currentUser].profileIconURL;
        
        _nameLabel.frame = CGRectZero;
        _nameLabel.text = [[GTIOUser currentUser].username uppercaseString];
        _nameLabel.font = kGTIOFetteFontOfSize(22);
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [_nameLabel sizeToFit];
        _nameLabel.frame = CGRectOffset(_nameLabel.bounds, 45, 6);
        
        _locationLabel.frame = CGRectZero;
        _locationLabel.text = [GTIOUser currentUser].location;
        _locationLabel.font = [UIFont systemFontOfSize:13];
        _locationLabel.textColor = RGBCOLOR(156,156,156);
        [_locationLabel sizeToFit];
        _locationLabel.frame = CGRectMake(45, 25, 200, _locationLabel.bounds.size.height);
        _locationLabel.backgroundColor = [UIColor clearColor];
        
    } else {
        _profileThumbnailView.urlPath = nil;
        
        _nameLabel.text = @"my profile";
        _nameLabel.textColor = RGBCOLOR(185,185,185);
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [_nameLabel sizeToFit];
        _nameLabel.frame = CGRectOffset(_nameLabel.bounds, 45, 12);
        
        _locationLabel.text = @"";
    }
}

- (void)updateScrollView {
    BOOL noNotifications = CGRectEqualToRect(_notificationsContainer.frame, CGRectZero);
    int thumbnailContainerOffset = (noNotifications ? 380 : 370) - 8;
    
    [_loadingView removeFromSuperview];
    [_loadingView release];
    _loadingView = nil;
    
    if ([_model isLoading]) {
        UIActivityIndicatorView* spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        [spinner sizeToFit];
        spinner.center = CGPointMake(20,20);
        [spinner startAnimating];
        
        _loadingView = [spinner retain];
        
        _thumbnailContainer.frame = CGRectMake(2,thumbnailContainerOffset, 314, 253);//320);
        [_thumbnailContainer addSubview:_loadingView];
    } else {
        _thumbnailContainer.frame = CGRectMake(2,thumbnailContainerOffset, 314, _thumbnailContainer.bounds.size.height);
    }
    
    [_looksFromOurCommunity sizeToFit];
    _looksFromOurCommunity.frame = CGRectMake(11, _thumbnailContainer.frame.origin.y - 13, 300, _looksFromOurCommunity.bounds.size.height);
    
    int maxY = CGRectGetMaxY(_thumbnailContainer.frame);
    _scrollView.contentSize = CGSizeMake(320,noNotifications ? maxY : maxY + 36);
    
    if (_thumbnailsVisible && _viewJustLoaded) {
        _viewJustLoaded = NO;
        [_scrollView setContentOffset:CGPointMake(0,_scrollView.contentSize.height - _scrollView.bounds.size.height) animated:NO];
    }
    
    [self scrollViewDidScroll:_scrollView];
    [self snapScrollView:_scrollView];
}

- (void)updateNotificationsButton {
    if (!_notificationsVisible) {
        _notificationsContainer.frame = CGRectMake(0,420,320,465);
    }
    if (![[GTIOUser currentUser] isLoggedIn] || [[GTIOUser currentUser].notifications count] == 0) {
        _notificationsContainer.frame = CGRectZero;
    } else if ([[GTIOUser currentUser] numberOfUnseenNotifications] == 0) {
        [_notificationsBadgeButton setTitle:@"" forState:UIControlStateNormal];
        [_notificationsBadgeButton setSelected:NO];
        [_notificationsButton setTitle:@"notifications" forState:UIControlStateNormal];
        _notificationsButton.enabled = YES;
        _notificationsBadgeButton.enabled = YES;
    } else {
        NSString* title = [NSString stringWithFormat:@"new notification%@", ([[GTIOUser currentUser] numberOfUnseenNotifications] == 1 ? @"" : @"s")];
        [_notificationsButton setTitle:title forState:UIControlStateNormal];
        NSString* badgeTitle = [NSString stringWithFormat:@"%d", [[GTIOUser currentUser] numberOfUnseenNotifications]];
        [_notificationsBadgeButton setTitle:badgeTitle forState:UIControlStateNormal];
        [_notificationsBadgeButton setSelected:YES];
        _notificationsButton.enabled = YES;
        _notificationsBadgeButton.enabled = YES;
    }
}

- (void)updateTodoBadge {
    if ([[GTIOUser currentUser].todosBadge intValue] > 0) {
        _todosBadgeButton.hidden = NO;
    } else {
        _todosBadgeButton.hidden = YES;
    }
    NSString* title = [NSString stringWithFormat:@"%d", [[GTIOUser currentUser].todosBadge intValue]];
    [_todosBadgeButton setTitle:title forState:UIControlStateNormal];
    _todosBadgeButton.frame = CGRectMake(251, 106, 23 + (([title length] - 1) * 6), 24);
    
    UIImage* image = [UIImage imageNamed:@"todos-badge.png"];
    UIImage* bgImage = [image stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    [_todosBadgeButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    _todosBadgeButton.contentEdgeInsets = UIEdgeInsetsMake(-2,1,2,0);
}

#pragma mark - Scroll View

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float scrollDistance = scrollView.contentSize.height - scrollView.bounds.size.height;
    float scrollPercentage = scrollView.contentOffset.y / scrollDistance;
    scrollPercentage = MAX(scrollPercentage, 0);
    
    _backgroundImageView.alpha = 1 - sqrt(scrollPercentage);
    _todoButton.titleLabel.alpha = 1 - sqrt(scrollPercentage);
    _uploadButton.titleLabel.alpha = 1 - sqrt(scrollPercentage);
    _featuredButton.titleLabel.alpha = 1 - sqrt(scrollPercentage);
    _browseButton.titleLabel.alpha = 1 - sqrt(scrollPercentage);
    
    _looksFromOurCommunity.alpha = sqrt(scrollPercentage);
    _loadingView.alpha = sqrt(scrollPercentage);
    
}

- (void)snapScrollView:(UIScrollView*)scrollView {
    float scrollDistance = scrollView.contentSize.height - scrollView.bounds.size.height;
    int topOrBottom = (scrollDistance/2 < scrollView.contentOffset.y ? 1 : 0);
    [scrollView setContentOffset:CGPointMake(0,scrollDistance*topOrBottom) animated:YES];
    
    if (topOrBottom == 0) {
        _thumbnailsVisible = NO;
        GTIOAnalyticsEvent(kSwipeUpOnHomeScreen);
    } else {
        _thumbnailsVisible = YES;
        GTIOAnalyticsEvent(kSwipeDownOnHomeScreen);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self snapScrollView:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self snapScrollView:scrollView];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return NO;
}

- (void)loadOutfits {
    if (nil == _lastLoadedAt ||
        [_lastLoadedAt timeIntervalSinceNow] < -(2*60)) {
        RKObjectLoader* objectLoader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(@"/home-outfits") delegate:nil];
        objectLoader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:[NSDictionary dictionary]];
        objectLoader.method = RKRequestMethodPOST;
        [_model cancel];
        [_model release];
        _model = [[GTIOBrowseListTTModel modelWithObjectLoader:objectLoader] retain];
        [_model.delegates addObject:self];
        [_model load:TTURLRequestCachePolicyNone more:NO];
    }
}

- (void)modelDidStartLoad:(id<TTModel>)model {
    [_thumbnailContainer removeAllSubviews];
    // show spinner
    [self updateScrollView];
}

- (void)modelDidFinishLoad:(id<TTModel>)model {
    _lastLoadedAt = [NSDate new];
    
    GTIOBrowseList* list = _model.list;
    float delay = 0.0f;
    float maxHeight = 0;
    // this is duplicated on the welcome screen. should probably be refactored.
    
    for (int i = 0; i < [list.outfits count]; i++) {
        GTIOOutfit* outfit = [list.outfits objectAtIndex:i];
        TTImageView* imageView = [[[TTImageView alloc] initWithFrame:CGRectMake(0,0,71,90)] autorelease];
        imageView.urlPath = outfit.iphoneThumbnailUrl;
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"welcome-thumb-overlay.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(outfitButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        button.tag = i;
        
        int row = floor(i/5);
        int column = i%5;
        int x = 61 * column;
        int y = 80*row;
        CGRect frame = CGRectMake(x,y,71,90);
        maxHeight = CGRectGetMaxY(frame)+3;
        
        imageView.frame = CGRectInset(frame,10,10);
        button.frame = frame;
        [_thumbnailContainer addSubview:imageView];
        [_thumbnailContainer addSubview:button];
        
        imageView.alpha = 0;
        button.alpha = 0;
        delay += 0.1f;
        NSLog(@"Delay: %f", delay);
        [self performSelector:@selector(fadeIn:) withObject:[NSArray arrayWithObjects:imageView, button, nil] afterDelay:delay];
    }
    _thumbnailContainer.frame = CGRectMake(0,0,320,maxHeight);
    [self updateScrollView];
}

- (void)outfitButtonTouched:(id)sender {
    if (_scrollView.contentOffset.y <= 1) {
        return;
    }
    int index = [(UIView*)sender tag];
    NSLog(@"index: %d", index);
    GTIOOutfitViewController* viewController = [[GTIOOutfitViewController alloc] initWithModel:_model outfitIndex:index];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)fadeIn:(NSArray*)items {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0f];
    for (UIView* view in items) {
        view.alpha = 1;
    }
    [UIView commitAnimations];
}

- (void)model:(id<TTModel>)model didFailLoadWithError:(NSError*)error {
    NSLog(@"Error: %@", error);
    _thumbnailContainer.frame = CGRectZero;
    [self updateScrollView];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view insertSubview:_nameLabel belowSubview:_notificationsContainer];
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view insertSubview:_locationLabel belowSubview:_notificationsContainer];
    
    _featuredButton.clipsToBounds = NO;
    _featuredButton.titleLabel.textAlignment = UITextAlignmentCenter;
    
    [self updateUserLabel];
    [self updateNotificationsButton];
    [self updateTodoBadge];
    
    if (_notificationsVisible) {
        [self notificationButtonWasPressed];
    }
    
    [_lastLoadedAt release];
    _lastLoadedAt = nil;
    
    
    _looksFromOurCommunity = [[UILabel alloc] initWithFrame:CGRectZero];
    _looksFromOurCommunity.text = @"looks from our community";
    _looksFromOurCommunity.font = kGTIOFontBoldHelveticaNeueOfSize(12);
    _looksFromOurCommunity.backgroundColor = [UIColor clearColor];
    _looksFromOurCommunity.textColor = RGBCOLOR(210,210,210);
    _looksFromOurCommunity.alpha = 0;
    [_scrollView addSubview:_looksFromOurCommunity];
    
    _viewJustLoaded = YES;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [_nameLabel release];
    _nameLabel = nil;
    [_locationLabel release];
    _locationLabel = nil;
    [_looksFromOurCommunity release];
    _looksFromOurCommunity = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // HRM.. don't really want to do this if we are presenting a modal view controller
    UINavigationController* navController = self.navigationController;
    if (nil == navController.modalViewController) {
        [navController setNavigationBarHidden:NO animated:animated];
    }
}

#pragma mark - Actions

- (IBAction)featuredButtonWasPressed {
    if (_scrollView.contentOffset.y >= 1) {
        return;
    }
    TTOpenURL(@"gtio://featured");
}

- (IBAction)uploadButtonWasPressed {
    if (_scrollView.contentOffset.y >= 1) {
        return;
    }
    TTOpenURL(@"gtio://getAnOpinion");
}

- (IBAction)todosButtonWasPressed {
    if (_scrollView.contentOffset.y >= 1) {
        return;
    }
    TTOpenURL(@"gtio://todos");
}

- (IBAction)browseButtonWasPressed {
    if (_scrollView.contentOffset.y >= 1) {
        return;
    }
    TTOpenURL(@"gtio://browse");
}

- (IBAction)myReviewsButtonWasPressed {
    NSString* apiURL = GTIORestResourcePath([NSString stringWithFormat:@"/profile/%@/reviews", [GTIOUser currentUser].UID]);
    NSString* url = [NSString stringWithFormat:@"gtio://browse/%@", [apiURL stringByReplacingOccurrencesOfString:@"/" withString:@"."]];
    TTOpenURL(url);
}

- (IBAction)profileViewWasTouched {
    if ([[GTIOUser currentUser] isLoggedIn]) {
        TTOpenURL(@"gtio://profile");
    } else {
        TTOpenURL(@"gtio://login");
    }
}

#pragma mark - Notifications

- (void)userStateChangedNotification:(NSNotification*)note {
    [self updateUserLabel];
    [self updateNotificationsButton];
    [self updateTodoBadge];
}

- (void)notificationsUpdatedNotification:(NSNotification*)note {
    [self updateNotificationsButton];
    [self updateScrollView];
}

- (void)todoBadgeUpdated:(NSNotification*)note {
    [self updateTodoBadge];
}

#pragma mark - Notifications View / Button

- (IBAction)notificationButtonWasPressed {
    if (_notificationsVisible) {
        [self closeNotificationsButtonWasPressed];
        return;
    }
    _notificationsVisible = YES;
    _notificationsController = [[GTIONotificationsOverlayViewController alloc] initWithStyle:UITableViewStylePlain];
    _notificationsController.view.frame = CGRectMake(0, _notificationsButton.bounds.size.height - 10, self.view.bounds.size.width, self.view.bounds.size.height - _notificationsButton.bounds.size.height + 15);
    [_notificationsContainer addSubview:_notificationsController.view];
        
    [_notificationsController viewWillAppear:YES];
    [UIView beginAnimations:nil context:nil];
    _notificationsContainer.frame = CGRectMake(0,-5,320, 465);
    _notificationsController.view.frame = CGRectMake(0,39,320,426);
    _closeNotificationsButton.hidden = NO;
    [UIView commitAnimations];
    [_notificationsController viewDidAppear:YES];
}

- (IBAction)closeNotificationsButtonWasPressed {
    _notificationsVisible = NO;
    [UIView beginAnimations:nil context:nil];
    _notificationsContainer.frame = CGRectMake(0,421,320, 465);
    _closeNotificationsButton.hidden = YES;
    [UIView commitAnimations];
    [_notificationsController.view removeFromSuperview];
    [_notificationsController release];
    _notificationsController = nil;
}

@end
