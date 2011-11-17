//
//  GTIOOutfitViewController.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/17/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOOutfitViewController.h"
#import <TWTActionSheetDelegate.h>
#import <TWTAlertViewDelegate.h>
#import "GTIOEditOutfitViewController.h"
#import "GTIOOutfitPageView.h"
#import "GTIOReview.h"
#import "GTIOHomeViewController.h"
#import "GTIOStaticOutfitListModel.h"


@interface GTIOOutfitViewController (shouldReloadPage)
- (void)scrollView:(GTIOScrollView*)scrollView shouldReloadPage:(GTIOOutfitPageView*)page;
@end

@implementation GTIOOutfitViewController

@synthesize state = _state;
@synthesize outfitIndex = _outfitIndex;
@synthesize model = _model;

- (id)initWithOutfitID:(NSString*)outfitID {
	if (self = [super initWithNibName:nil bundle:nil]) {
		NSLog(@"Init With Outfit ID: %@", outfitID);
		_state = GTIOOutfitViewStateFullscreen;
		
        NSDictionary* params = [GTIOUser paramsByAddingCurrentUserIdentifier:[NSDictionary dictionary]];
		NSString* path = GTIORestResourcePath([NSString stringWithFormat:@"/outfit/%@?%@", outfitID, [params URLEncodedString]]);
        
		_outfitIndex = 0;
		_scrollViewDataSource = [[GTIOOutfitViewScrollDataSource alloc] init];
		_scrollViewDataSource.model = _model;
        
        _loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:path delegate:self];
        [_loader send];

		self.hidesBottomBarWhenPushed = YES;
        
        self.navigationItem.backBarButtonItem = [[[GTIOBarButtonItem alloc] initWithTitle:@"back" 
                                                                                  
                                                                                 target:nil 
                                                                                 action:nil] autorelease];
        
	}
	return self;
}

- (id)initWithModel:(GTIOPaginatedTTModel*)model outfitIndex:(int)index {
	if (self = [super initWithNibName:nil bundle:nil]) {
		_state = GTIOOutfitViewStateShowControls;
		self.model = model;
		_outfitIndex = index;
		
		_scrollViewDataSource = [[GTIOOutfitViewScrollDataSource alloc] init];
		_scrollViewDataSource.model = _model;
		
		self.hidesBottomBarWhenPushed = YES;
	}
	return self;
}

- (void)dealloc {
    _loader.delegate = nil;
    [[RKRequestQueue sharedQueue] cancelRequestsWithDelegate:self];
	[_scrollViewDataSource release];
	_scrollViewDataSource = nil;
    [_scrollView release];
    _scrollView = nil;
    //    [_model cancel];
	[_model.delegates removeObject:self];
	[_model release];
	_model = nil;
    [super dealloc];
}

- (void)release {
    [super release];
}

- (void)setModel:(GTIOPaginatedTTModel *)model {
	[model retain];
	[_model.delegates removeObject:self];
	[_model release];
	[model.delegates addObject:self];
	_model = model;
}

- (void)viewDidUnload {
	TT_RELEASE_SAFELY(_headerView);
	TT_RELEASE_SAFELY(_scrollView);
    TT_RELEASE_SAFELY(_headerShadowView);
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView {
	[super loadView];
    
    self.view.accessibilityLabel = @"Outfit Screen";
	
    NSArray* controllers = [(UINavigationController*)self.parentViewController viewControllers];
    UIViewController* viewControllerAboveThisOne = [controllers objectAtIndex:[controllers indexOfObject:self] - 1];
    if ([viewControllerAboveThisOne isKindOfClass:[GTIOHomeViewController class]]) {
        self.navigationItem.leftBarButtonItem = [GTIOBarButtonItem homeBackBarButtonWithTarget:self action:@selector(popViewController)];
    } else {
        self.navigationItem.leftBarButtonItem = [GTIOBarButtonItem listBackBarButtonWithTarget:self action:@selector(popViewController)];
    }
    
	// Set up header view.
	_headerView = [[GTIOOutfitTitleView alloc] initWithFrame:CGRectMake(85, 2, 500, 40)];
	self.navigationItem.titleView = _headerView;
	
	UIBarButtonItem* profileButton = [[[GTIOBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"profile.png"] target:self action:@selector(openProfileButtonWasPressed:)] autorelease];
	self.navigationItem.rightBarButtonItem = profileButton;
	
	self.navigationItem.backBarButtonItem = [[[GTIOBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:nil action:nil] autorelease];
	
	_scrollView = [[GTIOScrollView alloc] initWithFrame:self.view.bounds];
	_scrollView.delegate = self;
	_scrollView.dataSource = _scrollViewDataSource;
	[_scrollView setCenterPageIndex:_outfitIndex];
	_scrollView.dragToRefresh = YES;
	[self.view addSubview:_scrollView];
	
	// Trigger neccesary UI updates.
	self.state = _state;
    
    _headerShadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list-top-shadow.png"]];
    [self.view addSubview:_headerShadowView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view;
    
    [self.navigationController.navigationBar setNeedsDisplay]; // Force navigation bar to redraw to get custom background
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    if([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"outfit-navbar.png"] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    GTIOOutfitPageView* page = (GTIOOutfitPageView*)_scrollView.centerPage;
    [page didAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setNeedsDisplay]; // Force navigation bar to redraw to rest background
    [[[TTNavigator navigator].window findFirstResponderInView:self.view] resignFirstResponder];
    
    _ourNavigationController = self.navigationController;
    
    if([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
        if (![[[TTNavigator navigator] topViewController] isKindOfClass:[GTIOOutfitViewController class]] &&
            ![[[TTNavigator navigator] topViewController] isKindOfClass:[GTIOHomeViewController class]]) {
            NSLog(@"Navigation Controller: %@", self.navigationController.navigationBar);
            [_ourNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    _ourNavigationController = nil;
    [super viewDidDisappear:animated];
}

- (void)goLeftButtonWasPressed:(id)sender {
	GTIOOutfitPageView* page = (GTIOOutfitPageView*)_scrollView.centerPage;
	GTIOMultiOutfitOverlay* overlay = [page valueForKey:@"_overlay"];
	if (CGRectEqualToRect(overlay.frame , page.bounds)) {
		return;
	}
	
	if ([page isMultiLookOutfit] && [page hasPreviousLook]) {
		[page showPreviousLook];
	} else if (_outfitIndex > 0) {
		[_scrollView moveToPageAtIndex:_outfitIndex - 1 resetEdges:YES];
	}
}

- (void)goRightButtonWasPressed:(id)sender {
	GTIOOutfitPageView* page = (GTIOOutfitPageView*)_scrollView.centerPage;
	GTIOMultiOutfitOverlay* overlay = [page valueForKey:@"_overlay"];
	if (CGRectEqualToRect(overlay.frame , page.bounds)) {
		return;
	}
	
	if ([page isMultiLookOutfit] && [page hasNextLook]) {
		[page showNextLook];
	} else if (_outfitIndex < [_scrollView numberOfPages] - 1) {
		[_scrollView moveToPageAtIndex:_outfitIndex + 1 resetEdges:YES];
	}
}

- (void)openProfileButtonWasPressed:(id)sender {
	NSString* profileURL = [NSString stringWithFormat:@"gtio://profile/%@", self.outfit.uid];
	TTOpenURL(profileURL);
}

- (void)updateView {
	GTIOOutfitPageView* page = (GTIOOutfitPageView*)_scrollView.centerPage;
    
	// TODO: clean up. don't use KVC.
	for (GTIOOutfitPageView* offscreenPage in [_scrollView valueForKey:@"_pages"]) {
		if ((page != offscreenPage) && ([offscreenPage isKindOfClass:[GTIOOutfitPageView class]])) {
			[offscreenPage mayHaveDisappeared];
		}
	}
	[page didAppear];
    
    if (self.outfit == nil) {
        _headerView.name = @"";
        _headerView.location = @"";
        [_headerView setBadges:nil];
        [_headerView setNeedsDisplay];
        // tell page to show empty.
        return;
    }
	
	_headerView.name = [self.outfit.name uppercaseString];
	_headerView.location = self.outfit.location;
    [_headerView setBadges:self.outfit.badges];
	[_headerView setNeedsDisplay];
	
	// Here we want to make the pages match. don't animate.
	_state = GTIOOutfitViewStateShowControls;
	[(GTIOOutfitPageView*)_scrollView.centerPage setState:_state animated:NO];
}

- (void)scrollView:(TTScrollView*)scrollView didMoveToPageAtIndex:(NSInteger)pageIndex {
    GTIOAnalyticsEvent(kOutfitPageView);
	_outfitIndex = pageIndex;
	[self updateView];
}

- (void)setState:(GTIOOutfitViewState)state {
//	_state = state;
    GTIOOutfitPageView* page = (GTIOOutfitPageView*)_scrollView.centerPage;
	[page setState:state animated:YES];
    _state = page.state;
}

- (void)scrollView:(TTScrollView*)scrollView tapped:(UITouch*)touch {
	GTIOOutfitPageView* page = (GTIOOutfitPageView*)scrollView.centerPage;
	
	if (TTOSVersion() < 3.2) {
		[touch setValue:[TTNavigator navigator].window forKey:@"_window"];
	}
	
	if ([page continueAfterHandlingTouch:touch forState:&_state]) {
		switch (_state) {
			case GTIOOutfitViewStateFullDescription:
				self.state = GTIOOutfitViewStateShowControls;
				break;
			case GTIOOutfitViewStateShowControls:
				self.state = GTIOOutfitViewStateFullscreen;
				break;
			case GTIOOutfitViewStateFullscreen:
				[_scrollView zoomToFit];
				self.state = GTIOOutfitViewStateShowControls;
				break;
		}
	}
}

- (void)showReviewsButtonWasPressed:(id)sender {
	NSLog(@"Show Reviews!");
	NSString* url = [NSString stringWithFormat:@"gtio://show_reviews/%@", self.outfit.outfitID];
	TTOpenURL(url);
}

- (void)shareOutfitViaEmail:(GTIOOutfit*)outfit {
	NSString* body;
	NSString* subject;
	if ([outfit.uid isEqual:[GTIOUser currentUser].UID]) {
		subject = @"I need help with my outfit!";
		body = [NSString stringWithFormat:@"Hey!\n\n"
				@"I just uploaded an outfit to GO TRY IT ON and want to know what you think.\n\n"
				@"%@\n\n"
				@"You can vote and review to tell me how good I look... or set me straight.\n\n",
				[outfit.url stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"]];
	} else {
		subject = @"Check out this outfit!";
		body = [NSString stringWithFormat:@"Hi!\n\n"
				@"Have a look at this outfit on GO TRY IT ON: %@\n\n",
				[outfit.url stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"]];
	}
	subject = [subject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	body = [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString* url = [NSString stringWithFormat:@"gtio://messageComposer/email/%@/%@/%@", outfit.outfitID, subject, body];
	TTOpenURL(url);
}

- (void)shareOutfitViaSMS:(GTIOOutfit*)outfit {
	NSString* body;
	if ([outfit.uid isEqual:[GTIOUser currentUser].UID]) {
		body = [NSString stringWithFormat:@"Hey! I just uploaded an outfit to GO TRY IT ON and want to know what you think! %@",
                [outfit.url stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"]];
	} else {
		body = [NSString stringWithFormat:@"Hi! You should check out this look on GO TRY IT ON: %@",
                [outfit.url stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"]];
	}
    body = [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* url = [NSString stringWithFormat:@"gtio://messageComposer/textMessage/%@/%@", outfit.outfitID, body];
    TTOpenURL(url);
}

- (void)shareButtonWasPressed:(id)sender {
	TWTActionSheetDelegate* delegate = [TWTActionSheetDelegate actionSheetDelegate];
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:delegate cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	
	[actionSheet addButtonWithTitle:@"sms"];
	[delegate setTarget:self selector:@selector(shareOutfitViaSMS:) object:self.outfit forButtonIndex:0];
	[actionSheet addButtonWithTitle:@"email"];
	[delegate setTarget:self selector:@selector(shareOutfitViaEmail:) object:self.outfit forButtonIndex:1];
	[actionSheet addButtonWithTitle:@"cancel"];
	[actionSheet setCancelButtonIndex:2];
	
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)writeAReviewButtonWasPressed:(id)sender {
	[_scrollView.centerPage performSelector:@selector(writeAReviewButtonWasPressed:) withObject:sender];
}

- (void)doneOrNextButtonWasPressed:(id)sender {
	[_scrollView.centerPage performSelector:@selector(doneOrNextButtonWasPressed:) withObject:sender];
}

- (BOOL)scrollViewShouldZoom:(TTScrollView*)scrollView {
	return NO;
}

- (GTIOOutfit*)outfit {
    if (_outfitIndex >= [_model.objects count]) {
        return nil;
    }
	GTIOOutfit* outfit = (GTIOOutfit*)[_model.objects objectAtIndex:_outfitIndex];
    if ([outfit isKindOfClass:[GTIOReview class]]) {
        GTIOReview* review = (GTIOReview*)outfit;
        outfit = review.outfit;
    }
    return outfit;
}

- (void)showLoadingMore {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)hideLoadingMore {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)modelDidStartLoad:(id <TTModel>)model {
	[self showLoadingMore];
}

- (void)updateIsLastPage {
    for(GTIOOutfitPageView* page in [_scrollView valueForKey:@"_pages"]) {
        if ([page isKindOfClass:[GTIOOutfitPageView class]]) {
            GTIOOutfit* outfit = (GTIOOutfit*)[[_model objects] lastObject];
            // guard against a review here as well.
            if ([outfit isKindOfClass:[GTIOReview class]]) {
                GTIOReview* review = (GTIOReview*)outfit;
                outfit = review.outfit;
            }
            page.isLastPage = ([[outfit outfitID] isEqual:page.outfit.outfitID]);
        }
    }
}

- (void)modelDidFinishLoad:(id <TTModel>)model {
	[self hideLoadingMore];
    
    //    GTIOOutfitPageView* page = (GTIOOutfitPageView*)_scrollView.centerPage;
//    if (self.outfit) {
//    _scrollViewDataSource.moreToLoad = [_model hasMoreToLoad];
    [self updateIsLastPage];
//    
//    page.outfit = self.outfit;
//    [page showFullDescription:NO];
//    } else {
//        [self performSelector:@selector(scrollBack) withObject:nil afterDelay:0.1];
//    }
    
	[self updateView];
}
         
//- (void)scrollBack {
//    _scrollView.centerPageIndex -= 1;
//    GTIOOutfitPageView* page = (GTIOOutfitPageView*)_scrollView.centerPage;
//    page.isLastPage = YES;
//    [page showFullDescription:NO];
//    [self performSelector:@selector(getRidOfLastPage) withObject:nil afterDelay:0.1];
//}
//
//- (void)getRidOfLastPage {
//    _scrollViewDataSource.moreToLoad = NO;
//}

- (void)model:(id <TTModel>)model didFailLoadWithError:(NSError *)error {
	[self hideLoadingMore];
    [self updateIsLastPage];
}

#pragma mark -
#pragma mark Tools

- (void)toolsButtonWasPressed:(id)sender {
	NSLog(@"Tools");
	TWTActionSheetDelegate* delegate = [TWTActionSheetDelegate actionSheetDelegate];
	NSString* title = ([[self.outfit isPublic] boolValue] ? @"this look is shared with the community." : @"this look is hidden from the community.");
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:delegate cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	
	
	[actionSheet addButtonWithTitle:@"edit description"];
	[delegate setTarget:self selector:@selector(editOutfit:) object:self.outfit forButtonIndex:0];
	if ([[self.outfit isPublic] boolValue]) {
		[actionSheet addButtonWithTitle:@"hide from community"];
		[delegate setTarget:self selector:@selector(makeOutfitPrivate:) object:self.outfit forButtonIndex:1];
	} else {
		[actionSheet addButtonWithTitle:@"share with community"];
		[delegate setTarget:self selector:@selector(makeOutfitPublic:) object:self.outfit forButtonIndex:1];
	}
	[actionSheet addButtonWithTitle:@"delete this look"];
	[delegate setTarget:self selector:@selector(deleteOutfit:) object:self.outfit forButtonIndex:2];
	[actionSheet addButtonWithTitle:@"cancel"];
	[actionSheet setCancelButtonIndex:3];
	
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)editOutfit:(GTIOOutfit*)outfit {
    GTIOAnalyticsEvent(kOutfitEdit);
	GTIOEditOutfitViewController* controller = [[GTIOEditOutfitViewController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:controller];
	controller.outfit = outfit;
	controller.outfitViewController = self;
	[self presentModalViewController:navController animated:YES];
	[controller release];
	[navController release];
}

- (void)saveOutfit:(GTIOOutfit*)outfit withNewEventID:(NSNumber*)eventID description:(NSString*)description {
	NSString* path = [NSString stringWithFormat:@"/tools/%@", outfit.outfitID];
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  @"edit", @"action",
						  eventID, @"eventId",
						  description, @"description",
						  nil];
	dict = [GTIOUser paramsByAddingCurrentUserIdentifier:dict];
	RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(path) delegate:self];
	loader.params = dict;
	loader.method = RKRequestMethodPOST;
	[loader send];
}

- (void)makeOutfitPrivateConfirmed:(GTIOOutfit*)outfit {
    GTIOAnalyticsEvent(kOutfitPrivate);
	NSString* path = [NSString stringWithFormat:@"/tools/%@", outfit.outfitID];
	NSDictionary* dict = [NSDictionary dictionaryWithObject:@"private" forKey:@"action"];
	dict = [GTIOUser paramsByAddingCurrentUserIdentifier:dict];
	RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(path) delegate:self];
	loader.params = dict;
	loader.method = RKRequestMethodPOST;
	[loader send];
}

- (void)makeOutfitPrivate:(GTIOOutfit*)outfit {
	TWTAlertViewDelegate* delegate = [[[TWTAlertViewDelegate alloc] init] autorelease];
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" 
													message:@"I want to hide this look from\nthe GO TRY IT ON community.\n(I can still view and send to\nfriends, but it will not be\nfeatured on the site or search.)"
												   delegate:delegate 
										  cancelButtonTitle:@"cancel"
										  otherButtonTitles:@"hide", nil];
	[delegate setTarget:self selector:@selector(makeOutfitPrivateConfirmed:) object:outfit forButtonIndex:1];
	[alert show];
	[alert release];
}

- (void)makeOutfitPublicConfirmed:(GTIOOutfit*)outfit {
    GTIOAnalyticsEvent(kOutfitPublic);
	NSString* path = [NSString stringWithFormat:@"/tools/%@", outfit.outfitID];
	NSDictionary* dict = [NSDictionary dictionaryWithObject:@"public" forKey:@"action"];
	dict = [GTIOUser paramsByAddingCurrentUserIdentifier:dict];
	RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(path) delegate:self];
	loader.params = dict;
	loader.method = RKRequestMethodPOST;
	[loader send];
}

- (void)makeOutfitPublic:(GTIOOutfit*)outfit {
	TWTAlertViewDelegate* delegate = [[[TWTAlertViewDelegate alloc] init] autorelease];
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" 
													message:@"I want to share this look with\nthe GO TRY IT ON community.\n(My outfit may appear in search\nresults or on the home page.)"
												   delegate:delegate 
										  cancelButtonTitle:@"cancel"
										  otherButtonTitles:@"share", nil];
	[delegate setTarget:self selector:@selector(makeOutfitPublicConfirmed:) object:outfit forButtonIndex:1];
	[alert show];
	[alert release];
}

- (void)deleteOutfit:(GTIOOutfit*)outfit {
	TWTAlertViewDelegate* delegate = [[[TWTAlertViewDelegate alloc] init] autorelease];
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" 
													message:@"I want to delete this look. (This cannot be undone!)"
												   delegate:delegate 
										  cancelButtonTitle:@"cancel"
										  otherButtonTitles:@"delete", nil];
	[delegate setTarget:self selector:@selector(deleteConfirmed:) object:outfit forButtonIndex:1];
	[alert show];
	[alert release];
}
- (void)deleteConfirmed:(GTIOOutfit*)outfit {
    GTIOAnalyticsEvent(kOutfitPrivate);
	NSString* path = [NSString stringWithFormat:@"/tools/%@", outfit.outfitID];
	NSDictionary* dict = [NSDictionary dictionaryWithObject:@"delete" forKey:@"action"];
	dict = [GTIOUser paramsByAddingCurrentUserIdentifier:dict];
	RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(path) delegate:self];
	loader.params = dict;
	loader.method = RKRequestMethodPOST;
	[loader send];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    [self retain];
    _loader = nil;
	NSLog(@"loaded: objects: %@", objects);
	GTIOOutfit* outfit = [objects objectWithClass:[GTIOOutfit class]];
    if (nil == self.model) {
        NSLog(@"Blah");
        self.model = [GTIOStaticOutfitListModel modelWithOutfits:[NSArray arrayWithObject:outfit]];
    }
    
	if (outfit) {
		if (![_model.objects isKindOfClass:[NSMutableArray array]]) {
			// Prevents accidental non-mutable arrays in here.
            NSArray* array = _model.objects;
            if (nil == array) {
                array = [NSArray array];
            }
			[_model setValue:[[array mutableCopy] autorelease] forKey:@"objects"];
		}
        if ([_model.objects count] > _outfitIndex) {
            [(NSMutableArray*)_model.objects replaceObjectAtIndex:_outfitIndex withObject:outfit];
        } else {
            [(NSMutableArray*)_model.objects addObject:outfit];
        }
        
		[[NSNotificationCenter defaultCenter] postNotificationName:@"OutfitWasUpdatedNotification" object:outfit];
	} else {
		[self.navigationController popViewControllerAnimated:YES];
		[(GTIOPaginatedTTModel*)self.model load:TTURLRequestCachePolicyDefault more:NO];
		return;
	}
	[self setOutfitIndex:_outfitIndex];
////	[self updateView];
	GTIOOutfitPageView* page = (GTIOOutfitPageView*)_scrollView.centerPage;
    
    if (nil == page) {
        // FUCK !!!!!!!!! (not a reload, first load).
        _scrollViewDataSource = [[GTIOOutfitViewScrollDataSource alloc] init];
		_scrollViewDataSource.model = _model;
        _scrollView.dataSource = _scrollViewDataSource;
        [_scrollView reloadData];
        [_scrollView moveToPageAtIndex:0 resetEdges:YES];
        page = (GTIOOutfitPageView*)_scrollView.centerPage;
    }
    
    if (objectLoader.method == RKRequestMethodPOST) {
        [page setOutfit:outfit];
        [self toolsButtonWasPressed:nil];
    } else {
        [_scrollView doneReloading];
        [page setOutfitWithoutMultiOverlay:outfit];
    }
    [self release];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    _loader = nil;
//	TTOpenURL(@"gtio://stopLoading");
	NSLog(@"Error: %@", error);
    GTIOErrorMessage(error);
    
    if (objectLoader.method != RKRequestMethodPOST) {
        [_scrollView doneReloading];
    }
}

- (void)scrollView:(GTIOScrollView*)scrollView shouldReloadPage:(GTIOOutfitPageView*)page {
    GTIOAnalyticsEvent(kOutfitRefreshEventName);
    NSLog(@"Reload page: %@", page);
    NSDictionary* params = [GTIOUser paramsByAddingCurrentUserIdentifier:[NSDictionary dictionary]];
    NSString* path = GTIORestResourcePath([NSString stringWithFormat:@"/outfit/%@?%@", page.outfit.outfitID, [params URLEncodedString]]);
	_loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:path delegate:self];
	[_loader send];
}

@end
