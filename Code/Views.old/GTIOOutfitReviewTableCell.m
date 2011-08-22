//
//  GTIOOutfitReviewTableCell.m
//  GoTryItOn
//
//  Created by Daniel Hammond on 1/28/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOOutfitReviewTableCell.h"
#import <TWTAlertViewDelegate.h>
#import "GTIOBadge.h"

CGSize kMaxSize = {260,8000};

@implementation GTIOOutfitReviewTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.contentView.backgroundColor = RGBACOLOR(255,255,255,0.3);
        UIImage* areaBgImage = [[UIImage imageNamed:@"comment-area.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
		_areaBgImageView = [[UIImageView alloc] initWithImage:areaBgImage];
		[self.contentView addSubview:_areaBgImageView];        
        
		UIImage* cellBgImage = [[UIImage imageNamed:@"comment-bg.png"] stretchableImageWithLeftCapWidth:152 topCapHeight:39];
		_bgImageView = [[UIImageView alloc] initWithImage:cellBgImage];
		[self.contentView addSubview:_bgImageView];
		
        _reviewTextLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
        _reviewTextLabel.backgroundColor = [UIColor clearColor]; //RGBCOLOR(245,245,245);
        [self.contentView addSubview:_reviewTextLabel];
		
		_authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_authorLabel.font = kGTIOFetteFontOfSize(18);
		_authorLabel.backgroundColor = [UIColor clearColor];
		_authorLabel.textColor = kGTIOColorBrightPink;
		[self.contentView addSubview:_authorLabel];
        _authorButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [self.contentView addSubview:_authorButton];
        [_authorButton addTarget:self action:@selector(authorButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        		
        _authorProfilePictureImageView = [TTImageView new];
        _authorProfilePictureImageView.frame = CGRectZero;
        _authorProfilePictureImageView.urlPath = @"http://assets.gotryiton.com/img/profile-default.png";
        [self.contentView addSubview:_authorProfilePictureImageView];
        
        _authorProfilePictureImageOverlay = [UIImageView new];
        _authorProfilePictureImageOverlay.frame = CGRectZero;
        _authorProfilePictureImageOverlay.image = [UIImage imageNamed:@"review-userpic-overlay.png"];
        [self.contentView addSubview:_authorProfilePictureImageOverlay];        
        
		_agreeVotesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_agreeVotesLabel.font = kGTIOFontBoldHelveticaNeueOfSize(15);
		_agreeVotesLabel.backgroundColor = [UIColor clearColor];
		_agreeVotesLabel.textColor = kGTIOColorBrightPink;
		[self.contentView addSubview:_agreeVotesLabel];
		
		_agreeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[_agreeButton setBackgroundImage:[UIImage imageNamed:@"agree-button.png"] forState:UIControlStateNormal];
		[_agreeButton setBackgroundImage:[UIImage imageNamed:@"agree-button-ON.png"] forState:UIControlStateHighlighted];
        [_agreeButton setBackgroundImage:[UIImage imageNamed:@"agree-button-ON.png"] forState:UIControlStateDisabled];
		_agreeButton.titleLabel.font = kGTIOFontHelveticaNeueOfSize(15);
		[_agreeButton setTitle:@"agree" forState:UIControlStateNormal];
		[_agreeButton setTitleColor:kGTIOColorb1b1b1 forState:UIControlStateNormal];
        [_agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
		[self.contentView addSubview:_agreeButton];
		
		_deleteButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[_deleteButton setBackgroundImage:[UIImage imageNamed:@"agree-button.png"] forState:UIControlStateNormal];
		[_deleteButton setBackgroundImage:[UIImage imageNamed:@"agree-button-ON.png"] forState:UIControlStateHighlighted];
		_deleteButton.titleLabel.font = kGTIOFontHelveticaNeueOfSize(15);
		[_deleteButton setTitle:@"remove" forState:UIControlStateNormal];
		[_deleteButton setTitleColor:kGTIOColorb1b1b1 forState:UIControlStateNormal];
		[self.contentView addSubview:_deleteButton];
		
		_flagButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[_flagButton setBackgroundImage:[UIImage imageNamed:@"report.png"] forState:UIControlStateNormal];
		[_flagButton setBackgroundImage:[UIImage imageNamed:@"report-ON.png"] forState:UIControlStateHighlighted];
		[self.contentView addSubview:_flagButton];
        
        _brandButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        UIImage* image = [UIImage imageNamed:@"review-corner-verified.png"];
		[_brandButton setBackgroundImage:image forState:UIControlStateNormal];
		[self.contentView addSubview:_brandButton];
		
        [_brandButton addTarget:self action:@selector(viewProfile) forControlEvents:UIControlEventTouchUpInside];
		[_flagButton addTarget:self action:@selector(flagButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
		[_agreeButton addTarget:self action:@selector(agreeButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
		[_deleteButton addTarget:self action:@selector(deleteButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	return self;
}

+ (CGSize)sizeForReviewText:(NSString*)text {
    NSScanner* scanner = [NSScanner scannerWithString:text];
    NSString* foundText = nil;
    while (![scanner isAtEnd]) {
        // find start of tag
        [scanner scanUpToString:@"<" intoString:NULL] ; 
        
        // find end of tag
        [scanner scanUpToString:@">" intoString:&foundText] ;
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        text = [text stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", foundText]
                                               withString:@""];
        
    }
//    NSLog(@"Text: %@", text);
    
	return [text sizeWithFont:kGTIOFontHelveticaRBCOfSize(15) constrainedToSize:kMaxSize lineBreakMode:UILineBreakModeWordWrap];
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
	NSString* text = [[object review] text];
    
	CGFloat textHeight = [self sizeForReviewText:text].height;
	return textHeight+50.0+5;
}

- (void)layoutSubviews {
	[super layoutSubviews];
    _brandButton.frame = CGRectMake(self.contentView.width - 50,
                                    7,
                                    44,
                                    44);
    // Background Images
	_bgImageView.frame = CGRectMake(2, 3, self.contentView.size.width - 4, self.contentView.size.height);
    _areaBgImageView.frame = CGRectMake(0, 0, self.contentView.size.width, self.contentView.size.height);
    // Profile Picture
    CGFloat commentBoxShadowLength = 2.5;
    CGFloat commentBoxLeftMargin = 7;
    CGFloat profilePictureMargin = 8;
    _authorProfilePictureImageView.frame = CGRectMake(commentBoxLeftMargin+profilePictureMargin, self.height-25-commentBoxShadowLength-profilePictureMargin, 25, 25);
    CGRect profilePictureFrame = _authorProfilePictureImageView.frame;
    _authorProfilePictureImageOverlay.frame = CGRectMake(profilePictureFrame.origin.x-1, profilePictureFrame.origin.y-1, 27, 27);
    // Review Text
	CGSize textSize = [[self class] sizeForReviewText:[[_reviewTableItem review] text]];
	_reviewTextLabel.frame = CGRectMake(12+2, 12+4, textSize.width, textSize.height);
    
    CGFloat bottomLabelVerticalMargin = 3;
    CGFloat bottomLabelBaselineAdjustment = 8;
    CGFloat bottomLabelHeight = 24;
    CGFloat bottomLabelYOrigin = profilePictureFrame.origin.y+profilePictureFrame.size.height-bottomLabelHeight+bottomLabelBaselineAdjustment-bottomLabelVerticalMargin;
	// Agree Votes Label
    [_agreeVotesLabel sizeToFit];
    CGFloat rightMargin = 10;
    CGFloat rightButtonsLeftmargin = 9;
    CGFloat bottomRightButtonWidth = 59;
    CGFloat bottomRightButtonHeight = 24;
    CGFloat bottomRightButtonVerticalMargin = 6;
    CGFloat bottomRightButtonYOrigin = self.height - bottomRightButtonVerticalMargin - bottomRightButtonHeight;
    CGFloat bottomLabelTextRightBorder = self.contentView.size.width - rightMargin - rightButtonsLeftmargin - bottomRightButtonWidth;

	if ([[_reviewTableItem.review uid] isEqualToString:[[GTIOUser currentUser] UID]]) {
		_agreeButton.frame = CGRectZero;
		_flagButton.frame = CGRectZero;
		_deleteButton.frame = CGRectMake(bottomLabelTextRightBorder+rightButtonsLeftmargin, bottomRightButtonYOrigin, bottomRightButtonWidth, bottomRightButtonHeight);
	} else {
		_agreeButton.frame = CGRectMake(bottomLabelTextRightBorder+rightButtonsLeftmargin, bottomRightButtonYOrigin, bottomRightButtonWidth, bottomRightButtonHeight);
		_flagButton.frame = CGRectMake(self.contentView.frame.size.width-35, 12, 24, 24);
		_deleteButton.frame = CGRectZero;
	}
    CGFloat agreeLabelWidth = _agreeVotesLabel.width;
    CGFloat agreeLabelHeight = 24;
    CGFloat agreeLabelYOrigin = bottomLabelYOrigin;
	_agreeVotesLabel.frame = CGRectMake(3+bottomLabelTextRightBorder-_agreeVotesLabel.width, agreeLabelYOrigin, agreeLabelWidth, agreeLabelHeight);
    // Badges
    CGFloat badgeMargin = 4;
         
    // Author Label
    int maxWidthForAuthorContent = bottomLabelTextRightBorder - _agreeVotesLabel.width;
    int maxWidthForAuthorLabel = maxWidthForAuthorContent - 20 - [_badgeImageViews count]*(26+5);
    
    CGFloat authorLabelHeight = 24;
    CGFloat authorLabelVerticalMargin = 3;
    CGFloat authorLabelBaselineAdjustment = 8;
    CGFloat authorLabelHorizontalMargin = 5;    
    CGSize authorStringSize = [_authorLabel.text sizeWithFont:_authorLabel.font 
                                            constrainedToSize:CGSizeMake(maxWidthForAuthorLabel,authorLabelHeight)
                                                lineBreakMode:_authorLabel.lineBreakMode];
    CGFloat authorLabelYOrigin = profilePictureFrame.origin.y+profilePictureFrame.size.height-authorLabelHeight+authorLabelBaselineAdjustment-authorLabelVerticalMargin;
    CGFloat authorLabelXOrigin = profilePictureFrame.origin.x+profilePictureFrame.size.width+authorLabelHorizontalMargin;
    
    _authorLabel.frame = CGRectMake(authorLabelXOrigin+1, authorLabelYOrigin, authorStringSize.width, authorLabelHeight);
    int xBadgePosition = CGRectGetMaxX(_authorLabel.frame) + 5;
    for (TTImageView* imageView in _badgeImageViews) {
        imageView.frame = CGRectMake(xBadgePosition, _authorLabel.frame.origin.y + badgeMargin, 13,13);
        xBadgePosition += 13+5;
    } 
    
    CGPoint origin = _authorProfilePictureImageOverlay.origin;
    CGFloat height = _authorProfilePictureImageOverlay.bounds.size.height;
    CGFloat width = xBadgePosition - origin.x;
    _authorButton.frame = CGRectMake(origin.x, origin.y, width, height);
    [self addSubview:_authorButton];
}	

- (void)dealloc {
    TT_RELEASE_SAFELY(_brandButton);
	TT_RELEASE_SAFELY(_bgImageView);
	TT_RELEASE_SAFELY(_reviewTableItem);
	TT_RELEASE_SAFELY(_authorLabel);
	TT_RELEASE_SAFELY(_agreeVotesLabel);
	TT_RELEASE_SAFELY(_agreeButton);
	TT_RELEASE_SAFELY(_flagButton);	
	[super dealloc];
}

- (void)setObject:(id)object {
	[_reviewTableItem release];
	_reviewTableItem = [object retain];
	[super setObject:object];
	GTIOReview* review = [_reviewTableItem review];
	_authorLabel.text = [[[review user] displayName] uppercaseString];
    if ([[review user] profileIconURL]) {
        _authorProfilePictureImageView.urlPath = [[review user] profileIconURL];
    }
    NSString* html = [NSString stringWithFormat:@"<span class='reviewTextStyle'>%@</span>", review.text];
    _reviewTextLabel.html = html;
	_agreeVotesLabel.text = [NSString stringWithFormat:@"+%d",[[review agreeVotes] intValue]];
    
    for (TTImageView* imageView in _badgeImageViews) {
        [imageView removeFromSuperview];
    }
    [_badgeImageViews release];
    _badgeImageViews = [NSMutableArray new];
    for (GTIOBadge* badge in review.user.badges) {
        NSString* badgeURL = badge.imgURL;
        TTImageView* imageView = [[[TTImageView alloc] init] autorelease];
        imageView.urlPath = badgeURL;
        
        imageView.backgroundColor = RGBCOLOR(251,251,251);
		[imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [_badgeImageViews addObject:imageView];
        [self.contentView addSubview:imageView];
    }
    
    if ([review.user.isBranded boolValue]) {
        [_flagButton removeFromSuperview];
        [self.contentView addSubview:_brandButton];
    } else {
        [self.contentView addSubview:_flagButton];
        [_brandButton removeFromSuperview];
    }
    
    [self setNeedsLayout];
}

- (void)viewProfile {
    GTIOReview* review = [_reviewTableItem review];
    TTOpenURL([NSString stringWithFormat:@"gtio://profile/%@", review.uid]);
}

- (void)agreeButtonWasPressed:(id)sender {
    GTIOAnalyticsEvent(kReviewAgree);
	_agreeButton.enabled = NO;
	GTIOReview* review = [_reviewTableItem review];
	NSString* path = [NSString stringWithFormat:@"/review/%@/", review.outfitID];
	NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
							_reviewTableItem.review.reviewID, @"reviewId",
							@"true", @"agree",
							nil];
	params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
	[[RKClient sharedClient] post:GTIORestResourcePath(path) params:params delegate:nil];
	_agreeVotesLabel.text = [NSString stringWithFormat:@"+%d",[[review agreeVotes] intValue] + 1];
    [self setNeedsLayout];
}

- (void)flagConfirmed {
    GTIOAnalyticsEvent(kReviewFlag);
	_flagButton.enabled = NO;
	GTIOReview* review = [_reviewTableItem review];
	NSString* path = [NSString stringWithFormat:@"/review/%@/", review.outfitID];
	NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
							_reviewTableItem.review.reviewID, @"reviewId",
							@"true", @"flag",
							nil];
	params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
	[[RKClient sharedClient] post:GTIORestResourcePath(path) params:params delegate:nil];
}

- (void)flagButtonWasPressed:(id)sender {
	TWTAlertViewDelegate* delegate = [[[TWTAlertViewDelegate alloc] init] autorelease];
	[delegate setTarget:self selector:@selector(flagConfirmed) object:nil forButtonIndex:1];
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"GO TRY IT ON" message:@"flag this review as inappropriate?" delegate:delegate cancelButtonTitle:@"cancel" otherButtonTitles:@"flag", nil];
	[alert show];
	[alert release];
}

- (void)deleteConfirmed {
	GTIOReview* review = [_reviewTableItem review];
	NSString* path = [NSString stringWithFormat:@"/review/%@/", review.outfitID];
	NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
							_reviewTableItem.review.reviewID, @"reviewId",
							@"true", @"remove",
							nil];
	params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
	[[RKClient sharedClient] post:GTIORestResourcePath(path) params:params delegate:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ReviewDeletedNotification" object:review];
}

- (void)deleteButtonWasPressed:(id)sender {
	TWTAlertViewDelegate* delegate = [[[TWTAlertViewDelegate alloc] init] autorelease];
	[delegate setTarget:self selector:@selector(deleteConfirmed) object:nil forButtonIndex:1];
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"GO TRY IT ON" message:@"delete this review?" delegate:delegate cancelButtonTitle:@"cancel" otherButtonTitles:@"delete", nil];
	[alert show];
	[alert release];
}

- (void)authorButtonWasPressed:(id)sender {
    NSString* url = [NSString stringWithFormat:@"gtio://profile/%@", _reviewTableItem.review.uid];
    TTOpenURL(url);
}

@end
