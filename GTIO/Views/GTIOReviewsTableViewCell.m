//
//  GTIOReviewsTableViewCell.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/9/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOReviewsTableViewCell.h"
#import "GTIOSelectableProfilePicture.h"
#import "GTIOUser.h"
#import "GTIOProgressHUD.h"
#import "UIImageView+WebCache.h"

static CGFloat const kGTIOCellPaddingLeftRight = 12.0;
static CGFloat const kGTIOCellPaddingTop = 12.0;
static CGFloat const kGTIOCellPaddingBottom = 15.0;
static CGFloat const kGTIOAvatarWidthHeight = 27.0;
static CGFloat const kGTIOCellWidth = 314.0;
static CGFloat const kGTIOReviewTextWidth = 250.0;
static CGFloat const kGTIODefaultPadding = 5.0;
static CGFloat const kGTIONameAndTimeVerticalPadding = 1.0;
static CGFloat const kGTIONameAndTimeHorizontalPadding = 7.0;
static CGFloat const kGTIODefaultLabelHeight = 15.0;
static CGFloat const kGTIOBackgroundLeftMargin = 3.0;
static CGFloat const kGTIOHeartButtonVerticalOffset = 8.0;
static CGFloat const kGTIOPostedAtLabelVerticalOffset = 2.0;
static CGFloat const kGTIOUserBadgeVerticalOffset = 2.0;
static CGFloat const kGTIOUserBadgeHorizontalOffset = 2.0;
static CGFloat const kGTIOCellHeartRightPadding = 11.0;
static CGFloat const kGTIOCellFlagRightPadding = 7.0;
static CGFloat const kGTIOCellDeleteRightPadding = 9.0;
static CGFloat const kGTIOCellButtonPadding = 6.0;

typedef enum GTIOReviewsAlertView {
    GTIOReviewsAlertViewFlag = 0,
    GTIOReviewsAlertViewRemove,
} GTIOReviewsAlertView;

@interface GTIOReviewsTableViewCell()

@property (nonatomic, strong) UIImageView *background;

@property (nonatomic, strong) GTIOSelectableProfilePicture *userProfilePicture;
@property (nonatomic, strong) UIImageView *userProfilePictureOverlay;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *postedAtLabel;
@property (nonatomic, strong) UIImageView *badge;

@property (nonatomic, strong) DTAttributedTextView *reviewTextView;
@property (nonatomic, strong) NSDictionary *reviewAttributeTextOptions;

@property (nonatomic, strong) UILabel *heartCountLabel;
@property (nonatomic, strong) GTIOUIButton *heartButton;

@property (nonatomic, strong) GTIOUIButton *flagButton;
@property (nonatomic, strong) GTIOButton *currentFlagButtonModel;

@property (nonatomic, strong) GTIOUIButton *removeButton;
@property (nonatomic, strong) GTIOButton *currentRemoveButtonModel;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation GTIOReviewsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _background = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"reviews.cell.bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 5.0, 7.0, 5.0)]];
        _background.opaque = YES;
        self.backgroundView = _background;
        
        _userProfilePicture = [[GTIOSelectableProfilePicture alloc] initWithFrame:CGRectZero andImageURL:nil];
        _userProfilePicture.isSelectable = NO;
        _userProfilePicture.hasInnerShadow = NO;
        _userProfilePicture.hasOuterShadow = NO;
        [self.contentView addSubview:_userProfilePicture];
        
        _userProfilePictureOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reviews.cell.avatar.overlay.png"]];
        [self.contentView addSubview:_userProfilePictureOverlay];

        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _userNameLabel.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:11.0];
        _userNameLabel.textColor = [UIColor gtio_pinkTextColor];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_userNameLabel];
        
        _postedAtLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _postedAtLabel.textColor = [UIColor gtio_grayTextColorBCBCBC];
        _postedAtLabel.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:8.0];
        _postedAtLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_postedAtLabel];
        
        _badge = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_badge];

        _heartCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _heartCountLabel.textColor = [UIColor gtio_grayTextColorDCDCDC];
        _heartCountLabel.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0];
        _heartCountLabel.backgroundColor = [UIColor clearColor];
        _heartCountLabel.hidden = YES;
        _heartCountLabel.textAlignment = UITextAlignmentRight;
        [self addSubview:_heartCountLabel];
        
        _heartButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeHeart tapHandler:nil];
        _heartButton.hidden = YES;
        [_heartButton setTapAreaPadding:kGTIOCellButtonPadding];
        [self addSubview:_heartButton];
        
        _flagButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeFlag tapHandler:nil];
        [_flagButton setTapAreaPadding:kGTIOCellButtonPadding];
        _flagButton.hidden = YES;
        [self addSubview:_flagButton];
        
        _removeButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeRemove tapHandler:nil];
        [_removeButton setTapAreaPadding:kGTIOCellButtonPadding];
        _removeButton.hidden = YES;
        [self addSubview:_removeButton];
        
        [DTAttributedTextContentView setLayerClass:[CATiledLayer class]];
        _reviewTextView = [[DTAttributedTextView alloc] initWithFrame:CGRectZero];
        _reviewTextView.textDelegate = self;
        _reviewTextView.contentView.edgeInsets = (UIEdgeInsets) { -8, 0, 0, 0 };
        [_reviewTextView setScrollEnabled:NO];
        [_reviewTextView setScrollsToTop:NO];
        [_reviewTextView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_reviewTextView];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ReviewText" ofType:@"css"];  
        NSData *cssData = [NSData dataWithContentsOfFile:filePath];
        NSString *cssString = [[NSString alloc] initWithData:cssData encoding:NSUTF8StringEncoding];
        DTCSSStylesheet *defaultDTCSSStylesheet = [[DTCSSStylesheet alloc] initWithStyleBlock:cssString];
        
        _reviewAttributeTextOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIColor gtio_grayTextColor232323], DTDefaultTextColor,
                                            [NSNumber numberWithFloat:1.2], DTDefaultLineHeightMultiplier,
                                            [UIColor gtio_pinkTextColor], DTDefaultLinkColor,
                                            [NSNumber numberWithBool:NO], DTDefaultLinkDecoration,
                                            defaultDTCSSStylesheet, DTDefaultStyleSheet,
                                            nil];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [self addGestureRecognizer:_tapGestureRecognizer];
        _tapGestureRecognizer.delegate = self;

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.background setFrame:(CGRect){ kGTIOBackgroundLeftMargin, 0, kGTIOCellWidth, self.bounds.size.height - kGTIODefaultPadding }];
    CGSize reviewTextSize = [self.reviewTextView.contentView sizeThatFits:(CGSize){ kGTIOReviewTextWidth, CGFLOAT_MAX }];
    [self.reviewTextView setFrame:(CGRect){ self.background.frame.origin.x + kGTIOCellPaddingLeftRight, self.background.frame.origin.y + kGTIOCellPaddingTop, kGTIOReviewTextWidth, reviewTextSize.height }];
    [self.userProfilePicture setFrame:(CGRect){ self.background.frame.origin.x + kGTIOCellPaddingLeftRight, self.background.frame.origin.y + self.background.bounds.size.height - kGTIOAvatarWidthHeight - kGTIOCellPaddingBottom + 1, kGTIOAvatarWidthHeight, kGTIOAvatarWidthHeight }];
    [self.userProfilePictureOverlay setFrame:(CGRect){ self.background.frame.origin.x + kGTIOCellPaddingLeftRight, self.background.frame.origin.y + self.background.bounds.size.height - kGTIOAvatarWidthHeight - kGTIOCellPaddingBottom + 1, kGTIOAvatarWidthHeight, kGTIOAvatarWidthHeight }];
    [self.heartButton setFrame:(CGRect){ self.background.frame.origin.x + self.background.bounds.size.width - kGTIOCellHeartRightPadding - self.heartButton.bounds.size.width, self.userNameLabel.frame.origin.y + kGTIOHeartButtonVerticalOffset, self.heartButton.bounds.size }];
    [self.heartCountLabel setFrame:(CGRect){ self.background.frame.origin.x + self.background.bounds.size.width - kGTIOCellPaddingLeftRight - self.heartCountLabel.bounds.size.width - self.heartButton.bounds.size.width - kGTIODefaultPadding, self.postedAtLabel.frame.origin.y - 3, 30, 18 }];
    [self.flagButton setFrame:(CGRect){ self.heartButton.frame.origin.x + kGTIOCellFlagRightPadding, self.background.frame.origin.y + kGTIOCellPaddingTop, self.heartButton.bounds.size.width, self.flagButton.bounds.size.height }];
    [self.removeButton setFrame:(CGRect){ self.heartButton.frame.origin.x + kGTIOCellDeleteRightPadding, self.flagButton.frame.origin.y, self.removeButton.bounds.size }];
    [self.userNameLabel setFrame:(CGRect){ self.userProfilePicture.frame.origin.x + self.userProfilePicture.bounds.size.width + kGTIONameAndTimeHorizontalPadding, self.userProfilePicture.frame.origin.y + kGTIONameAndTimeVerticalPadding, self.background.bounds.size.width - kGTIOCellPaddingLeftRight * 2  - self.userProfilePicture.bounds.size.width - self.heartButton.bounds.size.width - self.heartCountLabel.bounds.size.width - (self.heartButton.frame.origin.x - (self.heartCountLabel.frame.origin.x + self.heartCountLabel.bounds.size.width)) - ((self.heartCountLabel.text.length > 0) ? kGTIODefaultPadding : 0), kGTIODefaultLabelHeight }];
    [self.postedAtLabel setFrame:(CGRect){ self.userNameLabel.frame.origin.x, self.userNameLabel.frame.origin.y + self.userNameLabel.bounds.size.height - kGTIOPostedAtLabelVerticalOffset, self.userNameLabel.bounds.size.width, kGTIODefaultLabelHeight }];

    self.heartButton.enabled = YES;
    self.flagButton.enabled = YES;
    self.removeButton.enabled = YES;

    if (self.review.user.badge){
        [self.badge setImageWithURL:[self.review.user.badge badgeImageURLForCommenter]];
        [self.badge setFrame:(CGRect){ self.userNameLabel.frame.origin.x + [self nameLabelSize].width + kGTIOUserBadgeHorizontalOffset, self.userNameLabel.frame.origin.y + kGTIOUserBadgeVerticalOffset, [self.review.user.badge badgeImageSizeForCommenter]}];
        
    } else {
        [self.badge setFrame:CGRectZero];
    }
}

- (GTIOButton *)buttonWithName:(NSString *)buttonName 
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", buttonName];
    NSArray *results = [self.review.buttons filteredArrayUsingPredicate:predicate];
    if (results.count>0)
        return [results objectAtIndex:0];
    return nil;
}

- (void)setReview:(GTIOReview *)review
{
    _review = review;
   
    NSData *data = [_review.text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:self.reviewAttributeTextOptions documentAttributes:NULL];
    self.reviewTextView.attributedString = string;
    
    self.userNameLabel.text = _review.user.name;
    self.postedAtLabel.text = [_review.createdWhen uppercaseString];
    [self.userProfilePicture setImageWithURL:_review.user.icon];
    [self.userProfilePicture setHasInnerShadow:YES];
    for (id object in _review.buttons) {
        if ([object isMemberOfClass:[GTIOButton class]]) {
            GTIOButton *button = (GTIOButton *)object;
            __block typeof(self) blockSelf = self;
            if ([button.name isEqualToString:kGTIOReviewFlagButton]) {
                self.currentFlagButtonModel = button;
                self.flagButton.hidden = NO;
                self.removeButton.hidden = YES;
                self.flagButton.selected = button.state.boolValue;
                self.flagButton.tapHandler = ^(id sender) {
                    if (button.action.endpoint.length > 0) {                    
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Flag this comment as inappropriate?" delegate:blockSelf cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                        alertView.tag = GTIOReviewsAlertViewFlag;
                        [alertView show];
                    }
                };
            }
            if ([button.name isEqualToString:kGTIOReviewAgreeButton]) {
                self.heartCountLabel.hidden = NO;
                self.heartButton.hidden = NO;
                if (button.count.intValue > 0) {
                    self.heartCountLabel.text = [NSString stringWithFormat:@"+%i", button.count.intValue];
                } else {
                    self.heartCountLabel.text = @"";
                }
                self.heartButton.selected = button.state.boolValue;
                __block typeof(self) blockSelf = self;
                self.heartButton.tapHandler = ^(id sender) {
                    if ([blockSelf.delegate respondsToSelector:@selector(reviewButtonTap:reviewID:)]) {
                        [blockSelf.delegate reviewButtonTap:button reviewID:self.review.reviewID];
                    }
                    self.heartButton.enabled = NO;
                    [blockSelf updateHeart];
                };
            }
            if ([button.name isEqualToString:kGTIOReviewRemoveButton]) {
                self.flagButton.hidden = YES;
                self.removeButton.hidden = NO;
                self.currentRemoveButtonModel = button;
                self.removeButton.tapHandler = ^(id sender) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Delete this comment?" delegate:blockSelf cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                    alertView.tag = GTIOReviewsAlertViewRemove;
                    [alertView show];
                };
            }
        }
    }

    if (_review.user.badge) {
        [self.badge setImageWithURL:[_review.user.badge badgeImageURLForCommenter]];
    }
}

- (void)updateHeart
{
    self.heartButton.selected = !self.heartButton.selected;
    self.review.hearted = !self.review.hearted;
    self.review.heartCount = (self.review.hearted) ? self.review.heartCount + 1 : self.review.heartCount - 1;
    if (self.review.heartCount > 0) {
        self.heartCountLabel.text = [NSString stringWithFormat:@"+%i", self.review.heartCount];
    } else {
        self.heartCountLabel.text = @"";
    }
}

+ (CGFloat)heightWithReview:(GTIOReview *)review
{
    [DTAttributedTextContentView setLayerClass:[CATiledLayer class]];
    DTAttributedTextView *reviewAttributedTextView = [[DTAttributedTextView alloc] initWithFrame:(CGRect){ CGPointZero, { kGTIOReviewTextWidth, 0 } }];
    reviewAttributedTextView.contentView.edgeInsets = (UIEdgeInsets) { -8, 0, 8, 0 };
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ReviewText" ofType:@"css"];  
    NSData *cssData = [NSData dataWithContentsOfFile:filePath];
    NSString *cssString = [[NSString alloc] initWithData:cssData encoding:NSUTF8StringEncoding];
    DTCSSStylesheet *stylesheet = [[DTCSSStylesheet alloc] initWithStyleBlock:cssString];
    
    NSDictionary *reviewAttributedTextOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSNumber numberWithBool:NO], DTDefaultLinkDecoration,
                                                      [NSNumber numberWithFloat:1.2], DTDefaultLineHeightMultiplier,
                                                      stylesheet, DTDefaultStyleSheet,
                                                      nil];
    
    NSData *data = [review.text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:reviewAttributedTextOptions documentAttributes:NULL];
    reviewAttributedTextView.attributedString = string;
    
    CGSize reviewTextSize = [reviewAttributedTextView.contentView sizeThatFits:(CGSize){ kGTIOCellWidth, CGFLOAT_MAX }];
    
    return kGTIOCellPaddingTop + reviewTextSize.height + kGTIOAvatarWidthHeight + kGTIOCellPaddingBottom;
}

- (void)dealloc
{
    _delegate = nil;
}

#pragma mark Custom Views on Text

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForLink:(NSURL *)url identifier:(NSString *)identifier frame:(CGRect)frame
{
	DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
	button.URL = url;
	button.minimumHitSize = CGSizeMake(20, 20); // adjusts it's bounds so that button is always large enough
	button.GUID = identifier;
	[button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
	return button;
}

#pragma mark Actions

- (void)linkPushed:(DTLinkButton *)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOPostFeedOpenLinkNotification object:nil userInfo:[NSDictionary dictionaryWithObject:button.URL forKey:kGTIOURL]];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == GTIOReviewsAlertViewFlag) {
        if (buttonIndex == 1) {
            self.flagButton.selected = !self.flagButton.selected;
            self.flagButton.enabled = NO;
            self.review.flagged = !self.review.flagged;

            if ([self.delegate respondsToSelector:@selector(reviewButtonTap:reviewID:)]) {
                [self.delegate reviewButtonTap:[self buttonWithName:kGTIOReviewFlagButton] reviewID:self.review.reviewID];
            }
        }
    }
    if (alertView.tag == GTIOReviewsAlertViewRemove) {
        if (buttonIndex == 1) {
            [GTIOProgressHUD showHUDAddedTo:[self.delegate viewForSpinner] animated:YES];
            [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.currentRemoveButtonModel.action.endpoint usingBlock:^(RKObjectLoader *loader) {
                loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
                    [GTIOProgressHUD hideHUDForView:[self.delegate viewForSpinner] animated:YES];
                    for (id object in loadedObjects) {
                        if ([object isMemberOfClass:[GTIOReview class]]) {
                            if ([self.delegate respondsToSelector:@selector(removeReview:)]) {
                                [self.delegate removeReview:self.review];
                            }
                        }
                    }
                };
                loader.onDidFailWithError = ^(NSError *error) {
                    [GTIOProgressHUD hideHUDForView:[self.delegate viewForSpinner] animated:YES];
                    NSLog(@"%@", [error localizedDescription]);
                };
            }];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (CGRectContainsPoint(self.userNameLabel.frame, [touch locationInView:self]) || CGRectContainsPoint(self.postedAtLabel.frame, [touch locationInView:self]) || CGRectContainsPoint(self.userProfilePicture.frame, [touch locationInView:self])) {
        return YES;
    }
    return NO;

}

- (void)didTap:(UIGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(goToProfileOfUserID:)]) {
        [self.delegate goToProfileOfUserID:self.review.user.userID];
    }
}

-(CGSize)nameLabelSize
{
    return [self.review.user.name sizeWithFont:self.userNameLabel.font forWidth:400.0f lineBreakMode:UILineBreakModeTailTruncation];
}

@end
