//
//  GTIOOutfitReviewsController.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/26/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOOutfitReviewsController.h"
#import <RestKit/Three20/Three20.h>
#import "GTIOReview.h"
#import "GTIOOutfitReviewTableItem.h"
#import "GTIOOutfitReviewTableCell.h"
#import "GTIOProductView.h"
#import "GTIOOutfitReviewControlBar.h"

const NSUInteger kOutfitReviewHeaderContainerTag = 90;
const NSUInteger kOutfitReviewProductHeaderTag = 91;
const NSUInteger kOutfitReviewProductCloseButtonTag = 92;
const NSUInteger kOutfitReviewEmptyViewTag = 91919191;
const NSUInteger kOutfitReviewSuggestButtonViewTag = 93;
const CGFloat kOutfitReviewSectionSpacer = 7.5;
const CGFloat kOutfitReviewProductHeaderWidth = 262.0;
const CGFloat kOutfitReviewProductHeaderMultipleWidth = 293.0;

@interface GTIOOutfitReviewsTableViewDataSource : TTListDataSource {
	
}
@end

@implementation GTIOOutfitReviewsTableViewDataSource
- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object { 
	if ([object isKindOfClass:[GTIOOutfitReviewTableItem class]]) {
		return [GTIOOutfitReviewTableCell class];	
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
	
}
@end

@interface GTIOOutfitReviewsController () {
    GTIOOutfitReviewControlBar *_controlBar;
}
- (void)recommendedButtonWasPressed:(id)sender;

- (void)closeButtonWasPressed:(id)sender;
- (void)updateTableHeaderWithProduct:(GTIOProduct *)product;
- (void)removeProductHeader;
- (void)showProductPreviewDetails:(UIGestureRecognizer *)gesture;
- (void)updateEmptyView;

- (void)keyboardWillShowNotification:(NSNotification *)note;
- (void)keyboardWillHideNotification:(NSNotification *)note;

- (void)postReview;
- (void)verifyUserComment;
@end

@implementation GTIOOutfitReviewsController

@synthesize outfit = _outfit;
@synthesize product = _product;

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_outfit release];
    [_product release];
    [_controlBar release];
	[super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.title = @"reviews";
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewDeletedNotification:) name:@"ReviewDeletedNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
        
        self.navigationItem.backBarButtonItem = [[[GTIOBarButtonItem alloc] initWithTitle:@"back" 
                                                  
                                                                                   target:nil 
                                                                                   action:nil] autorelease];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(suggestionMade:) name:kGTIOSuggestionMadeNotification object:nil];
    }
    return self;
}

- (id)initWithOutfitID:(NSString*)outfitID {
	if (self = [self initWithStyle:UITableViewStylePlain]) {
		self.outfit = [GTIOOutfit outfitWithOutfitID:outfitID];
	}
	return self;
}

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
    if (self = [self initWithStyle:UITableViewStylePlain]) {
        self.outfit = [query objectForKey:@"outfit"];
        self.product = [query objectForKey:@"product"];
    }
    return self;
}

- (void)setupTableFooter {
    
    UIImageView* footer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320-12, 6)];
    [footer setImage:[UIImage imageNamed:@"comment-area.png"]];
    self.tableView.tableFooterView = footer;
    [footer release];
}

- (void)viewDidUnload {
	TT_RELEASE_SAFELY(_editor);
	TT_RELEASE_SAFELY(_placeholder);
    TT_RELEASE_SAFELY(_imageViews);
    TT_RELEASE_SAFELY(_buttons);
    TT_RELEASE_SAFELY(_closeButton);
    TT_RELEASE_SAFELY(_keyboardOverlayButton1);
    TT_RELEASE_SAFELY(_keyboardOverlayButton2);
	[super viewDidUnload];
}

- (void)loadView {
	[super loadView];
    self.view.accessibilityLabel = @"Reviews Screen";

    _imageViews = [[NSMutableArray alloc] init];
    _buttons = [[NSMutableArray alloc] init];
    
//	[self.navigationController setNavigationBarHidden:YES animated:NO];
	self.autoresizesForKeyboard = YES;
	
	self.variableHeightRows = YES;
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.frame = CGRectMake(6, 0, self.view.width - 12, self.view.height);
	self.tableView.contentInset = UIEdgeInsetsMake(6, 0, 6, 0);
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    // Review Table Background
	
	UIImageView* headerView;
	int photoWidth = 62;
	int photoHeight = 84;
	if ([[_outfit isMultipleOption] boolValue]) {
		headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320-12,98*2-6)];
		int offset = 6;
		int i = 0;
		for (NSDictionary* photo in _outfit.photos) {
            CGRect frame = CGRectMake(offset + i * photoWidth, 6, photoWidth, photoHeight);
			TTImageView* photoView = [[TTImageView alloc] initWithFrame:frame];
            [photoView setDefaultImage:[UIImage imageNamed:@"thumb-review-empty.png"]];
			photoView.urlPath = [photo valueForKey:@"multiThumb"];
			[headerView addSubview:photoView];
            [_imageViews addObject:photoView];
			[photoView release];
            
            NSString* imageName = [NSString stringWithFormat:@"thumb-overlay-%d.png", i+1];
            UIImageView* overlayView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            overlayView.frame = frame;
            [headerView addSubview:overlayView];
            [overlayView release];
            
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = overlayView.frame;
            [button addTarget:self action:@selector(thumbnailButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
            [_buttons addObject:button];
            [headerView addSubview:button];
            
			i++;
			offset += 5;
		}
		_editor = [[TTTextEditor alloc] initWithFrame:CGRectMake(6, 98*2-6-86-6-2, 320-12-12, 86+2)];
	} else {
		headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320-12,96)];
        CGRect frame = CGRectMake(6, 6, photoWidth, photoHeight);
		TTImageView* photoView = [[TTImageView alloc] initWithFrame:frame];
        [photoView setDefaultImage:[UIImage imageNamed:@"thumb-review-empty.png"]];
		
		NSDictionary* photo = [_outfit.photos objectAtIndex:0];
		photoView.urlPath = [photo valueForKey:@"multiThumb"];
		[headerView addSubview:photoView];
        [_imageViews addObject:photoView];
		[photoView release];
        
        NSString* imageName = @"thumb-overlay-single.png";
        UIImageView* overlayView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]] autorelease];
        overlayView.frame = frame;
        [headerView addSubview:overlayView];
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = overlayView.frame;
        [button addTarget:self
                   action:@selector(thumbnailButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_buttons addObject:button];
        [headerView addSubview:button];
		
		_editor = [[TTTextEditor alloc] initWithFrame:CGRectMake(62+6+6, 6, 196, 84)];
	}
	UIImage* img = [[UIImage imageNamed:@"write-review-box.png"] stretchableImageWithLeftCapWidth:232/2 topCapHeight:46/2];
	UIImageView* editorBG = [[[UIImageView alloc] initWithImage:img] autorelease];
	editorBG.frame = _editor.frame;
	[headerView addSubview:editorBG];
	_editor.autoresizesToText = YES;
	_editor.minNumberOfLines = 4;
	_editor.maxNumberOfLines = 4;
	_editor.style = nil;
	_editor.font = kGTIOFontHelveticaNeueOfSize(12);
	
	_editor.returnKeyType = UIReturnKeyDone;
	_editor.delegate = self;
	_editor.backgroundColor = [UIColor clearColor];
	[headerView addSubview:_editor];
    
    CGFloat placeholderHeight = [[_outfit isMultipleOption] boolValue] ? 16 : 32;
	_placeholder = [[UILabel alloc] initWithFrame:CGRectMake(_editor.frame.origin.x+8, _editor.frame.origin.y+8, _editor.frame.size.width-16, placeholderHeight)];
	_placeholder.backgroundColor = [UIColor clearColor];
	_placeholder.text = @"add a comment about this, or just hit 'done'!";
	_placeholder.font = kGTIOFontBoldHelveticaNeueOfSize(12);
	_placeholder.textColor = kGTIOColorbfbfbf;
    _placeholder.numberOfLines = 2;

	[headerView addSubview:_placeholder];
	
	
    UIImage* image;
    if ([[_outfit isMultipleOption] boolValue]) {
        image = [[UIImage imageNamed:@"header-white-multiple.png"] stretchableImageWithLeftCapWidth:154 topCapHeight:50];
    } else {
        image = [[UIImage imageNamed:@"header-white-single.png"] stretchableImageWithLeftCapWidth:154 topCapHeight:50];
    }
	headerView.image = image;
    
	UIView* wrapperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320-12, headerView.height + 6)];
    [headerView setTag:kOutfitReviewHeaderContainerTag];
	[wrapperView addSubview:headerView];
	headerView.userInteractionEnabled = YES;
	
	_closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	[_closeButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
	_closeButton.frame = CGRectMake(275, 6,27,27);
    _closeButton.contentEdgeInsets = UIEdgeInsetsMake(20,6,20,20);
    _closeButton.frame = UIEdgeInsetsInsetRect(_closeButton.frame, UIEdgeInsetsMake(-20,-6,-20,-20));
	[headerView addSubview:_closeButton];
    headerView.clipsToBounds = NO;
	
	self.tableView.tableHeaderView = wrapperView;
	[wrapperView release];
	[headerView release];
    
    _keyboardOverlayButton1 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _keyboardOverlayButton1.frame = self.view.bounds;
    [_keyboardOverlayButton1 addTarget:self action:@selector(dismissKeyboard:event:) forControlEvents:UIControlEventTouchUpInside];
    _keyboardOverlayButton2 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _keyboardOverlayButton2.frame = CGRectOffset(self.view.bounds, 0, headerView.bounds.size.height);
    [_keyboardOverlayButton2 addTarget:self action:@selector(dismissKeyboard:event:) forControlEvents:UIControlEventTouchUpInside];
    
    // Recommend Button
    UIButton* recommendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [recommendButton setImage:[UIImage imageNamed:@"reviews-suggest-bigpink-OFF.png"] forState:UIControlStateNormal];
    [recommendButton setImage:[UIImage imageNamed:@"reviews-suggest-bigpink-ON.png"] forState:UIControlStateHighlighted];
    recommendButton.frame = CGRectMake(0, self.view.bounds.size.height - 65, 320, 65);
    [recommendButton addTarget:self action:@selector(recommendedButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    recommendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [recommendButton setTag:kOutfitReviewSuggestButtonViewTag];
    [self.view addSubview:recommendButton];
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                      self.tableView.frame.origin.y,
                                      self.tableView.width,
                                      self.tableView.height - 58);
    _controlBar = [[GTIOOutfitReviewControlBar alloc] init];
    [_controlBar setFrame:(CGRect){{0, self.view.frame.size.height + _controlBar.frame.size.height}, _controlBar.frame.size}];
    [_controlBar setProductSuggestHandler:^{
        [self recommendedButtonWasPressed:nil];
    }];
    [_controlBar setSubmitReviewHandler:^{
        [self verifyUserComment];
    }];
    [self.view insertSubview:_controlBar aboveSubview:_keyboardOverlayButton2];
}

- (void)updateTableHeaderWithProduct:(GTIOProduct *)product {
    self.product = product;
    
    UIView *tableHeaderView = self.tableView.tableHeaderView;
    UIView *headerView = [tableHeaderView viewWithTag:kOutfitReviewHeaderContainerTag];
    
    UIView *productViewWrapper = [[[UIView alloc] initWithFrame:(CGRect){0, tableHeaderView.frame.size.height - kOutfitReviewSectionSpacer,tableHeaderView.frame.size.width, 0}] autorelease];
    [productViewWrapper setTag:kOutfitReviewProductHeaderTag];
    [productViewWrapper setClipsToBounds:YES];
    
    CGFloat productViewWidth =  [[_outfit isMultipleOption] boolValue] ? kOutfitReviewProductHeaderMultipleWidth : kOutfitReviewProductHeaderWidth;  
    CGRect productViewRect = (CGRect){6.0, 0, productViewWidth, 0};

    GTIOProductView *productView = [[GTIOProductView alloc] initWithFrame:productViewRect];
    [productView setSuggestionText:[[_outfit isMultipleOption] boolValue] ? @"suggested for this look" : @"you are recommending..."];
    [productView setProduct:self.product];
    
    UIButton *closeProductButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *closeButtonImage = [UIImage imageNamed:@"close.png"];
    [closeProductButton setBackgroundImage:closeButtonImage forState:UIControlStateNormal];
    [closeProductButton addTarget:self action:@selector(removeProductHeader) forControlEvents:UIControlEventTouchUpInside];
    [closeProductButton setFrame:(CGRect){productViewWidth - closeButtonImage.size.width / 2.0, 0, closeButtonImage.size.width / 2.0, closeButtonImage.size.width / 2.0}];
    [productView addSubview:closeProductButton];
    [productViewWrapper addSubview:productView];
    [headerView addSubview:productViewWrapper];
    
    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProductPreviewDetails:)] autorelease];
    [tapGesture setDelegate:self];
    [productView addGestureRecognizer:tapGesture];
    
    CGRect viewWrapperRect = productViewWrapper.frame;
    viewWrapperRect.size.height = [GTIOProductView productViewHeightForProduct:product] + kOutfitReviewSectionSpacer;
    
    [UIView animateWithDuration:0.5 animations:^{
        [tableHeaderView setFrame:(CGRect){tableHeaderView.frame.origin, {tableHeaderView.frame.size.width, tableHeaderView.frame.size.height + viewWrapperRect.size.height}}];
        [productViewWrapper setFrame:viewWrapperRect];
        [headerView setFrame:(CGRect){headerView.origin, {headerView.frame.size.width, tableHeaderView.frame.size.height - kOutfitReviewSectionSpacer}}];
        [self.tableView setTableHeaderView:tableHeaderView];
        [self updateEmptyView];
    }];
}

- (void)removeProductHeader {
    self.product = nil;
    
    UIView *tableHeaderView = self.tableView.tableHeaderView;
    UIView *headerView = [tableHeaderView viewWithTag:kOutfitReviewHeaderContainerTag];
    UIView *productView = [headerView viewWithTag:kOutfitReviewProductHeaderTag];
    CGRect targetRect = (CGRect){tableHeaderView.frame.origin, {tableHeaderView.frame.size.width, tableHeaderView.frame.size.height - productView.frame.size.height}};
    
    [UIView animateWithDuration:0.25 animations:^{
        [productView removeFromSuperview];
        [tableHeaderView setFrame:targetRect];
        [headerView setFrame:(CGRect){headerView.origin, {tableHeaderView.frame.size.width, tableHeaderView.frame.size.height - kOutfitReviewSectionSpacer}}];
        [self.tableView setTableHeaderView:tableHeaderView];
        [self updateEmptyView];
    }];
}

- (void)suggestionMade:(NSNotification*)note {
    if ([self.outfit.outfitID isEqualToString:note.object]) {
        if (self.product) {
            [self removeProductHeader];
        }
        // note.object is outfitID. we're getting the product from the user info.
        [self updateTableHeaderWithProduct:[note.userInfo objectForKey:kGTIOProductNotificationKey]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)recommendedButtonWasPressed:(id)sender {
    [GTIOUser makeSuggestionForOutfit:_outfit];
}

- (void)dismissKeyboard:(id)sender event:(UIEvent*)event {
    [_editor resignFirstResponder];
}

- (void)textEditorDidBeginEditing:(TTTextEditor*)textEditor {
    [_editor.superview insertSubview:_keyboardOverlayButton1 belowSubview:_editor];
    [self.view insertSubview:_keyboardOverlayButton2 belowSubview:_controlBar];
}

- (void)textEditorDidEndEditing:(TTTextEditor*)textEditor {
    [_keyboardOverlayButton1 removeFromSuperview];
    [_keyboardOverlayButton2 removeFromSuperview];
}

- (void)updateEmptyView {
    UIView* emptyView = [self.view viewWithTag:kOutfitReviewEmptyViewTag];
    if (emptyView) {
        emptyView.frame = [self rectForOverlayView];
    }
    [self.view bringSubviewToFront:[self.view viewWithTag:kOutfitReviewSuggestButtonViewTag]];
}

- (CGRect)rectForOverlayView {
    return CGRectMake(0, _tableView.tableHeaderView.height, 320, _tableView.height - _tableView.tableHeaderView.height);
}

- (void)showEmpty:(BOOL)show {
    NSLog(@"EMPTY? %d", show);
    if (show) {
        UIImage* image = [UIImage imageNamed:@"empty.png"];
        TTErrorView* emptyView = [[[TTErrorView alloc] initWithTitle:@"write the first review!"
                                                            subtitle:nil
                                                               image:image] autorelease];
        emptyView.frame = [self rectForOverlayView];
        emptyView.tag = kOutfitReviewEmptyViewTag;
        [self.view insertSubview:emptyView belowSubview:_controlBar];
        self.tableView.tableFooterView = nil;
    } else {
        UIView* emptyView = [self.view viewWithTag:kOutfitReviewEmptyViewTag];
        [emptyView removeFromSuperview];
        [self setupTableFooter];
    }
}

- (void)createModel {
	NSString* path = GTIORestResourcePath([NSString stringWithFormat:@"/reviews/%@", _outfit.outfitID]);
    RKObjectLoader* objectLoader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:path delegate:nil];
	RKObjectLoaderTTModel* model = [RKObjectLoaderTTModel modelWithObjectLoader:objectLoader];
	TTListDataSource* ds = [GTIOOutfitReviewsTableViewDataSource dataSourceWithObjects:nil];
	ds.model = model;
	self.dataSource = ds;
}

- (void)thumbnailButtonWasTapped:(id)sender {
    int indexOfTappedOutfit = 0;
    for (UIButton* button in _buttons) {
        if (sender == button) {
            indexOfTappedOutfit = [_buttons indexOfObject:button];
        }
    }
    NSString* photo = [[_outfit.photos objectAtIndex:indexOfTappedOutfit] valueForKey:@"mainImg"];
    UIView* backgroundView = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.tag = 99999;
    TTImageView* fullsizeImage = [[[TTImageView alloc] initWithFrame:self.view.bounds] autorelease];
    fullsizeImage.contentMode = UIViewContentModeScaleAspectFit;
    fullsizeImage.defaultImage = [UIImage imageNamed:@"default-outfit.png"];
    fullsizeImage.urlPath = photo;
    [backgroundView addSubview:fullsizeImage];
    [self.view addSubview:backgroundView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches Ended");
    UITouch* touch = [touches anyObject];
    if ([touches count] == 1) {
        TTImageView* fullsizeImage = (TTImageView*)[self.view viewWithTag:99999];
        if (fullsizeImage) {
            [fullsizeImage removeFromSuperview];
        } else if([_closeButton pointInside:[touch locationInView:_closeButton] withEvent:event]) {
            [self closeButtonWasPressed:_closeButton];
        } else if (![_editor pointInside:[touch locationInView:_editor] withEvent:event]
                   && !_loading) {
            if ([_editor isFirstResponder]) {
                [_editor resignFirstResponder];
            } else {
                [_editor becomeFirstResponder];
            }
        }
    }
    [super touchesEnded:touches withEvent:event];
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    [_editor resignFirstResponder];
}

- (void)didLoadModel:(BOOL)firstTime {
    [self setupTableFooter];

	NSMutableArray* items = [NSMutableArray array];
	
	NSArray* reviews = [(RKObjectLoaderTTModel*)self.model objects];
    
	for (GTIOReview* review in reviews) {
		[items addObject:[GTIOOutfitReviewTableItem itemWithReview:review]];
	}
	
	[(GTIOOutfitReviewsTableViewDataSource*)self.dataSource setItems:items];
}

- (void)closeButtonWasPressed:(id)sender {
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    
}

- (void)textEditorDidChange:(TTTextEditor*)textEditor {
	_placeholder.alpha = ([textEditor.text isWhitespaceAndNewlines] ? 1 : 0);
}

- (void)verifyUserComment {
    if (self.product && [[_editor text] length] <= 0) {
        UIAlertView *noCommentAlert = [[[UIAlertView alloc] initWithTitle:@"wait!" message:@"suggest this product\n without a comment?" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"yes", nil] autorelease];
        [noCommentAlert show];
    } else if ([[_editor text] length] > 0) {
        [self postReview];
    } else {
        [_editor resignFirstResponder];
    }
}

- (void)postReview {
    TTOpenURL(@"gtio://loading");
    _loading = YES;
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:_editor.text forKey:@"reviewText"];
    if (_product) {
        [params setObject:_product.productID forKey:@"productId"];
    }
    params = (NSMutableDictionary *)[GTIOUser paramsByAddingCurrentUserIdentifier:params];

    NSString* path = GTIORestResourcePath([NSString stringWithFormat:@"/review/%@", _outfit.outfitID]);
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:path delegate:self];
    loader.params = params;
    loader.method = RKRequestMethodPOST;
    _editor.text = @"";
    [self textEditorDidChange:_editor];
    [loader send];
    // Post the voted notification (even though we only reviewed)
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOOutfitVoteNotification object:_outfit.outfitID];
    [self removeProductHeader];
    [_editor resignFirstResponder];
}

- (void)loginNotification:(NSNotification*)note {
    [_editor becomeFirstResponder];
}

- (BOOL)textEditorShouldReturn:(TTTextEditor*)textEditor {
	if (![textEditor.text isWhitespaceAndNewlines] || self.product) {
        if (![[GTIOUser currentUser] isLoggedIn]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotification:) name:kGTIOUserDidLoginNotificationName object:nil];
            TTOpenURL(@"gtio://login");
        } else {
            [self verifyUserComment];
        }
	}
    [_editor resignFirstResponder];
    // It is unclear why I need to call this here, but if I don't it does not get called when
    // you submit reviews that are more than one line.
    [self textEditorDidEndEditing:_editor];
    
	return NO;
}

- (void)reviewDeletedNotification:(NSNotification*)note {
	GTIOReview* review = (GTIOReview*)note.object;
	TTListDataSource* dataSource = (TTListDataSource*)self.dataSource;
	
	[self.tableView beginUpdates];
	
	id item = [dataSource.items objectWithValue:review forKey:@"review"];
	NSInteger index = [dataSource.items indexOfObject:item];
	[dataSource.items removeObjectAtIndex:index];
	NSArray* indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]];
    
    _outfit.reviewCount = [NSNumber numberWithInt:[_outfit.reviewCount intValue] - 1];
    
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
	[self.tableView endUpdates];
    
    if ([dataSource.items count] == 0) {
        [self showEmpty:YES];
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjectDictionary:(NSDictionary*)dictionary {
	TTOpenURL(@"gtio://stopLoading");
    GTIOReview* review = [dictionary objectForKey:@"review"];
	if (review) {
        TTOpenURL(@"gtio://analytics/trackReviewSubmitted");
        
		TTListDataSource* dataSource = (TTListDataSource*)self.dataSource;
		
        NSLog(@"Number of Sections: %d", [self.tableView numberOfSections]);
		
		NSArray* indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
		GTIOOutfitReviewTableItem* item = [GTIOOutfitReviewTableItem itemWithReview:review];
        NSLog(@"Items: %@", dataSource.items);
		[dataSource.items insertObject:item atIndex:0];
        
        _outfit.reviewCount = [NSNumber numberWithInt:[_outfit.reviewCount intValue]+1];

        if ([dataSource.items count] == 1) {
            [self invalidateModel];
        } else {
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
        [self showEmpty:NO];
	} else {
        NSLog(@"Loaded: %@", dictionary);
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"There was an error submitting your review."
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    _loading = NO;
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	TTOpenURL(@"gtio://stopLoading");
    _loading = NO;
    GTIOErrorMessage(error);
}

#pragma mark - alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex > 0) {
        [self postReview];
    }
}

#pragma mark - gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

#pragma mark - Product details

- (void)showProductPreviewDetails:(UIGestureRecognizer *)gesture {
    if (self.product) {
        NSString* url = [NSString stringWithFormat:@"gtio://recommend/cachedSuggest/%@/%@", self.product.productID, self.outfit.outfitID];
        TTOpenURL(url);
    }
}

#pragma mark - keyboard notifications

- (void)keyboardWillShowNotification:(NSNotification *)note {
    CGRect keyboardBeginFrame = [[[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect keyboardEndFrame = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[[note userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[[note userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    CGFloat controlBarOffset = _controlBar.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    [_controlBar setFrame:(CGRect){{keyboardBeginFrame.origin.x, keyboardBeginFrame.origin.y}, _controlBar.size}];
    [UIView animateWithDuration:duration 
                          delay:0.0 
                        options:animationCurve 
                     animations:^{
                         
                         [_controlBar setFrame:(CGRect){{keyboardEndFrame.origin.x, keyboardEndFrame.origin.y - controlBarOffset}, _controlBar.size}];

                         
                     } completion:nil];
}

- (void)keyboardWillHideNotification:(NSNotification *)note {
    CGRect keyboardBeginFrame = [[[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect keyboardEndFrame = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[[note userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[[note userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    CGFloat controlBarOffset = _controlBar.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    [_controlBar setFrame:(CGRect){{keyboardBeginFrame.origin.x, keyboardBeginFrame.origin.y - controlBarOffset}, _controlBar.size}];
    [UIView animateWithDuration:duration 
                          delay:0.0 
                        options:animationCurve 
                     animations:^{
                         
                         [_controlBar setFrame:(CGRect){{keyboardEndFrame.origin.x, keyboardEndFrame.origin.y}, _controlBar.size}];
                         
                         
                     } completion:nil];
}


@end
