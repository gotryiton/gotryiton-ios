//
//  GTIOPostFrameView.m
//  GTIO
//
//  Created by Scott Penrose on 6/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostFrameView.h"

#import "DTCoreText.h"
#import "UIImageView+WebCache.h"

#import "GTIOPhoto.h"
#import "GTIOButton.h"

#import "GTIORouter.h"

#import "GTIOHeartButton.h"
#import "GTIOPostBrandButtonsView.h"

#import "GTIOFullScreenImageViewer.h"

#import "GTIOViewController.h"

static CGFloat const kGTIOFrameWidth = 270.0f;
static CGFloat const kGTIOFrameHeightPadding = 16.0f;
static CGFloat const kGTIOFrameHeightWithShadowPadding = 22.0f;
static CGFloat const kGTIOPhotoTopPadding = 7.0f;
static CGFloat const kGTIOPhotoLeftRightPadding = 10.0f;
static CGFloat const kGTIOHeartButtonPadding = 0.0f;
static CGFloat const kGTIODescriptionTextWidth = 240.0f;
static CGFloat const kGTIODescriptionLabelTopPadding = 5.0f;
static CGFloat const kGTIOShopThisLookButtonTopPadding = 6.0f;
static CGFloat const kGTIOShopThisLookButtonTopPaddingNoDescription = 11.0f;
static CGFloat const kGTIOShopThisLookButtonBottomPadding = 4.0f;
static CGFloat const kGTIOShopThisLookButtonHeight = 26.0f;
static CGFloat const kGTIOShopThisLookButtonRightPadding = -5.0f;


@interface GTIOPostFrameView ()  <DTAttributedTextContentViewDelegate>

@property (nonatomic, strong) UIImageView *frameImageView;
@property (nonatomic, strong) UIImageView *star;
@property (nonatomic, strong) DTAttributedTextView *descriptionTextView;
@property (nonatomic, strong) NSDictionary *descriptionAttributeTextOptions;
@property (nonatomic, strong) GTIOHeartButton *heartButton;
@property (nonatomic, strong) GTIOButton *photoHeartButtonModel;
@property (nonatomic, strong) UITapGestureRecognizer *photoTapRecognizer;
@property (nonatomic, strong) GTIOFullScreenImageViewer *fullScreenImageViewer;
@property (nonatomic, strong) GTIOUIButton *shopThisLookButton;
@property (nonatomic, strong) NSString *shopThisLookDestination;

@end

@implementation GTIOPostFrameView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:(CGRect){ frame.origin, { kGTIOFrameWidth, 1 } }];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIImage *frameImage = [[UIImage imageNamed:@"photo-bg.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 10, 0, 12, kGTIOFrameWidth }];
        _frameImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_frameImageView setImage:frameImage];
        [self addSubview:_frameImageView];
        
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_photoImageView];
        
        self.photoTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFullScreenImage)];
        [_photoImageView addGestureRecognizer:self.photoTapRecognizer];
        _photoImageView.userInteractionEnabled = YES;

        _heartButton = [GTIOHeartButton heartButtonWithTapHandler:^(id sender) {
            [self.heartButton setHearted:![self.heartButton isHearted]];
            
            [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.photoHeartButtonModel.action.endpoint delegate:nil];
        }];
        [self addSubview:_heartButton];
        
        [DTAttributedTextContentView setLayerClass:[CATiledLayer class]];
        _descriptionTextView = [[DTAttributedTextView alloc] initWithFrame:CGRectZero];
        _descriptionTextView.textDelegate = self;
        _descriptionTextView.contentView.edgeInsets = (UIEdgeInsets) { -2, 0, 0, 0 };
        [_descriptionTextView setScrollEnabled:NO];
        [_descriptionTextView setScrollsToTop:NO];
        [_descriptionTextView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_descriptionTextView];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PostDescription" ofType:@"css"];  
        NSData *cssData = [NSData dataWithContentsOfFile:filePath];
        NSString *cssString = [[NSString alloc] initWithData:cssData encoding:NSUTF8StringEncoding];
        DTCSSStylesheet *defaultDTCSSStylesheet = [[DTCSSStylesheet alloc] initWithStyleBlock:cssString];
        
        _descriptionAttributeTextOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIColor gtio_grayTextColor232323], DTDefaultTextColor,
                                            [NSNumber numberWithFloat:1.2], DTDefaultLineHeightMultiplier,
                                            [UIColor gtio_pinkTextColor], DTDefaultLinkColor,
                                            [NSNumber numberWithBool:NO], DTDefaultLinkDecoration,
                                            defaultDTCSSStylesheet, DTDefaultStyleSheet,
                                            nil];
        

        _shopThisLookButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeFeedShopThisLook tapHandler:nil];
        [self addSubview:_shopThisLookButton];

        _star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star-corner-feed.png"]];
        _star.hidden = YES;
        [self addSubview:_star];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat extraHeight = 0.0f; // This height is used for placing view frames
    CGFloat extraParentFrameHeight = 0.0f; // This height is used for making container frame bigger

    CGSize photoSize = [GTIOPostFrameView scalePhotoSize:self.post.photo.photoSize];

    if (self.post.photo.isStarred){
        [self.star setFrame:(CGRect){photoSize.width - self.star.bounds.size.width + kGTIOPhotoLeftRightPadding, kGTIOPhotoTopPadding , self.star.frame.size}];
        self.star.hidden = NO;
    } else {
        self.star.hidden = YES;
    }

    [self.photoImageView setFrame:(CGRect){ 10, kGTIOPhotoTopPadding, photoSize }];
    [self.heartButton setFrame:(CGRect){ { self.photoImageView.frame.origin.x + kGTIOHeartButtonPadding, self.photoImageView.frame.origin.y + kGTIOHeartButtonPadding }, self.heartButton.frame.size }];
    
    CGSize descriptionTextSize = [self.descriptionTextView.contentView sizeThatFits:(CGSize){ kGTIODescriptionTextWidth, CGFLOAT_MAX }];
    if (descriptionTextSize.height > 0) {
        [self.descriptionTextView setFrame:(CGRect){ self.photoImageView.frame.origin.x + 5, self.photoImageView.frame.origin.y + self.photoImageView.frame.size.height + kGTIODescriptionLabelTopPadding, kGTIODescriptionTextWidth, descriptionTextSize.height}];
    } else {
        // Set description label to bottom of photo view to be able to use for height of frame
        [self.descriptionTextView setFrame:(CGRect){ self.photoImageView.frame.origin.x + 5, self.photoImageView.frame.origin.y + self.photoImageView.frame.size.height, kGTIODescriptionTextWidth, descriptionTextSize.height}];
    }

    CGFloat shopThisLookButtonHeight = 0.0;

    for (GTIOButton *button in self.post.buttons) {
        if ([button.name isEqualToString:kGTIOPostSideShopButton]) {
            
            if (descriptionTextSize.height > 0) {
                extraHeight += kGTIOShopThisLookButtonTopPadding;
            } else {
                extraHeight += kGTIOShopThisLookButtonTopPaddingNoDescription;
            }
            shopThisLookButtonHeight = kGTIOShopThisLookButtonHeight;

            __block id tapDelegate = self.delegate;
            [self.shopThisLookButton setTapHandler:^(id sender) {
                if ([tapDelegate respondsToSelector:@selector(buttonTap:)]) {
                    [tapDelegate buttonTap:button];
                }
            }];

            extraParentFrameHeight += kGTIOShopThisLookButtonBottomPadding;
        }
    }

    [self.shopThisLookButton setFrame:(CGRect){ self.photoImageView.frame.size.width - self.shopThisLookButton.frame.size.width - kGTIOShopThisLookButtonRightPadding, self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height + extraHeight, self.shopThisLookButton.bounds.size.width, shopThisLookButtonHeight }];
    
    [self.frameImageView setFrame:(CGRect){ self.frameImageView.frame.origin, { kGTIOFrameWidth, self.shopThisLookButton.frame.origin.y + self.shopThisLookButton.frame.size.height + kGTIOFrameHeightPadding + extraParentFrameHeight } }];
    
    [self setFrame:(CGRect){ self.frame.origin, self.frameImageView.frame.size }];
    

}

- (void) dealloc 
{
    self.delegate = nil;
}

#pragma mark - Properties

- (void)setPost:(GTIOPost *)post
{
    _post = post;
    
    // Photo
    __block typeof(self) blockSelf = self;
    [self.photoImageView setImageWithURL:_post.photo.mainImageURL success:^(UIImage *image) {
        [blockSelf setNeedsLayout];
    } failure:nil];
    

    // Description
    NSData *data = [_post.postDescription dataUsingEncoding:NSUTF8StringEncoding];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:self.descriptionAttributeTextOptions documentAttributes:NULL];
    self.descriptionTextView.attributedString = string;
    

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

#pragma mark - Height

+ (CGSize)scalePhotoSize:(CGSize)actualPhotoSize
{
    CGFloat photoWidth = kGTIOFrameWidth - 20;
    CGFloat photoHeight = photoWidth;
    
    if (actualPhotoSize.width > 0) {
        CGFloat photoWidthScale = photoWidth / actualPhotoSize.width;
        photoHeight = (int)(actualPhotoSize.height * photoWidthScale);
    }
    
    return (CGSize){ photoWidth, photoHeight };
}

+ (CGSize)descriptionTextSize:(NSString *)text
{
    [DTAttributedTextContentView setLayerClass:[CATiledLayer class]];
    DTAttributedTextView *desciptionAttributedTextView = [[DTAttributedTextView alloc] initWithFrame:(CGRect){ CGPointZero, { kGTIODescriptionTextWidth, 0 } }];
    desciptionAttributedTextView.contentView.edgeInsets = (UIEdgeInsets) { -2, 0, 8, 0 };
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PostDescription" ofType:@"css"];  
    NSData *cssData = [NSData dataWithContentsOfFile:filePath];
    NSString *cssString = [[NSString alloc] initWithData:cssData encoding:NSUTF8StringEncoding];
    DTCSSStylesheet *stylesheet = [[DTCSSStylesheet alloc] initWithStyleBlock:cssString];
    
    NSDictionary *descriptionAttributedTextOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSNumber numberWithBool:NO], DTDefaultLinkDecoration,
                                                      [NSNumber numberWithFloat:1.2], DTDefaultLineHeightMultiplier,
                                                      stylesheet, DTDefaultStyleSheet,
                                                      nil];
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:descriptionAttributedTextOptions documentAttributes:NULL];
    desciptionAttributedTextView.attributedString = string;
    
    CGSize descriptionTextSize = [desciptionAttributedTextView.contentView sizeThatFits:(CGSize){ kGTIODescriptionTextWidth, CGFLOAT_MAX }];

    return descriptionTextSize;
}

+ (CGFloat)heightWithPost:(GTIOPost *)post
{
    CGSize photoSize = [GTIOPostFrameView scalePhotoSize:post.photo.photoSize];
    
    CGSize descriptionTextSize = [GTIOPostFrameView descriptionTextSize:post.postDescription];
    if (descriptionTextSize.height > 0) {
        descriptionTextSize.height += kGTIODescriptionLabelTopPadding;
    }
    
    CGFloat shopThisLookHeight = 0;
    for (GTIOButton *button in post.buttons) {
        if([button.name isEqualToString:kGTIOPostSideShopButton]) {
            shopThisLookHeight = kGTIOShopThisLookButtonHeight + kGTIOShopThisLookButtonTopPadding;
        }
    }
    
    return photoSize.height + descriptionTextSize.height + shopThisLookHeight + kGTIOFrameHeightWithShadowPadding;
}

- (void)showFullScreenImage
{    
    self.fullScreenImageViewer = [[GTIOFullScreenImageViewer alloc] initWithPhotoURL:self.post.photo.mainImageURL];
    [self.fullScreenImageViewer show];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIODismissEllipsisPopOverViewNotification object:nil];
}

@end
