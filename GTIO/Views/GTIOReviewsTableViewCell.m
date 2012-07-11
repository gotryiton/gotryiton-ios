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

static const double cellPaddingLeftRight = 12.0;
static const double cellPaddingTop = 12.0;
static const double cellPaddingBottom = 15.0;
static const double avatarWidthHeight = 27.0;
static const double cellWidth = 314.0;
static const double reviewTextWidth = 250.0;

typedef enum GTIOReviewsAlertView {
    GTIOReviewsAlertViewFlag = 0,
    GTIOReviewsAlertViewRemove,
} GTIOReviewsAlertView;

@interface GTIOReviewsTableViewCell()

@property (nonatomic, strong) UIImageView *background;

@property (nonatomic, strong) GTIOSelectableProfilePicture *userProfilePicture;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *postedAtLabel;

@property (nonatomic, strong) DTAttributedTextView *reviewTextView;
@property (nonatomic, strong) NSDictionary *reviewAttributeTextOptions;

@property (nonatomic, strong) UILabel *heartCountLabel;
@property (nonatomic, strong) GTIOUIButton *heartButton;

@property (nonatomic, strong) GTIOUIButton *flagButton;
@property (nonatomic, strong) GTIOButton *currentFlagButtonModel;

@property (nonatomic, strong) GTIOUIButton *removeButton;
@property (nonatomic, strong) GTIOButton *currentRemoveButtonModel;

@end

@implementation GTIOReviewsTableViewCell

@synthesize background = _background, userProfilePicture = _userProfilePicture, userNameLabel = _userNameLabel, postedAtLabel = _postedAtLabel, heartCountLabel = _heartCountLabel, heartButton = _heartButton, review = _review, reviewTextView = _reviewTextView, reviewAttributeTextOptions = _reviewAttributeTextOptions, indexPath = _indexPath, delegate = _delegate, flagButton = _flagButton, currentFlagButtonModel = _currentFlagButtonModel, removeButton = _removeButton, currentRemoveButtonModel = _currentRemoveButtonModel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _background = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"reviews.cell.bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 5.0, 7.0, 5.0)]];
        _background.opaque = YES;
        self.backgroundView = _background;
        
        _userProfilePicture = [[GTIOSelectableProfilePicture alloc] initWithFrame:CGRectZero andImageURL:nil];
        [self.contentView addSubview:_userProfilePicture];
        
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
        
        _heartCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _heartCountLabel.textColor = [UIColor gtio_grayTextColorDCDCDC];
        _heartCountLabel.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0];
        _heartCountLabel.backgroundColor = [UIColor clearColor];
        _heartCountLabel.hidden = YES;
        [self addSubview:_heartCountLabel];
        
        _heartButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeHeart tapHandler:nil];
        _heartButton.hidden = YES;
        [self addSubview:_heartButton];
        
        _flagButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeFlag tapHandler:nil];
        _flagButton.hidden = YES;
        [self addSubview:_flagButton];
        
        _removeButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeRemove tapHandler:nil];
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
                                            [NSNumber numberWithFloat:1.2], DTDefaultLineHeightMultiplier,
                                            [UIColor gtio_darkGray3TextColor], DTDefaultTextColor,
                                            [UIColor gtio_pinkTextColor], DTDefaultLinkColor,
                                            [NSNumber numberWithBool:NO], DTDefaultLinkDecoration,
                                            defaultDTCSSStylesheet, DTDefaultStyleSheet,
                                            nil];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)layoutSubviews
{
    double const defaultPadding = 5.0;
    double const defaultLabelHeight = 15.0;
    double const backgroundLeftMargin = 3.0;
    double const heartButtonVerticalOffset = 6.0;
    double const postedAtLabelVerticalOffset = 2.0;
    
    [self.background setFrame:(CGRect){ backgroundLeftMargin, 0, cellWidth, self.bounds.size.height - defaultPadding }];
    CGSize reviewTextSize = [self.reviewTextView.contentView sizeThatFits:(CGSize){ reviewTextWidth, CGFLOAT_MAX }];
    [self.reviewTextView setFrame:(CGRect){ self.background.frame.origin.x + cellPaddingLeftRight, self.background.frame.origin.y + cellPaddingTop, reviewTextWidth, reviewTextSize.height }];
    [self.userProfilePicture setFrame:(CGRect){ self.background.frame.origin.x + cellPaddingLeftRight, self.background.frame.origin.y + self.background.bounds.size.height - avatarWidthHeight - cellPaddingBottom, avatarWidthHeight, avatarWidthHeight }];
    [self.heartButton setFrame:(CGRect){ self.background.frame.origin.x + self.background.bounds.size.width - cellPaddingLeftRight - self.heartButton.bounds.size.width, self.userNameLabel.frame.origin.y + heartButtonVerticalOffset, self.heartButton.bounds.size }];
    [self.heartCountLabel sizeToFit];
    [self.heartCountLabel setFrame:(CGRect){ self.background.frame.origin.x + self.background.bounds.size.width - cellPaddingLeftRight - self.heartCountLabel.bounds.size.width - self.heartButton.bounds.size.width - defaultPadding, self.postedAtLabel.frame.origin.y - 3, self.heartCountLabel.bounds.size }];
    [self.flagButton setFrame:(CGRect){ self.heartButton.frame.origin.x + backgroundLeftMargin, self.background.frame.origin.y + cellPaddingTop, self.heartButton.bounds.size.width, self.flagButton.bounds.size.height }];
    [self.removeButton setFrame:(CGRect){ self.heartButton.frame.origin.x + defaultPadding + 1, self.flagButton.frame.origin.y, self.removeButton.bounds.size }];
    [self.userNameLabel setFrame:(CGRect){ self.userProfilePicture.frame.origin.x + self.userProfilePicture.bounds.size.width + defaultPadding, self.userProfilePicture.frame.origin.y, self.background.bounds.size.width - cellPaddingLeftRight * 2 - defaultPadding - self.userProfilePicture.bounds.size.width - self.heartButton.bounds.size.width - self.heartCountLabel.bounds.size.width - (self.heartButton.frame.origin.x - (self.heartCountLabel.frame.origin.x + self.heartCountLabel.bounds.size.width)) - ((self.heartCountLabel.text.length > 0) ? defaultPadding : 0), defaultLabelHeight }];
    [self.postedAtLabel setFrame:(CGRect){ self.userNameLabel.frame.origin.x, self.userNameLabel.frame.origin.y + self.userNameLabel.bounds.size.height - postedAtLabelVerticalOffset, self.userNameLabel.bounds.size.width, defaultLabelHeight }];
}

- (void)setReview:(GTIOReview *)review
{
    _review = review;
    
    NSData *data = [_review.text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:self.reviewAttributeTextOptions documentAttributes:NULL];
    self.reviewTextView.attributedString = string;
    
    self.userNameLabel.text = _review.user.name;
    self.postedAtLabel.text = _review.createdWhen;
    [self.userProfilePicture setImageWithURL:_review.user.icon];
    [self.userProfilePicture setHasInnerShadow:YES];
    for (id object in _review.buttons) {
        if ([object isMemberOfClass:[GTIOButton class]]) {
            GTIOButton *button = (GTIOButton *)object;
            __block typeof(self) blockSelf = self;
            if ([button.name isEqualToString:kGTIOReviewFlagButton]) {
                self.currentFlagButtonModel = button;
                self.flagButton.hidden = NO;
                self.flagButton.selected = button.state.boolValue;
                self.flagButton.tapHandler = ^(id sender) {
                    if (button.action.endpoint.length > 0) {                    
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Flag this review as inappropriate?" delegate:blockSelf cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
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
                self.heartButton.tapHandler = ^(id sender) {
                    GTIOUIButton *uibutton = (GTIOUIButton *)sender;
                    uibutton.selected = !uibutton.selected;
                    
                    [GTIOProgressHUD showHUDAddedTo:[blockSelf.delegate viewForSpinner] animated:YES];
                    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:button.action.endpoint usingBlock:^(RKObjectLoader *loader) {
                        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
                            [GTIOProgressHUD hideHUDForView:[blockSelf.delegate viewForSpinner] animated:YES];
                            [blockSelf updateReviewFromLoadedObjects:loadedObjects];
                        };
                        loader.onDidFailWithError = ^(NSError *error) {
                            [GTIOProgressHUD hideHUDForView:[blockSelf.delegate viewForSpinner] animated:YES];
                            NSLog(@"%@", [error localizedDescription]);
                        };
                    }];
                };
            }
            if ([button.name isEqualToString:kGTIOReviewRemoveButton]) {
                self.flagButton.hidden = YES;
                self.removeButton.hidden = NO;
                self.currentRemoveButtonModel = button;
                self.removeButton.tapHandler = ^(id sender) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Delete this review?" delegate:blockSelf cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                    alertView.tag = GTIOReviewsAlertViewRemove;
                    [alertView show];
                };
            }
        }
    }
}

- (void)updateReviewFromLoadedObjects:(NSArray *)loadedObjects
{
    for (id object in loadedObjects) {
        if ([object isMemberOfClass:[GTIOReview class]]) {
            self.review = (GTIOReview *)object;
            [self setNeedsLayout];
            
            if ([self.delegate respondsToSelector:@selector(updateDataSourceWithReview:atIndexPath:)]) {
                [self.delegate updateDataSourceWithReview:self.review atIndexPath:self.indexPath];
            }
        }
    }
}

+ (CGFloat)heightWithReview:(GTIOReview *)review
{
    [DTAttributedTextContentView setLayerClass:[CATiledLayer class]];
    DTAttributedTextView *reviewAttributedTextView = [[DTAttributedTextView alloc] initWithFrame:(CGRect){ CGPointZero, { reviewTextWidth, 0 } }];
    reviewAttributedTextView.contentView.edgeInsets = (UIEdgeInsets) { -4, 0, 8, 0 };
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PostDescription" ofType:@"css"];  
    NSData *cssData = [NSData dataWithContentsOfFile:filePath];
    NSString *cssString = [[NSString alloc] initWithData:cssData encoding:NSUTF8StringEncoding];
    DTCSSStylesheet *stylesheet = [[DTCSSStylesheet alloc] initWithStyleBlock:cssString];
    
    NSDictionary *reviewAttributedTextOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSNumber numberWithFloat:1.2], DTDefaultLineHeightMultiplier,
                                                      [NSNumber numberWithBool:NO], DTDefaultLinkDecoration,
                                                      stylesheet, DTDefaultStyleSheet,
                                                      nil];
    
    NSData *data = [review.text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:reviewAttributedTextOptions documentAttributes:NULL];
    reviewAttributedTextView.attributedString = string;
    
    CGSize reviewTextSize = [reviewAttributedTextView.contentView sizeThatFits:(CGSize){ cellWidth, CGFLOAT_MAX }];
    
    return cellPaddingTop + reviewTextSize.height + avatarWidthHeight + cellPaddingBottom;
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
            
            [GTIOProgressHUD showHUDAddedTo:[self.delegate viewForSpinner] animated:YES];
            [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.currentFlagButtonModel.action.endpoint usingBlock:^(RKObjectLoader *loader) {
                loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
                    [GTIOProgressHUD hideHUDForView:[self.delegate viewForSpinner] animated:YES];
                    [self updateReviewFromLoadedObjects:loadedObjects];
                };
                loader.onDidFailWithError = ^(NSError *error) {
                    [GTIOProgressHUD hideHUDForView:[self.delegate viewForSpinner] animated:YES];
                    NSLog(@"%@", [error localizedDescription]);
                };
            }];
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
                            if ([self.delegate respondsToSelector:@selector(removeReviewAtIndexPath:)]) {
                                [self.delegate removeReviewAtIndexPath:self.indexPath];
                                self.removeButton.hidden = YES;
                                self.flagButton.hidden = NO;
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

@end
