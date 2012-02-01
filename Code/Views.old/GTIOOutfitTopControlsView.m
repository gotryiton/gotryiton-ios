//
//  GTIOOutfitTopControlsView.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/25/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOOutfitTopControlsView.h"
#import "GTIOOutfitPageView.h"

@implementation GTIOOutfitTopControlsView

@synthesize outfit = _outfit;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
		
		_reviewsButtonSmall = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _reviewsButtonSmall.accessibilityLabel = @"reviews";
		[_reviewsButtonSmall addTarget:nil action:@selector(showReviewsButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
		_reviewsButtonSmall.titleLabel.font = kGTIOFontBoldHelveticaNeueOfSize(18);
		[self addSubview:_reviewsButtonSmall];
		
		_shareButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[_shareButton addTarget:nil action:@selector(shareButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
		_shareButton.titleLabel.font = kGTIOFontBoldHelveticaNeueOfSize(18);
		[_shareButton setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
		_shareButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 12, 0);
		_shareButton.frame = CGRectMake(250, 0, 65, 0);
		[self addSubview:_shareButton];
		
		_toolsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[_toolsButton addTarget:nil action:@selector(toolsButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
		_toolsButton.titleLabel.font = kGTIOFontBoldHelveticaNeueOfSize(18);
		[_toolsButton setBackgroundImage:[UIImage imageNamed:@"tools.png"] forState:UIControlStateNormal];
		_toolsButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 12, 0);
		_toolsButton.frame = CGRectMake(250, 0, 65, 0);
		[self addSubview:_toolsButton];
        
        _suggestButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[_suggestButton addTarget:nil action:@selector(suggestButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
		_suggestButton.titleLabel.font = kGTIOFontBoldHelveticaNeueOfSize(18);
		[_suggestButton setBackgroundImage:[UIImage imageNamed:@"suggest.png"] forState:UIControlStateNormal];
		_suggestButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 12, 0);
		_suggestButton.frame = CGRectMake(250, 0, 65, 0);
		[self addSubview:_suggestButton];
		
		_descriptionView = [[UIImageView alloc] initWithFrame:CGRectZero];
		_descriptionView.image = [[UIImage imageNamed:@"description-background.png"] stretchableImageWithLeftCapWidth:125 topCapHeight:25];
		[self addSubview:_descriptionView];
		
		_descriptionText = [[GTIOMultiLineQuotedLabel alloc] initWithFrame:CGRectZero];
		_descriptionText.backgroundColor = [UIColor clearColor];
		[self addSubview:_descriptionText];
		
		_descriptionTextSmall = [[GTIOMultiLineQuotedLabel alloc] initWithFrame:CGRectZero];
		_descriptionTextSmall.backgroundColor = [UIColor clearColor];
		[self addSubview:_descriptionTextSmall];
		
		_forLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_forLabel.text = @"FOR";
		_forLabel.font = kGTIOFontBoldHelveticaNeueOfSize(12);
		_forLabel.textColor = kGTIOColor6A6A6A;
		_forLabel.clipsToBounds = YES;
		_forLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:_forLabel];
		
		_forTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_forTextLabel.backgroundColor = [UIColor clearColor];
		_forTextLabel.font = kGTIOFontHelveticaNeueOfSize(16);
		_forTextLabel.textColor = kGTIOColorBrightPink;
		_forTextLabel.clipsToBounds = YES;
		[self addSubview:_forTextLabel];
		
		UIImage* img = [[UIImage imageNamed:@"write-review-box.png"] stretchableImageWithLeftCapWidth:232/2 topCapHeight:46/2];
		_reviewTextAreaBackground = [[UIImageView alloc] initWithImage:img];
		[self addSubview:_reviewTextAreaBackground];
		_reviewTextArea = [[TTTextEditor alloc] initWithFrame:CGRectZero];
		_reviewTextArea.backgroundColor = [UIColor clearColor];
		_reviewTextArea.minNumberOfLines = 2;
		_reviewTextArea.maxNumberOfLines = 2;
		
		_reviewTextArea.font = kGTIOFontHelveticaNeueOfSize(12);
		// Single line placeholder only. need to fake it out to use multi line.
		//_reviewTextArea.placeholder = @"write a review! remember - our\ncomments are helpful, not hurtful";
		_placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_placeholderLabel.font = kGTIOFontBoldHelveticaNeueOfSize(12);
		_placeholderLabel.text = @"write a review!  remember - our\ncomments are helpful, not hurtful.";
		_placeholderLabel.textColor = kGTIOColorbfbfbf;
		_placeholderLabel.numberOfLines = 2;
		_placeholderLabel.backgroundColor = [UIColor clearColor];
		_reviewTextArea.delegate = self;
		_reviewTextArea.returnKeyType = UIReturnKeyDone;//UIReturnKeySend;
		_reviewTextArea.style = nil;
		[self addSubview:_reviewTextArea];
		[self addSubview:_placeholderLabel];
		
		_expandArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"expand-arrow.png"]];
		_expandArrow.frame = CGRectMake(225, 30, 17, 10);
		[self addSubview:_expandArrow];
		
		_full = NO;
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[_reviewTextAreaBackground release];
	_reviewTextAreaBackground = nil;
	
	[_reviewTextArea release];
	_reviewTextArea = nil;
	
	[_placeholderLabel release];
	_placeholderLabel = nil;
	
	[_descriptionText release];
	_descriptionText = nil;
	
	[_descriptionTextSmall release];
	_descriptionTextSmall = nil;
	
	[_reviewsButtonSmall release];
	_reviewsButtonSmall = nil;
	
	[_forLabel release];
	_forLabel = nil;
	
	[_forTextLabel release];
	_forTextLabel = nil;
	
	[_outfit release];
	_outfit = nil;
	
	[_expandArrow release];
	_expandArrow = nil;
	
	[_shareButton release];
	_shareButton = nil;
	
	[_toolsButton release];
	_toolsButton = nil;
    
    [_suggestButton release];
    _suggestButton = nil;
	
	[super dealloc];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* t = [touches anyObject];
	if ([touches count] == 1 &&
		[_placeholderLabel pointInside:[t locationInView:_placeholderLabel] withEvent:event]) {
		[_reviewTextArea becomeFirstResponder];
	}
	[super touchesEnded:touches withEvent:event];
}

- (void)setOutfit:(GTIOOutfit*)outfit {
	[outfit retain];
	[_outfit release];
	_outfit = outfit;
	
	// update everything here.
    NSString* descriptionString = outfit.descriptionString;
	_descriptionText.text = descriptionString;
    _descriptionTextSmall.text = descriptionString;
    
//	[_descriptionText setNeedsDisplay];
	CGSize sizeOfDescription = [_descriptionText approximateSizeConstrainedTo:CGSizeMake(215,156)];
	NSLog(@"Size: %@", NSStringFromCGSize(sizeOfDescription));
	_descriptionText.frame = CGRectMake(10, 7+18-1, 215, sizeOfDescription.height+3);//240, 106);
	[_descriptionText setNeedsDisplay];
	
	[_descriptionTextSmall setNeedsDisplay];
	_forTextLabel.text = outfit.event;
	[_forTextLabel setNeedsDisplay];
	[_reviewsButtonSmall setTitle:_outfit.reviewCountString forState:UIControlStateNormal];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	_forLabel.frame = CGRectMake(10, 10-4, 30, 20);
	if (TTOSVersion() < 3.2) {
		_forTextLabel.frame = CGRectMake(40, 7.5-4, 200, 20);
	} else {
		_forTextLabel.frame = CGRectMake(40, 9.5-4, 200, 20);
	}
	
	float y = _descriptionText.origin.y + _descriptionText.height + 15;
    y = MAX(64,y);
    _reviewTextArea.frame = CGRectMake(10, y, 229, 46);
	_reviewTextAreaBackground.frame = _reviewTextArea.frame;
	
	_descriptionTextSmall.frame = CGRectMake(10, 7+18-1, 215, 20);
	[_descriptionTextSmall setNeedsDisplay];
	
	[_reviewTextArea sizeToFit];
	
	_forLabel.alpha = 1;
	_forTextLabel.alpha = 1;
	
	if (_full) {
		_descriptionView.alpha = 0.85;
		_descriptionView.frame = CGRectMake(0, 0, 249, _reviewTextArea.origin.y + _reviewTextArea.height + 8);
		
		_reviewTextArea.alpha = 1;
		_reviewTextAreaBackground.alpha = 1;
		_placeholderLabel.alpha = ([_reviewTextArea.text length] > 0 ? 0 : 1);
		_descriptionText.alpha = 1;
		_descriptionTextSmall.alpha = 0;
		
		_placeholderLabel.frame = CGRectInset(_reviewTextArea.frame, 10, 4);
		
		[_reviewsButtonSmall setBackgroundImage:[UIImage imageNamed:@"reviews.png"] forState:UIControlStateNormal];
		_reviewsButtonSmall.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 12, 0);
		
		if ([_outfit.uid isEqualToString:[[GTIOUser currentUser] UID]]) {
			_toolsButton.frame = CGRectMake(249, 0, 65, 60);
            _shareButton.frame = CGRectMake(249, 60, 65, 60);
			_reviewsButtonSmall.frame = CGRectMake(250, 120, 65, 60);
		} else {
            _suggestButton.frame = CGRectMake(249, 0, 65, 60);
			_shareButton.frame = CGRectMake(250, 60, 65, 60);
			_reviewsButtonSmall.frame = CGRectMake(250, 120, 65, 60);
		}
		
		_expandArrow.alpha = 0;
	} else {
		_expandArrow.alpha = 1;
		
		_descriptionView.alpha = 0.70;
		_descriptionView.frame = CGRectMake(0, 0, 249, 50);
		
		_reviewTextArea.alpha = 0;
		_reviewTextAreaBackground.alpha = 0;
		_placeholderLabel.alpha = 0;
		_descriptionText.alpha = 0;
		_descriptionTextSmall.alpha = 1;
		
		[_reviewsButtonSmall setBackgroundImage:[UIImage imageNamed:@"reviews-shorter.png"] forState:UIControlStateNormal];
		_reviewsButtonSmall.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 2, 0);
		_reviewsButtonSmall.frame = CGRectMake(249, 0, 65, 50);
		
		_shareButton.frame = CGRectMake(249, 0, 65, 0);
		_toolsButton.frame = CGRectMake(249, 0, 65, 0);
        _suggestButton.frame = CGRectMake(249, 0, 65, 0);
	}
	
}

- (void)showFullDescription:(BOOL)full {
	_full = full;
	[self layoutSubviews];
}

- (void)textEditorDidChange:(TTTextEditor*)textEditor {
	if ([textEditor.text length] > 0) {
		_placeholderLabel.alpha = 0;
	} else {
		_placeholderLabel.alpha = 1;
	}
}

- (void)loginNotification:(NSNotification*)note {
	[_reviewTextArea becomeFirstResponder];
}

- (BOOL)textEditorShouldReturn:(TTTextEditor*)textEditor {
	[textEditor resignFirstResponder];
	if ([textEditor.text length] == 0) {
		return NO;
	}
	if (![[GTIOUser currentUser] isLoggedIn]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotification:) name:kGTIOUserDidLoginNotificationName object:nil];
		[[GTIOUser currentUser] loginWithFacebook];
	} else {
		TTOpenURL(@"gtio://loading");
		NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
								textEditor.text, @"reviewText", nil];
		params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
		NSString* path = GTIORestResourcePath([NSString stringWithFormat:@"/review/%@", _outfit.outfitID]);
		RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:path delegate:self];
		loader.params = params;
		loader.method = RKRequestMethodPOST;
		[loader send];
		// save review
        // Post the voted notification (even though we only reviewed)
        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOOutfitVoteNotification object:_outfit.outfitID];
	}
	return NO;
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	TTOpenURL(@"gtio://stopLoading");
    GTIOAnalyticsEvent(kReviewSubmitted);
    
	_reviewTextArea.text = @"";
	[(GTIOOutfitPageView*)self.superview showFullDescription:NO];
	
    _outfit.reviewCount = [NSNumber numberWithInt:[_outfit.reviewCount intValue] + 1];
	[_reviewsButtonSmall setTitle:[NSString stringWithFormat:@"%@", _outfit.reviewCountString] forState:UIControlStateNormal];
    
	NSString* url = [NSString stringWithFormat:@"gtio://show_reviews/%@", _outfit.outfitID];
	TTOpenURL(url);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	TTOpenURL(@"gtio://stopLoading");
    GTIOErrorMessage(error);
}


@end
