//
//  GTIOOutfitPageView.m
//  GoTryItOn
//
//  Created by Daniel Hammond on 12/27/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOOutfitPageView.h"

CGRect const changeItFrame = {{159, 0}, {160, 51}};
CGRect const wearNoneFrame = {{252, 0}, {67, 51}};

CGRect const wear1of1Frame = {{1, 0}, {160, 51}};

CGRect const wear1of2Frame = {{1, 0}, {128, 51}};
CGRect const wear2of2Frame = {{126, 0}, {128, 51}};

CGRect const wear1of3Frame = {{1, 0}, {86, 51}};
CGRect const wear2of3Frame = {{85, 0}, {86, 51}};
CGRect const wear3of3Frame = {{169, 0}, {86, 51}};

CGRect const wear1of4Frame = {{1, 0}, {66, 51}};
CGRect const wear2of4Frame = {{64, 0}, {66, 51}};
CGRect const wear3of4Frame = {{127, 0}, {66, 51}};
CGRect const wear4of4Frame = {{190, 0}, {66, 51}};

@interface TTScrollView (Private)
- (void)moveToPageAtIndex:(NSInteger)pageIndex resetEdges:(BOOL)resetEdges;
@end

@interface GTIOOutfitPageView (Private)
- (void)showOrHideBrandInfo:(id)sender;
@end

@implementation GTIOOutfitPageView

@synthesize outfitIndex = _outfitIndex;
@synthesize outfit = _outfit;
@synthesize isFirstPage = _isFirstPage;
@synthesize isLastPage = _isLastPage;
@synthesize state = _state;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_photosView = [[GTIOScrollView alloc] initWithFrame:self.bounds];
		[self addSubview:_photosView];
		
		_roundedCornerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rounded-corners.png"]];
		[self addSubview:_roundedCornerImageView];
		
		_topControlsView = [[GTIOOutfitTopControlsView alloc] initWithFrame:CGRectZero];
		[self addSubview:_topControlsView];
		
		_goLeftButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[_goLeftButton setImage:[UIImage imageNamed:@"arrow-left.png"] forState:UIControlStateNormal];
		[_goLeftButton setImage:[UIImage imageNamed:@"arrow-left-ON.png"] forState:UIControlStateHighlighted];
		[_goLeftButton addTarget:nil action:@selector(goLeftButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_goLeftButton];
		
		_goRightButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[_goRightButton setImage:[UIImage imageNamed:@"arrow-right.png"] forState:UIControlStateNormal];
		[_goRightButton setImage:[UIImage imageNamed:@"arrow-right-ON.png"] forState:UIControlStateHighlighted];
		[_goRightButton addTarget:nil action:@selector(goRightButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_goRightButton];
		
		_bottomControlsView = [[UIView alloc] initWithFrame:CGRectZero];
		[self addSubview:_bottomControlsView];
		_buttonView = [[UIView alloc] initWithFrame:CGRectMake(0,45+8,320,51)];
		[_bottomControlsView addSubview:_buttonView];
		
		_wearItButton1 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[_wearItButton1 addTarget:nil action:@selector(wearOutfit1ButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
		[_buttonView addSubview:_wearItButton1];
		
		_wearItButton2 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[_wearItButton2 addTarget:nil action:@selector(wearOutfit2ButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
		[_buttonView addSubview:_wearItButton2];
		
		_wearItButton3 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[_wearItButton3 addTarget:nil action:@selector(wearOutfit3ButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
		[_buttonView addSubview:_wearItButton3];
		
		_wearItButton4 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[_wearItButton4 addTarget:nil action:@selector(wearOutfit4ButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
		[_buttonView addSubview:_wearItButton4];
		
		_changeItButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[_changeItButton addTarget:nil action:@selector(changeItButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
		[_buttonView addSubview:_changeItButton];
		
		_arrowIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"multiple-pointer.png"]];
		[_bottomControlsView addSubview:_arrowIndicator];
		
		_brandsView = [[UIView alloc] initWithFrame:CGRectZero];
		_brandsView.backgroundColor = RGBACOLOR(0,0,0,0.7);
		_brandsView.layer.cornerRadius = 3;
		_brandsView.clipsToBounds = YES;
		[_bottomControlsView addSubview:_brandsView];
		
		_brandsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 240, 40)];
		_brandsLabel.font = kGTIOFontHelveticaNeueOfSize(10);
		_brandsLabel.textColor = [UIColor whiteColor];
		_brandsLabel.backgroundColor = [UIColor clearColor];
		_brandsLabel.numberOfLines = 3;
		[_brandsView addSubview:_brandsLabel];
		
		_brandInfoButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[_brandInfoButton setImage:[UIImage imageNamed:@"brands.png"] forState:UIControlStateNormal];
		[_brandInfoButton addTarget:self action:@selector(showOrHideBrandInfo:) forControlEvents:UIControlEventTouchUpInside];
		[_bottomControlsView addSubview:_brandInfoButton];
		
		_overlay = [[GTIOMultiOutfitOverlay alloc] initWithFrame:CGRectZero];
		_overlay.expandedFrame = self.bounds;
        [self addSubview:_overlay];
        
        UISwipeGestureRecognizer* rightSwipeRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(overlaySwiped:)] autorelease];
        rightSwipeRecognizer.cancelsTouchesInView = NO;
        rightSwipeRecognizer.delaysTouchesBegan = YES;
        rightSwipeRecognizer.delegate = self;
        [_overlay addGestureRecognizer:rightSwipeRecognizer];
        
        UISwipeGestureRecognizer* leftSwipeRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(overlaySwiped:)] autorelease];
        leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        leftSwipeRecognizer.cancelsTouchesInView = NO;
        leftSwipeRecognizer.delaysTouchesBegan = YES;
        leftSwipeRecognizer.delegate = self;
        [_overlay addGestureRecognizer:leftSwipeRecognizer];
		
		_changeItReasonsOverlay = [[GTIOChangeItReasonsView alloc] initWithImage:[UIImage imageNamed:@"change-questions-bg.png"]];
		[_changeItReasonsOverlay setContentMode:UIViewContentModeBottomRight];
		_changeItReasonsOverlay.clipsToBounds = YES;
		
		[self setState:GTIOOutfitViewStateShowControls animated:NO];
	}
	return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UISwipeGestureRecognizer *)recognizer {
    int currentPage = _photosView.centerPageIndex;
    int modifier = 0;
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        modifier = 1;
    } else {
        modifier = -1;
    }
    int page = currentPage + modifier;
    if (page >= 0 && page < _photosView.numberOfPages) {
        return YES;
    }
    return NO;
}

- (void)overlaySwiped:(UISwipeGestureRecognizer*)recognizer {
    int currentPage = _photosView.centerPageIndex;
    int modifier = 0;
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        modifier = 1;
    } else {
        modifier = -1;
    }
    int page = currentPage + modifier;
    if (page >= 0 && page < _photosView.numberOfPages) {
        _skipSetLook = YES;
        [_overlay setLookPart2:page animated:YES];
        [_photosView setCenterPageIndex:page];
    }
}

- (void)dealloc {
    [_voteRequest cancel];
    
	[_draggingTimer invalidate];
	_draggingTimer = nil;
	
	[_outfit release];
	_outfit = nil;
	
    TT_RELEASE_SAFELY(_overlayView);
	TT_RELEASE_SAFELY(_buttonView);
	TT_RELEASE_SAFELY(_photosView);
	TT_RELEASE_SAFELY(_topControlsView);
	TT_RELEASE_SAFELY(_bottomControlsView);
	TT_RELEASE_SAFELY(_wearItButton1);
	TT_RELEASE_SAFELY(_wearItButton2);
	TT_RELEASE_SAFELY(_wearItButton3);
	TT_RELEASE_SAFELY(_wearItButton4);
	TT_RELEASE_SAFELY(_changeItButton);
	TT_RELEASE_SAFELY(_goLeftButton);
	TT_RELEASE_SAFELY(_goRightButton);
	TT_RELEASE_SAFELY(_brandsView);
	TT_RELEASE_SAFELY(_brandInfoButton);
	TT_RELEASE_SAFELY(_brandsLabel);
	TT_RELEASE_SAFELY(_verdictView);
	TT_RELEASE_SAFELY(_changeItReasonsOverlay);
	TT_RELEASE_SAFELY(_roundedCornerImageView);
	TT_RELEASE_SAFELY(_arrowIndicator);
	TT_RELEASE_SAFELY(_overlay);

	[super dealloc];
}

- (NSDictionary*)currentPhoto {
	return [_outfit.photos objectAtIndex:_photosView.centerPageIndex];
}

- (void)updateLooksLabels {
	NSString* brands = [self.currentPhoto objectForKey:@"brands"];
	_brandsLabel.text = [brands uppercaseString];
	if (brands == nil || [brands isWhitespaceAndNewlines]) {
		_brandsView.alpha = 0;
		_brandInfoButton.alpha = 0;
	} else {
		
		_brandInfoButton.frame = CGRectMake(320 - 70, 15, 62, 29);
		_brandsView.frame = CGRectMake(320 - 40, 25, 0, 0);
		
		[_bottomControlsView addSubview:_brandsView];
		_brandsView.alpha = 1;
		[_bottomControlsView addSubview:_brandInfoButton];
		_brandInfoButton.alpha = 1;
	}
}

- (void)updateVerdictViews {
	if (nil == _verdictView) {
		_verdictView = [[GTIOVerdictView alloc] initWithFrame:CGRectMake(0, self.height, 320, 67)];
		[self addSubview:_verdictView];
	}
	
	GTIOVotingResultSet* resultSet = _outfit.results;
	[_verdictView setResultSet:resultSet];
	
	if ((resultSet.userVoteString || [_outfit.uid isEqual:[GTIOUser currentUser].UID]) && _state != GTIOOutfitViewStateFullscreen) {
		_verdictView.alpha = 1;
		_verdictView.frame = CGRectMake(0, self.height - 67, 320, 67);
		_bottomControlsView.frame = CGRectOffset(CGRectMake(0, 356-45, 320, 60+35), 0, -60);
	} else {
		_verdictView.alpha = 0;
		if (_state != GTIOOutfitViewStateFullscreen) {
			_bottomControlsView.frame = CGRectMake(0, 356-45, 320, 60+35);
		}
	}
}

- (void)updateVoteButtons {
	_wearItButton2.alpha = 0;
	_wearItButton3.alpha = 0;
	_wearItButton4.alpha = 0;
	switch ([_outfit.photos count]) {
		case 1:
			[_wearItButton1 setImage:[UIImage imageNamed:@"vote-1-wear-off.png"] forState:UIControlStateNormal];
			[_wearItButton1 setImage:[UIImage imageNamed:@"vote-1-wear-off.png"] forState:UIControlStateDisabled];
			[_wearItButton1 setImage:[UIImage imageNamed:@"vote-1-wear-on.png"] forState:UIControlStateSelected];
			[_wearItButton1 setImage:[UIImage imageNamed:@"vote-1-wear-on.png"] forState:UIControlStateHighlighted];
			_wearItButton1.frame = wear1of1Frame;
			
			_wearItButton2.frame = CGRectZero;
			_wearItButton4.frame = CGRectZero;
			_wearItButton3.frame = CGRectZero;
			break;
		case 2:
			[_wearItButton1 setImage:[UIImage imageNamed:@"vote-2-1-off.png"] forState:UIControlStateNormal];
			[_wearItButton1 setImage:[UIImage imageNamed:@"vote-2-1-off.png"] forState:UIControlStateDisabled];
			[_wearItButton1 setImage:[UIImage imageNamed:@"vote-2-1-on.png"] forState:UIControlStateSelected];
			[_wearItButton1 setImage:[UIImage imageNamed:@"vote-2-1-on.png"] forState:UIControlStateHighlighted];
			_wearItButton1.frame = wear1of2Frame;
			
			[_wearItButton2 setImage:[UIImage imageNamed:@"vote-2-2-off.png"] forState:UIControlStateNormal];
			[_wearItButton2 setImage:[UIImage imageNamed:@"vote-2-2-off.png"] forState:UIControlStateDisabled];
			[_wearItButton2 setImage:[UIImage imageNamed:@"vote-2-2-on.png"] forState:UIControlStateSelected];
			[_wearItButton2 setImage:[UIImage imageNamed:@"vote-2-2-on.png"] forState:UIControlStateHighlighted];
			_wearItButton2.frame = wear2of2Frame;
			_wearItButton2.alpha = 1;
			
			_wearItButton4.frame = CGRectZero;
			_wearItButton3.frame = CGRectZero;
			
			break;
		case 3:
			[_wearItButton1 setImage:[UIImage imageNamed:@"vote-3-1-off.png"] forState:UIControlStateNormal];
			[_wearItButton1 setImage:[UIImage imageNamed:@"vote-3-1-off.png"] forState:UIControlStateDisabled];
			[_wearItButton1 setImage:[UIImage imageNamed:@"vote-3-1-on.png"] forState:UIControlStateSelected];
			[_wearItButton1 setImage:[UIImage imageNamed:@"vote-3-1-on.png"] forState:UIControlStateHighlighted];
			_wearItButton1.frame = wear1of3Frame;
			
			[_wearItButton2 setImage:[UIImage imageNamed:@"vote-3-2-off.png"] forState:UIControlStateNormal];
			[_wearItButton2 setImage:[UIImage imageNamed:@"vote-3-2-off.png"] forState:UIControlStateDisabled];
			[_wearItButton2 setImage:[UIImage imageNamed:@"vote-3-2-on.png"] forState:UIControlStateSelected];
			[_wearItButton2 setImage:[UIImage imageNamed:@"vote-3-2-on.png"] forState:UIControlStateHighlighted];
			_wearItButton2.frame = wear2of3Frame;
			_wearItButton2.alpha = 1;
			
			[_wearItButton3 setImage:[UIImage imageNamed:@"vote-3-3-off.png"] forState:UIControlStateNormal];
			[_wearItButton3 setImage:[UIImage imageNamed:@"vote-3-3-off.png"] forState:UIControlStateDisabled];
			[_wearItButton3 setImage:[UIImage imageNamed:@"vote-3-3-on.png"] forState:UIControlStateSelected];
			[_wearItButton3 setImage:[UIImage imageNamed:@"vote-3-3-on.png"] forState:UIControlStateHighlighted];
			_wearItButton3.frame = wear3of3Frame;
			_wearItButton3.alpha = 1;
			
			_wearItButton4.frame = CGRectZero;
			break;
			
		case 4:
			[_wearItButton1 setImage:[UIImage imageNamed:@"vote-4-1-off.png"] forState:UIControlStateNormal];
			[_wearItButton1 setImage:[UIImage imageNamed:@"vote-4-1-off.png"] forState:UIControlStateDisabled];
			[_wearItButton1 setImage:[UIImage imageNamed:@"vote-4-1-on.png"] forState:UIControlStateSelected];
			[_wearItButton1 setImage:[UIImage imageNamed:@"vote-4-1-on.png"] forState:UIControlStateHighlighted];
			_wearItButton1.frame = wear1of4Frame;
			
			[_wearItButton2 setImage:[UIImage imageNamed:@"vote-4-2-off.png"] forState:UIControlStateNormal];
			[_wearItButton2 setImage:[UIImage imageNamed:@"vote-4-2-off.png"] forState:UIControlStateDisabled];
			[_wearItButton2 setImage:[UIImage imageNamed:@"vote-4-2-on.png"] forState:UIControlStateSelected];
			[_wearItButton2 setImage:[UIImage imageNamed:@"vote-4-2-on.png"] forState:UIControlStateHighlighted];
			_wearItButton2.frame = wear2of4Frame;
			_wearItButton2.alpha = 1;
			
			[_wearItButton3 setImage:[UIImage imageNamed:@"vote-4-3-off.png"] forState:UIControlStateNormal];
			[_wearItButton3 setImage:[UIImage imageNamed:@"vote-4-3-off.png"] forState:UIControlStateDisabled];
			[_wearItButton3 setImage:[UIImage imageNamed:@"vote-4-3-on.png"] forState:UIControlStateSelected];
			[_wearItButton3 setImage:[UIImage imageNamed:@"vote-4-3-on.png"] forState:UIControlStateHighlighted];
			_wearItButton3.frame = wear3of4Frame;
			_wearItButton3.alpha = 1;
			
			[_wearItButton4 setImage:[UIImage imageNamed:@"vote-4-4-off.png"] forState:UIControlStateNormal];
			[_wearItButton4 setImage:[UIImage imageNamed:@"vote-4-4-off.png"] forState:UIControlStateDisabled];
			[_wearItButton4 setImage:[UIImage imageNamed:@"vote-4-4-on.png"] forState:UIControlStateSelected];
			[_wearItButton4 setImage:[UIImage imageNamed:@"vote-4-4-on.png"] forState:UIControlStateHighlighted];
			_wearItButton4.frame = wear4of4Frame;
			_wearItButton4.alpha = 1;
			
			break;
	}
	
	switch ([_outfit.photos count]) {
		case 1:
			[_changeItButton setImage:[UIImage imageNamed:@"vote-1-change-off.png"] forState:UIControlStateNormal];
			[_changeItButton setImage:[UIImage imageNamed:@"vote-1-change-off.png"] forState:UIControlStateDisabled];
			[_changeItButton setImage:[UIImage imageNamed:@"vote-1-change-on.png"] forState:UIControlStateSelected];
			[_changeItButton setImage:[UIImage imageNamed:@"vote-1-change-on.png"] forState:UIControlStateHighlighted];
			_changeItButton.frame = changeItFrame;
			_arrowIndicator.frame = CGRectZero;
			break;
		default:
			[_changeItButton setImage:[UIImage imageNamed:@"vote-none-off.png"] forState:UIControlStateNormal];
			[_changeItButton setImage:[UIImage imageNamed:@"vote-none-off.png"] forState:UIControlStateDisabled];
			[_changeItButton setImage:[UIImage imageNamed:@"vote-none-on.png"] forState:UIControlStateSelected];
			[_changeItButton setImage:[UIImage imageNamed:@"vote-none-on.png"] forState:UIControlStateHighlighted];
			_changeItButton.frame = wearNoneFrame;
			[_arrowIndicator sizeToFit];
			break;
	}
	
	// Dissable buttons.
	_wearItButton1.enabled = NO;
	_wearItButton2.enabled = NO;
	_wearItButton3.enabled = NO;
	_wearItButton4.enabled = NO;
	_changeItButton.enabled = NO;
	
	switch (_outfit.results.userVoteIndex) {
		case 0:
			[_changeItButton setImage:[_changeItButton imageForState:UIControlStateSelected] forState:UIControlStateDisabled];
			break;
		case 1:
			[_wearItButton1 setImage:[_wearItButton1 imageForState:UIControlStateSelected] forState:UIControlStateDisabled];
			break;
		case 2:
			[_wearItButton2 setImage:[_wearItButton2 imageForState:UIControlStateSelected] forState:UIControlStateDisabled];
			break;
		case 3:
			[_wearItButton3 setImage:[_wearItButton3 imageForState:UIControlStateSelected] forState:UIControlStateDisabled];
			break;
		case 4:
			[_wearItButton4 setImage:[_wearItButton4 imageForState:UIControlStateSelected] forState:UIControlStateDisabled];
			break;
		default:
			_wearItButton1.enabled = YES;
			_wearItButton2.enabled = YES;
			_wearItButton3.enabled = YES;
			_wearItButton4.enabled = YES;
			_changeItButton.enabled = YES;
			break;
	}
}

- (void)showLoadingMoreOverlay {
    [self addSubview:_overlay];
    [self addSubview:_goLeftButton];
    _goRightButton.alpha = 0;
}

- (void)setOutfitWithoutMultiOverlay:(GTIOOutfit *)outfit {
    [outfit retain];
	[_outfit release];
	_outfit = outfit;
	
	_topControlsView.outfit = outfit;
	
	_photosView.dataSource = _outfit;
	_photosView.delegate = self;
	_photosView.shouldScroll = [[_outfit isMultipleOption] boolValue];
	
	[_overlay setOutfitWithoutResettingOverlay:outfit];
	
	[self updateLooksLabels];
	[self updateVerdictViews];
	[self updateVoteButtons];
    
    if (_outfit == nil) {
        [self showLoadingMoreOverlay];
    } else {
        [_overlayView removeFromSuperview];
    }
}

- (void)setOutfit:(GTIOOutfit *)outfit {
	[_photosView moveToPageAtIndex:0 resetEdges:YES];
    [self setOutfitWithoutMultiOverlay:outfit];
    _overlay.outfit = outfit;
   	
    if ([self isMultiLookOutfit]) {
		[_overlay setLook:0 animated:NO];
		_overlay.frame = _overlay.expandedFrame;
	} else {
		_overlay.frame = CGRectZero;
	}
}

- (void)setWillMoveInFromLeft:(BOOL)fromLeft {
	if ([self isMultiLookOutfit]) {
		int index = fromLeft ? [_outfit.photos count] - 1 : 0;
		[_photosView moveToPageAtIndex:index resetEdges:YES];
		[_overlay setLook:index animated:NO];
	}
}

- (BOOL)isMultiLookOutfit {
	return [_outfit.photos count] > 1;
}

- (BOOL)hasNextLook {
	return _photosView.centerPageIndex + 1 < [_photosView numberOfPages];
}

- (BOOL)hasPreviousLook {
	return _photosView.centerPageIndex > 0;
}

- (void)showNextLook {
	[_photosView moveToPageAtIndex:_photosView.centerPageIndex + 1 resetEdges:YES];
}

- (void)showPreviousLook {
	[_photosView moveToPageAtIndex:_photosView.centerPageIndex - 1 resetEdges:YES];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	_photosView.frame = self.bounds;
	
	_overlay.expandedFrame = self.bounds;
	
	_roundedCornerImageView.frame = CGRectMake(self.bounds.origin.x, self.bounds.size.height - 6, self.bounds.size.width, 6);
	
	if ([self isMultiLookOutfit]) {
		_overlay.collapsedFrame = CGRectMake(0, 50, 100, 40);
		if (CGRectEqualToRect(_overlay.frame, CGRectZero)) {
			_overlay.frame = _overlay.collapsedFrame;
		}
	} else {
		_overlay.collapsedFrame = CGRectZero;
	}
	_goLeftButton.frame = CGRectMake(0-3, 180-3, 30+6, 30+6);
	_goRightButton.frame = CGRectMake(290-3, 180-3, 30+6, 30+6);
	_brandsView.frame = CGRectMake(320 - 40, 35, 0, 0);
}

- (void)setIsLastPage:(BOOL)isLastPage {
    _isLastPage = isLastPage;
    _goRightButton.alpha = (isLastPage ? 1 : 0);
}

- (void)showFullDescription:(BOOL)show {
    [_topControlsView showFullDescription:show];
    if (show) {
        // Hide arrows
        _goLeftButton.alpha = 0;
        _goRightButton.alpha = 0;
    } else {
        // show arrows
        if (self.isLastPage && ![self hasNextLook]) {
            _goRightButton.alpha = 0;
        } else {
            _goRightButton.alpha = 1;
        }
        if (self.isFirstPage && ![self hasPreviousLook]) {
            _goLeftButton.alpha = 0;
        } else {
            _goLeftButton.alpha = 1;
        }
    }
}

- (void)setState:(GTIOOutfitViewState)state animated:(BOOL)animated {
    _photosView.centerPage.userInteractionEnabled = YES;
    if (_photosView.zoomed) {
        self.userInteractionEnabled = NO;
        [_photosView zoomToFit];
        NSLog(@"Zooming Out");
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
        [self setState:state animated:animated];
    }
    self.userInteractionEnabled = YES;
    
	_state = state;
    
//	[_photosView zoomToFit];
//    _photosView.centerPage.userInteractionEnabled = YES;
//    [_photosView zoomToFit];
    
    if (animated) {
		[UIView beginAnimations:nil context:nil];
	}
	
	switch (_state) {
		case GTIOOutfitViewStateFullDescription:
            GTIOAnalyticsEvent(kOutfitDescriptionExpandedEventName);
            [(GTIOScrollView*)self.superview setDragToRefresh:YES];
			_topControlsView.frame = CGRectMake(3, 3, 320, 280);
			_overlay.alpha = 0;
			[self showFullDescription:YES];
			break;
		case GTIOOutfitViewStateShowControls:
            [(GTIOScrollView*)self.superview setDragToRefresh:YES];
			_topControlsView.frame = CGRectMake(3, 3, 320, 50);
			[self showFullDescription:NO];
			_topControlsView.alpha = 1;
			_brandsView.alpha = 1;
			_bottomControlsView.alpha = 1;
			_overlay.alpha = 1;
			_changeItReasonsOverlay.alpha = 1;
			break;
		case GTIOOutfitViewStateFullscreen:
            GTIOAnalyticsEvent(kOutfitFullScreenEventName);
            _photosView.centerPage.userInteractionEnabled = NO;
            [(GTIOScrollView*)self.superview setDragToRefresh:NO];
			_topControlsView.alpha = 0;
			_goLeftButton.alpha = 0;
			_goRightButton.alpha = 0;
			_brandsView.alpha = 0;
			_bottomControlsView.alpha = 0;
			_overlay.alpha = 0;
			_changeItReasonsOverlay.alpha = 0;
			break;
	}
	[self updateVerdictViews];
	
	if (animated) {
		[UIView commitAnimations];
	}
}

- (BOOL)continueAfterHandlingTouch:(UITouch*)touch forState:(GTIOOutfitViewState*)state {
	if (GTIOOutfitViewStateFullscreen == _state) {
		return YES;
	}
	
	if ([_wearItButton1 pointInside:[touch locationInView:_wearItButton1] withEvent:nil] ||
		[_wearItButton2 pointInside:[touch locationInView:_wearItButton2] withEvent:nil] ||
		[_wearItButton3 pointInside:[touch locationInView:_wearItButton3] withEvent:nil] ||
		[_wearItButton4 pointInside:[touch locationInView:_wearItButton4] withEvent:nil] ||
		[_changeItButton pointInside:[touch locationInView:_changeItButton] withEvent:nil] ||
		[_verdictView pointInside:[touch locationInView:_verdictView] withEvent:nil]) {
		// Do not pass through touches on dissabled buttons or the verdict view.
		return NO;
	}
	
	// TODO: clean this up. kvc here is gross.
	TTTextEditor* editor = [_topControlsView valueForKey:@"_reviewTextArea"];
	
	if (_changeItReasonsOverlay.superview) {
		*state = GTIOOutfitViewStateFullscreen;
		[self setState:*state animated:YES];
		return NO;
	}
	
	CGPoint location = [touch locationInView:editor];
	if (editor.alpha > 0 && [editor pointInside:location withEvent:nil]) {
		return NO;
	}
	
	if (editor.editing) {
		[editor resignFirstResponder];
		return NO;
	}
	
	if ([_brandsView pointInside:[touch locationInView:_brandsView] withEvent:nil]) {
		[self showOrHideBrandInfo:nil];
		return NO;
	}
	
	if ([_overlay pointInside:[touch locationInView:_overlay] withEvent:nil]) {
		int page = [_overlay expandOrContractWithTouch:touch];
		if (page >= 0) {
			_skipSetLook = YES;
			[_photosView setCenterPageIndex:page];
		}
		return NO;
	}
	
	CGPoint point = [touch locationInView:_topControlsView];
	BOOL inside = [_topControlsView pointInside:point withEvent:nil];
	
	if (inside && (*state == GTIOOutfitViewStateShowControls)) {
		*state = GTIOOutfitViewStateFullDescription;
		[self setState:*state animated:YES];
		return NO;
	} else if (*state == GTIOOutfitViewStateFullDescription) {
		*state = GTIOOutfitViewStateShowControls;
		[self setState:*state animated:YES];
		return NO;
	}
	
	
	return YES;
}

- (void)showOrHideBrandInfo:(id)sender {
	CGRect showRect = CGRectMake(5, 5, 310, 45);
	if (CGRectEqualToRect(showRect, _brandsView.frame)) {
		_brandsView.frame = CGRectMake(320 - 40, 25, 0, 0);
	} else {
		_brandsView.frame = showRect;
	}
}

- (void)positionScrollIndicator {
	int pageIndex = _photosView.centerPageIndex;
	CGRect rect = CGRectZero;
	switch ([_outfit.photos count]) {
		case 2:
			rect = (pageIndex == 0 ? wear1of2Frame : wear2of2Frame);
			break;
		case 3:
			rect = (pageIndex == 0 ? wear1of3Frame : (pageIndex == 1 ? wear2of3Frame : wear3of3Frame));
			break;
		case 4:
			rect = (pageIndex == 0 ? wear1of4Frame : 
					(pageIndex == 1 ? wear2of4Frame : 
					 (pageIndex == 2 ? wear3of4Frame : wear4of4Frame)));
			break;
			
	}
	_arrowIndicator.center = CGPointMake(rect.origin.x + (rect.size.width / 2), 48);
}

- (void)scrollView:(GTIOScrollView*)scrollView didMoveToPageAtIndex:(NSInteger)pageIndex {
	NSLog(@"Moved to page: %d", pageIndex);
	[self updateLooksLabels];
	if ([self isMultiLookOutfit] && scrollView.lastPageIndex >= 0 && !_skipSetLook) {
		BOOL animate = (self.frame.origin.x < 320);
		[_overlay setLook:pageIndex animated:animate];
	}
	if ([self isMultiLookOutfit]) {
		BOOL animate = scrollView.lastPageIndex >= 0;
		if (animate) {
			[UIView beginAnimations:nil context:nil];
		}
		[self positionScrollIndicator];
		if (animate) {
			[UIView commitAnimations];
		}
	}
	_skipSetLook = NO;
}

- (void)mayHaveDisappeared {
	[self addSubview:_goRightButton];
	[self addSubview:_goLeftButton];
	[_bottomControlsView addSubview:_brandsView];
	[_bottomControlsView addSubview:_brandInfoButton];
    [_changeItReasonsOverlay resetChangeItSelections];
	[_changeItReasonsOverlay removeFromSuperview];
    _changeItButton.alpha = 1;
	_wearItButton1.enabled = YES;
	[self updateVoteButtons];
	if ([self isMultiLookOutfit]) {
		[_overlay setLook:_overlay.lookIndex animated:NO];
	}
	[self positionScrollIndicator];
	[self showFullDescription:NO];
    [_overlayView removeFromSuperview];
}

- (void)didAppear {
	if ([self isMultiLookOutfit]) {
		[_overlay zoomOutAfterDelay:2];
	}
    _topControlsView.outfit = _outfit;
    if (nil == _outfit) {
        [self showLoadingMoreOverlay];
    }
}

- (BOOL)scrollViewShouldZoom:(TTScrollView*)scrollView {
	return _state == GTIOOutfitViewStateFullscreen;
}

- (void)timerFired:(NSTimer*)timer {
	UIEdgeInsets insets;
	[[_photosView valueForKey:@"_pageEdges"] getValue:&insets];
	
	[_overlay draggedWithLeftOffset:insets.left];
}

- (void)scrollViewWillBeginDragging:(TTScrollView*)scrollView {
	if ([self isMultiLookOutfit]) {
		[_draggingTimer invalidate];
		_draggingTimer = nil;
		_draggingTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
	}
}

- (void)scrollViewDidEndDragging:(TTScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if ([self isMultiLookOutfit] && !decelerate) {
		[_draggingTimer invalidate];
		_draggingTimer = nil;
	}
}

- (void)scrollViewDidEndDecelerating:(TTScrollView*)scrollView {
	if ([self isMultiLookOutfit]) {
		[_draggingTimer invalidate];
		_draggingTimer = nil;
	}
}

#pragma mark -
#pragma mark Voting

- (void)voteForLook:(NSInteger)look reasons:(NSArray*)reasons {
	NSString* userVote = [NSString stringWithFormat:@"wear%d", look];
	[_outfit.results setUserVoteString:userVote];
	NSNumber* count = [_outfit.results valueForKey:userVote];
	count = [NSNumber numberWithInt:[count intValue] + 1];
	[_outfit.results setValue:count forKey:userVote];
	
//	if (![_outfit.uid isEqual:[GTIOUser currentUser].UID]) {
		[_verdictView hideAllViews];
		[UIView beginAnimations:nil context:nil];
		[self updateVerdictViews];
		[UIView commitAnimations];
//	}
	[self updateVoteButtons];


	_voteRequest = [GTIOUser voteForOutfit:_outfit.outfitID look:look reasons:reasons delegate:self];
}

- (void)voteForLook:(NSInteger)look {
	[self voteForLook:look reasons:nil];
}

- (void)wearOutfit1ButtonWasPressed:(id)sender {
	[self voteForLook:1];
}

- (void)wearOutfit2ButtonWasPressed:(id)sender {
	[self voteForLook:2];
}

- (void)wearOutfit3ButtonWasPressed:(id)sender {
	[self voteForLook:3];
}

- (void)wearOutfit4ButtonWasPressed:(id)sender {
	[self voteForLook:4];
}

- (void)changeItButtonWasPressed:(id)sender {
    NSLog(@"outfit.uid=%@ user.uid=%@",_outfit.uid,[GTIOUser currentUser].UID);
    if ([self isMultiLookOutfit]) {
        [self voteForLook:0];
    } else if ([_outfit.uid isEqual:[GTIOUser currentUser].UID]) {
        [self voteForLook:0 reasons:nil];
    } else {
        _changeItReasonsOverlay.backgroundColor = [UIColor clearColor];
        _changeItReasonsOverlay.frame = CGRectOffset(changeItFrame, 0, 365);
        _changeItReasonsOverlay.userInteractionEnabled = YES;
        _changeItReasonsOverlay.exclusiveTouch = YES;
		
		UIView* view = [[TTNavigator navigator] topViewController].view;
		[view addSubview:_changeItReasonsOverlay];
		[UIView beginAnimations:nil context:nil];
		
		if (_state == GTIOOutfitViewStateFullDescription) {
			[self setState:GTIOOutfitViewStateShowControls animated:NO];
		}

		_changeItReasonsOverlay.frame = CGRectMake(56, 76, 264, 340);
        _changeItButton.alpha = 0;
		_wearItButton1.enabled = NO;
		[_goRightButton removeFromSuperview];
		[_goLeftButton removeFromSuperview];
		[_brandsView removeFromSuperview];
		[_brandInfoButton removeFromSuperview];
		[UIView commitAnimations];
	}
}

- (void)doneOrNextButtonWasPressed:(id)sender {
	NSLog(@"Change It!");
	[UIView beginAnimations:nil context:nil];
	_changeItReasonsOverlay.frame = CGRectOffset(changeItFrame, 0, 365);
    _changeItButton.alpha = 1;
	[self addSubview:_goRightButton];
	[self addSubview:_goLeftButton];
	[_bottomControlsView addSubview:_brandsView];
	[_bottomControlsView addSubview:_brandInfoButton];
	[UIView commitAnimations];
	[UIView beginAnimations:nil context:nil];
	[_changeItReasonsOverlay removeFromSuperview];
	_wearItButton1.enabled = YES;
	[UIView commitAnimations];
    NSArray* reasons = [_changeItReasonsOverlay selectedChangeItReasons];
    if ([reasons count] == 0) {
        GTIOAnalyticsEvent(kWhyChangeSkipped);
    } else {
        GTIOAnalyticsEvent(kWhyChangeSubmitted);
    }
	[self voteForLook:0 reasons:reasons];
}

- (void)writeAReviewButtonWasPressed:(id)sender {
	NSLog(@"Write A review!");
	[self doneOrNextButtonWasPressed:sender];
	NSString* url = [NSString stringWithFormat:@"gtio://show_reviews/%@", self.outfit.outfitID];
	TTOpenURL(url);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    _voteRequest = nil;
	NSLog(@"Loaded: %@", objects);
	GTIOVotingResultSet* results = [objects objectWithClass:[GTIOVotingResultSet class]];
	NSLog(@"Recorded user vote of: %@", results.userVoteString);
	_outfit.results = results;
	// Don't show them a changed verdict if its their own outfit
	if ([_outfit.uid isEqual:[GTIOUser currentUser].UID]) {
		results.verdict = [[_verdictView resultSet] verdict];
	}

	[_verdictView setResultSet:results];			
	[_verdictView animateInData];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    _voteRequest = nil;
	[_verdictView animateInData];
    GTIOErrorMessage(error);
}

@end
