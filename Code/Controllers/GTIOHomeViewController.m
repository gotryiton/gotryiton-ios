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

static float const dragOffsetReloadDistance = 40.0f;

@implementation GTIOLoadMoreThumbnailsView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home-pull-widget-bg.png"]];
        _textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)] autorelease];
        _textLabel.textAlignment = UITextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = kGTIOFontHelveticaNeueOfSize(14);
        _textLabel.textColor = kGTIOColor5A5A5A;
        _textLabel.text = @"more looks";
        [self addSubview:_textLabel];
        
        _arrowImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 26, 30)] autorelease];
        _arrowImageView.center = CGPointMake(320/2, 30);
        _arrowImageView.image = [UIImage imageNamed:@"home-pull-widget-arrow.png"];
        [self addSubview:_arrowImageView];
    }
    return self;
}

- (void)setDragOffset:(float)offset {
    [UIView beginAnimations:nil context:nil];
    if (dragOffsetReloadDistance > offset) {
        _textLabel.text = @"more looks";
        // orient arrow pointing up
        _arrowImageView.transform = CGAffineTransformIdentity;
    } else {
        _textLabel.text = @"release to load";
        // orient arrow pointing down
        _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }
    [UIView commitAnimations];
}

@end

@interface GTIOHomeViewController (Private)
- (void)loadOutfits;
- (void)loadMoreThumbnails;
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
        } else {
            [self fadeInTodosBadge];
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
    
    if ([_model isLoading]) {
        [_loadingView startAnimating];
        
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
    
    // Pull Up To Load More
    float distancePastBottomInPixels = scrollView.contentOffset.y - scrollDistance;
    [_loadMoreView setDragOffset:distancePastBottomInPixels];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // Pull Up To Load More
    float scrollDistance = scrollView.contentSize.height - scrollView.bounds.size.height;
    NSLog(@"Scroll Distance: %f", scrollView);
    NSLog(@"Y Offset: %f", scrollView.contentOffset.y);
    float distancePastBottomInPixels = scrollView.contentOffset.y - scrollDistance;
    NSLog(@"Distance past bottom: %f", distancePastBottomInPixels);
    if (distancePastBottomInPixels > dragOffsetReloadDistance) {
        [self loadMoreThumbnails];
    }
    
    if (!decelerate) {
        [self snapScrollView:scrollView];
    }
}

- (void)snapScrollView:(UIScrollView*)scrollView {
    float scrollDistance = scrollView.contentSize.height - scrollView.bounds.size.height;
    int topOrBottom = (scrollDistance/2 < scrollView.contentOffset.y ? 1 : 0);
    if (topOrBottom == 1 && [_model isLoadingMore]) {
        topOrBottom += scrollView.contentInset.bottom;
    }
    [scrollView setContentOffset:CGPointMake(0,scrollDistance*topOrBottom) animated:YES];
    
    if (topOrBottom == 0) {
        _thumbnailsVisible = NO;
        GTIOAnalyticsEvent(kSwipeUpOnHomeScreen);
    } else {
        _thumbnailsVisible = YES;
        GTIOAnalyticsEvent(kSwipeDownOnHomeScreen);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self snapScrollView:scrollView];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return NO;
}

- (void)loadOutfits {
    if (nil == _lastLoadedAt || [_lastLoadedAt timeIntervalSinceNow] < -(10*60)) {
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
    _currentlyDisplayedOutfitsIndex = -1;
    // show spinner
    [self updateScrollView];
}

- (void)modelDidFinishLoad:(id<TTModel>)model {
    [_lastLoadedAt release];
    _lastLoadedAt = [NSDate new];
    
    float delay = 0.0f;
    float maxHeight = 0;
    NSArray* outfits = _model.objects;
    // this is duplicated on the welcome screen. should probably be refactored.
    
    for (int i = _currentlyDisplayedOutfitsIndex+1; i < [outfits count]; i++) {
        int j = i-(_currentlyDisplayedOutfitsIndex+1);
        int row = floor(j/5);
        int column = j%5;
        int x = 61 * column;
        int y = 80*row;
        CGRect frame = CGRectMake(x,y,71,90);
        maxHeight = CGRectGetMaxY(frame)+3;
        
        GTIOOutfit* outfit = [outfits objectAtIndex:i];
        TTImageView* imageView = [[[TTImageView alloc] initWithFrame:CGRectMake(0,0,71,90)] autorelease];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.urlPath = outfit.iphoneThumbnailUrl;
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"welcome-thumb-overlay.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(outfitButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        button.tag = i;
    
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
    _currentlyDisplayedOutfitsIndex = [outfits count] - 1;
    
    if (_model.hasMoreToLoad) {
//        maxHeight += 20;
        _loadMoreView.frame = CGRectMake(0, maxHeight-10, _loadMoreView.bounds.size.width, _loadMoreView.bounds.size.height);
        [_thumbnailContainer addSubview:_loadMoreView];
    } else {
        [_loadMoreView removeFromSuperview];
    }
    
    _thumbnailContainer.frame = CGRectMake(0,0,320,maxHeight);
    [self updateScrollView];
}

- (void)loadMoreThumbnails {
    if (!_model.hasMoreToLoad) {
        return;
    }
    [_model load:TTURLRequestCachePolicyNone more:YES];
    [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, 30, 0)];
    
    [_loadingView startAnimating];
    
    [UIView beginAnimations:@"Hide Thumbnails" context:nil];
    
    for (UIView* view in _thumbnailContainer.subviews) {
        if (view != _loadingView &&
            view != _loadMoreView) {
            view.alpha = 0;
        }
    }
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
}
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void*)context {
    [_thumbnailContainer removeAllSubviews];
    [_thumbnailContainer addSubview:_loadingView];
    [_thumbnailContainer addSubview:_loadMoreView];
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
    
    _loadMoreView = [[GTIOLoadMoreThumbnailsView alloc] initWithFrame:CGRectMake(0, 0, 320, 335)];
    
    _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_loadingView sizeToFit];
    _loadingView.center = CGPointMake(20,20);
    _loadingView.hidesWhenStopped = YES;
    [_thumbnailContainer addSubview:_loadingView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [_nameLabel release];
    _nameLabel = nil;
    [_locationLabel release];
    _locationLabel = nil;
    [_looksFromOurCommunity release];
    _looksFromOurCommunity = nil;
    [_loadMoreView release];
    _loadMoreView = nil;
    [_loadingView release];
    _loadingView = nil;
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
    if([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
        if (![[[TTNavigator navigator] topViewController] isKindOfClass:[GTIOOutfitViewController class]] &&
            ![[[TTNavigator navigator] topViewController] isKindOfClass:[GTIOHomeViewController class]]) {
            NSLog(@"Navigation Controller: %@", self.navigationController.navigationBar);
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
        }
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
//    [_notificationsController invalidateModel];
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

- (void)disposeOfNotificationsController:(NSString*)animationID {
    [_notificationsController.view removeFromSuperview];
    [_notificationsController release];
    _notificationsController = nil;
    [self notificationsUpdatedNotification:nil];
}

- (IBAction)closeNotificationsButtonWasPressed {
    _notificationsVisible = NO;
    [UIView beginAnimations:nil context:nil];
    _notificationsContainer.frame = CGRectMake(0,421,320, 465);
    _closeNotificationsButton.hidden = YES;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(disposeOfNotificationsController:)];
    [UIView commitAnimations];
}

@end
