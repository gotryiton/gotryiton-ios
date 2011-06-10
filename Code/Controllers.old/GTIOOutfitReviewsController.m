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

@implementation GTIOOutfitReviewsController

@synthesize outfit = _outfit;

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_outfit release];
	[super dealloc];
}

- (id)initWithOutfitID:(NSString*)outfitID {
	if (self = [super initWithStyle:UITableViewStylePlain]) {
		NSLog(@"OutfitID: %@", outfitID);
		self.outfit = [GTIOOutfit outfitWithOutfitID:outfitID];
		NSLog(@"Outfit: %@", _outfit);
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewDeletedNotification:) name:@"ReviewDeletedNotification" object:nil];
        
        self.navigationItem.backBarButtonItem = [[[GTIOBarButtonItem alloc] initWithTitle:@"back" 
                                                                                  
                                                                                 target:nil 
                                                                                 action:nil] autorelease];
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
		
		NSDictionary* photo = [_outfit.photos objectAtIndex:0];
		photoView.urlPath = [photo valueForKey:@"multiThumb"];
		[headerView addSubview:photoView];
        [_imageViews addObject:photoView];
		[photoView release];
        
        NSString* imageName = @"thumb-overlay-single.png";
        UIImageView* overlayView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
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
	_placeholder = [[UILabel alloc] initWithFrame:CGRectMake(_editor.frame.origin.x+8, _editor.frame.origin.y+8, _editor.frame.size.width-16, 16)];
	_placeholder.backgroundColor = [UIColor clearColor];
	_placeholder.text = @"I think...";
	_placeholder.font = kGTIOFontBoldHelveticaNeueOfSize(12);
	_placeholder.textColor = kGTIOColorbfbfbf;
	[headerView addSubview:_placeholder];
	
	
    UIImage* image;
    if ([[_outfit isMultipleOption] boolValue]) {
        image = [[UIImage imageNamed:@"header-white-multiple.png"] stretchableImageWithLeftCapWidth:154 topCapHeight:50];
    } else {
        image = [[UIImage imageNamed:@"header-white-single.png"] stretchableImageWithLeftCapWidth:154 topCapHeight:50];
    }
	headerView.image = image;
	UIView* wrapperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320-12, headerView.height + 6)];
	[wrapperView addSubview:headerView];
	headerView.userInteractionEnabled = YES;
	
	UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[closeButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
//	[closeButton addTarget:nil action:@selector(closeButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton addTarget:self action:@selector(closeButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
	closeButton.frame = CGRectMake(275, 6,27,27);
	[headerView addSubview:closeButton];
	
	self.tableView.tableHeaderView = wrapperView;
	[wrapperView release];
	[headerView release];
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
        emptyView.tag = 91919191;
        [self.view addSubview:emptyView];
        self.tableView.tableFooterView = nil;
    } else {
        UIView* emptyView = [self.view viewWithTag:91919191];
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
    TTImageView* fullsizeImage = [[TTImageView alloc] initWithFrame:self.view.bounds];
    fullsizeImage.tag = 99999;
    fullsizeImage.defaultImage = [UIImage imageNamed:@"default-outfit.png"];
    fullsizeImage.urlPath = photo;
    [self.view addSubview:fullsizeImage];
    [fullsizeImage release];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches Ended");
    UITouch* touch = [touches anyObject];
    if ([touches count] == 1) {
        TTImageView* fullsizeImage = (TTImageView*)[self.view viewWithTag:99999];
        if (fullsizeImage) {
            [fullsizeImage removeFromSuperview];
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

- (void)postReview {
    TTOpenURL(@"gtio://loading");
    _loading = YES;
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _editor.text, @"reviewText", nil];
    params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    NSString* path = GTIORestResourcePath([NSString stringWithFormat:@"/review/%@", _outfit.outfitID]);
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:path delegate:self];
    loader.params = params;
    loader.method = RKRequestMethodPOST;
    _editor.text = @"";
    [self textEditorDidChange:_editor];
    [loader send];
}

- (void)loginNotification:(NSNotification*)note {
    [_editor becomeFirstResponder];
}

- (BOOL)textEditorShouldReturn:(TTTextEditor*)textEditor {
	if (![textEditor.text isWhitespaceAndNewlines]) {
        if (![[GTIOUser currentUser] isLoggedIn]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotification:) name:kGTIOUserDidLoginNotificationName object:nil];
            TTOpenURL(@"gtio://login");
        } else {
            [self postReview];
        }
	}
	[_editor resignFirstResponder];
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
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
														message:[error localizedDescription]
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

@end
