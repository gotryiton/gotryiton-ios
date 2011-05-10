//
//  GTIOOutfitViewController.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOOutfitViewController.h"
#import "GTIOOutfitPageView.h"
#import <TWTActionSheetDelegate.h>
#import <TWTAlertViewDelegate.h>
#import "GTIOEditOutfitViewController.h"

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
		self.model = [[[RKRequestTTModel alloc] initWithResourcePath:path] autorelease];
        //917CD21
		_outfitIndex = 0;
		_scrollViewDataSource = [[GTIOOutfitViewScrollDataSource alloc] init];
		_scrollViewDataSource.model = _model;
        
//		[_model load:TTURLRequestCachePolicyDefault more:NO];
        _loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:path delegate:self];
        [_loader send];

		self.hidesBottomBarWhenPushed = YES;
        
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"back" 
                                                                                  style:UIBarButtonItemStyleBordered 
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
    [_loader cancel];
    _loader = nil;
    
	[_model.delegates removeObject:self];
	[_model release];
	_model = nil;
	
	[_scrollViewDataSource release];
	_scrollViewDataSource = nil;


	[super dealloc];
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

- (void)loadView {
	[super loadView];
	
	// Set up header view.
	_headerView = [[GTIOOutfitHeaderView alloc] initWithFrame:CGRectMake(85, 2, 150, 40)];
	self.navigationItem.titleView = _headerView;
	
	UIBarButtonItem* profileButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"profile.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(openProfileButtonWasPressed:)] autorelease];
	self.navigationItem.rightBarButtonItem = profileButton;
	
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:nil action:nil] autorelease];
	
	_scrollView = [[GTIOScrollView alloc] initWithFrame:self.view.bounds];
	_scrollView.delegate = self;
	_scrollView.dataSource = _scrollViewDataSource;
	[_scrollView setCenterPageIndex:_outfitIndex];
	_scrollView.dragToRefresh = YES;
	[self.view addSubview:_scrollView];
	
	// Trigger neccesary UI updates.
	self.state = _state;
    
    _headerShadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header-shadow.png"]];
    [self.view addSubview:_headerShadowView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    GTIOOutfitPageView* page = (GTIOOutfitPageView*)_scrollView.centerPage;
    [page didAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[[TTNavigator navigator].window findFirstResponderInView:self.view] resignFirstResponder];
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
        [_headerView setNeedsDisplay];
        // tell page to show empty.
        return;
    }
	
	_headerView.name = [self.outfit.name uppercaseString];
	_headerView.location = self.outfit.location;
	[_headerView setNeedsDisplay];
	
	// Here we want to make the pages match. don't animate.
	_state = GTIOOutfitViewStateShowControls;
	[(GTIOOutfitPageView*)_scrollView.centerPage setState:_state animated:NO];
}

- (void)scrollView:(TTScrollView*)scrollView didMoveToPageAtIndex:(NSInteger)pageIndex {
    TTOpenURL(@"gtio://analytics/trackOutfitPageView");
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
				@"I just uploaded an outfit to GO TRY IT ON and want to know what you think. \n\n"
				@"%@\n\n"
				@"You can vote and review to tell me how good I look... or set me straight.\n\n"
				@"- %@\n\n"
				@"p.s. have the iPhone app%%3f use this link: gtio:%%2f%%2flooks%%2f%@",
				[outfit.url stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"],
				[GTIOUser currentUser].firstName,
				outfit.outfitID];
	} else {
		subject = @"Check out this outfit!";
		body = [NSString stringWithFormat:@"Hi!\n\n"
				@"Have a look at this outfit on GO TRY IT ON:\n\n"
				@"%@\n\n"
				@"- %@\n\n"
				@"p.s. have the iPhone app%%3f use this link: gtio:%%2f%%2flooks%%2f%@",
				[outfit.url stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"],
				[GTIOUser currentUser].firstName,
				outfit.outfitID];
	}
	subject = [subject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	body = [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString* url = [NSString stringWithFormat:@"gtio://messageComposer/email/%@/%@/%@", outfit.outfitID, subject, body];
	TTOpenURL(url);
}

- (void)shareOutfitViaSMS:(GTIOOutfit*)outfit {
	NSString* body;
	if ([outfit.uid isEqual:[GTIOUser currentUser].UID]) {
		body = [NSString stringWithFormat:@"Hey! I just uploaded an outfit to GO TRY IT ON and want to know what you think! %@ (iPhone app users: gtio:%%2F%%2Flooks%%2F%@)",
						  [outfit.url stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"],
						  outfit.outfitID];
	} else {
		body = [NSString stringWithFormat:@"Hi! You should check out this look on GO TRY IT ON: %@ (iPhone app users: gtio:%%2F%%2Flooks%%2F%@)",
				[outfit.url stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"],
				outfit.outfitID];
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
	return (GTIOOutfit*)[_model.objects objectAtIndex:_outfitIndex];
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
            page.isLastPage = ([[(GTIOOutfit*)[[_model objects] lastObject] outfitID] isEqual:page.outfit.outfitID]);
        }
    }
}

- (void)modelDidFinishLoad:(id <TTModel>)model {
	[self hideLoadingMore];
    
    GTIOOutfitPageView* page = (GTIOOutfitPageView*)_scrollView.centerPage;
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
    TTOpenURL(@"gtio://analytics/trackOutfitEditButtonPressed");
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
    TTOpenURL(@"gtio://analytics/trackMakeOutfitPrivateWasPressed");
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
    TTOpenURL(@"gtio://analytics/trackMakeOutfitPublicWasPressed");
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
    TTOpenURL(@"gtio://analytics/trackMakeOutfitPrivateWasPressed");
	NSString* path = [NSString stringWithFormat:@"/tools/%@", outfit.outfitID];
	NSDictionary* dict = [NSDictionary dictionaryWithObject:@"delete" forKey:@"action"];
	dict = [GTIOUser paramsByAddingCurrentUserIdentifier:dict];
	RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(path) delegate:self];
	loader.params = dict;
	loader.method = RKRequestMethodPOST;
	[loader send];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
	NSLog(@"Response: %@", [response bodyAsJSON]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    _loader = nil;
//	TTOpenURL(@"gtio://stopLoading");
	NSLog(@"loaded: objects: %@", objects);
	GTIOOutfit* outfit = [objects objectWithClass:[GTIOOutfit class]];
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
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    _loader = nil;
//	TTOpenURL(@"gtio://stopLoading");
	NSLog(@"Error: %@", error);
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
														message:[error localizedDescription]
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    if (objectLoader.method != RKRequestMethodPOST) {
        [_scrollView doneReloading];
    }
}

- (void)scrollView:(GTIOScrollView*)scrollView shouldReloadPage:(GTIOOutfitPageView*)page {
    TTOpenURL(@"gtio://analytics/trackOutfitRefresh");
    NSLog(@"Reload page: %@", page);
    NSDictionary* params = [GTIOUser paramsByAddingCurrentUserIdentifier:[NSDictionary dictionary]];
    NSString* path = GTIORestResourcePath([NSString stringWithFormat:@"/outfit/%@?%@", page.outfit.outfitID, [params URLEncodedString]]);
	_loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:path delegate:self];
	[_loader send];
}

@end
