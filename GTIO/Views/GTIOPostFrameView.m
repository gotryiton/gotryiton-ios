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

#import "GTIOHeartButton.h"
#import "GTIOPostBrandButtonsView.h"

static CGFloat const kGTIOFrameWidth = 270.0f;
static CGFloat const kGTIOFrameHeightPadding = 16.0f;
static CGFloat const kGTIOFrameHeightWithShadowPadding = 22.0f;
static CGFloat const kGTIOPhotoTopPadding = 7.0f;
static CGFloat const kGTIOHeartButtonPadding = 9.0f;
static CGFloat const kGTIODescriptionTextWidth = 240.0f;
static CGFloat const kGTIODescriptionLabelTopPadding = 5.0f;
static CGFloat const kGTIOBrandButtonsTopPadding = 6.0f;
static CGFloat const kGTIOBrandButtonsTopPaddingNoDescription = 11.0f;
static CGFloat const kGTIOBrandButtonsBottomPadding = 4.0f;

@interface GTIOPostFrameView ()  <DTAttributedTextContentViewDelegate>

@property (nonatomic, strong) UIImageView *frameImageView;
@property (nonatomic, strong) DTAttributedTextView *descriptionTextView;
@property (nonatomic, strong) NSDictionary *descriptionAttributeTextOptions;
@property (nonatomic, strong) GTIOHeartButton *heartButton;
@property (nonatomic, strong) GTIOButton *photoHeartButtonModel;
@property (nonatomic, strong) GTIOPostBrandButtonsView *brandButtonsView;

@end

@implementation GTIOPostFrameView

@synthesize post = _post;
@synthesize frameImageView = _frameImageView, photoImageView = _photoImageView, descriptionTextView = _descriptionTextView, heartButton = _heartButton, photoHeartButtonModel = _photoHeartButtonModel, brandButtonsView = _brandButtonsView;
@synthesize descriptionAttributeTextOptions = _descriptionAttributeTextOptions;

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
        
        _heartButton = [GTIOHeartButton heartButtonWithTapHandler:^(id sender) {
            [self.heartButton setHearted:![self.heartButton isHearted]];
            
            [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.photoHeartButtonModel.action.endpoint delegate:nil];
        }];
        [self addSubview:_heartButton];
        
        [DTAttributedTextContentView setLayerClass:[CATiledLayer class]];
        _descriptionTextView = [[DTAttributedTextView alloc] initWithFrame:CGRectZero];
        _descriptionTextView.textDelegate = self;
        _descriptionTextView.contentView.edgeInsets = (UIEdgeInsets) { -5, 0, 0, 0 };
        [_descriptionTextView setScrollEnabled:NO];
        [_descriptionTextView setScrollsToTop:NO];
        [_descriptionTextView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_descriptionTextView];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PostDescription" ofType:@"css"];  
        NSData *cssData = [NSData dataWithContentsOfFile:filePath];
        NSString *cssString = [[NSString alloc] initWithData:cssData encoding:NSUTF8StringEncoding];
        DTCSSStylesheet *defaultDTCSSStylesheet = [[DTCSSStylesheet alloc] initWithStyleBlock:cssString];
        
        _descriptionAttributeTextOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithFloat:1.2], DTDefaultLineHeightMultiplier,
                                            [UIColor gtio_grayTextColor232323], DTDefaultTextColor,
                                            [UIColor gtio_pinkTextColor], DTDefaultLinkColor,
                                            [NSNumber numberWithBool:NO], DTDefaultLinkDecoration,
                                            defaultDTCSSStylesheet, DTDefaultStyleSheet,
                                            nil];
        
        _brandButtonsView = [[GTIOPostBrandButtonsView alloc] initWithFrame:(CGRect){ CGPointZero, { kGTIODescriptionTextWidth, 0 } }];
        [self addSubview:_brandButtonsView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat extraHeight = 0.0f; // This height is used for placing view frames
    CGFloat extraParentFrameHeight = 0.0f; // This height is used for making container frame bigger

    CGSize photoSize = [GTIOPostFrameView scalePhotoSize:self.post.photo.photoSize];

    [self.photoImageView setFrame:(CGRect){ 10, kGTIOPhotoTopPadding, photoSize }];
    [self.heartButton setFrame:(CGRect){ { self.photoImageView.frame.origin.x + kGTIOHeartButtonPadding, self.photoImageView.frame.origin.y + kGTIOHeartButtonPadding }, self.heartButton.frame.size }];
    
    CGSize descriptionTextSize = [self.descriptionTextView.contentView sizeThatFits:(CGSize){ kGTIODescriptionTextWidth, CGFLOAT_MAX }];
    if (descriptionTextSize.height > 0) {
        [self.descriptionTextView setFrame:(CGRect){ self.photoImageView.frame.origin.x + 5, self.photoImageView.frame.origin.y + self.photoImageView.frame.size.height + kGTIODescriptionLabelTopPadding, kGTIODescriptionTextWidth, descriptionTextSize.height}];
    } else {
        // Set description label to bottom of photo view to be able to use for height of frame
        [self.descriptionTextView setFrame:(CGRect){ self.photoImageView.frame.origin.x + 5, self.photoImageView.frame.origin.y + self.photoImageView.frame.size.height, kGTIODescriptionTextWidth, descriptionTextSize.height}];
    }

    if (self.brandButtonsView.frame.size.height > 0) {
        // Add extra brand button padding if no description
        if (descriptionTextSize.height > 0) {
            extraHeight += kGTIOBrandButtonsTopPadding;
        } else {
            extraHeight += kGTIOBrandButtonsTopPaddingNoDescription;
        }
        
        [self.brandButtonsView setFrame:(CGRect){ self.photoImageView.frame.origin.x + 5, self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height + extraHeight, kGTIODescriptionTextWidth, self.brandButtonsView.frame.size.height }];
        
        extraParentFrameHeight += kGTIOBrandButtonsBottomPadding;
    } else {
        [self.brandButtonsView setFrame:(CGRect){ self.photoImageView.frame.origin.x + 5, self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height, kGTIODescriptionTextWidth, self.brandButtonsView.frame.size.height }];
    }
    
    [self.frameImageView setFrame:(CGRect){ self.frameImageView.frame.origin, { kGTIOFrameWidth, self.brandButtonsView.frame.origin.y + self.brandButtonsView.frame.size.height + kGTIOFrameHeightPadding + extraParentFrameHeight } }];
    
    [self setFrame:(CGRect){ self.frame.origin, self.frameImageView.frame.size }];
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
    
    // Hearted
    for (GTIOButton *button in _post.buttons) {
        if ([button.name isEqualToString:kGTIOPhotoHeartButton]) {
            self.photoHeartButtonModel = button;
            [self.heartButton setHearted:[self.photoHeartButtonModel.state boolValue]];
            break;
        }
    }

    // Description
    NSData *data = [_post.postDescription dataUsingEncoding:NSUTF8StringEncoding];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:self.descriptionAttributeTextOptions documentAttributes:NULL];
    self.descriptionTextView.attributedString = string;
    
    // Brand buttons
    [self.brandButtonsView setButtons:_post.brandsButtons];
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
    desciptionAttributedTextView.contentView.edgeInsets = (UIEdgeInsets) { -4, 0, 8, 0 };
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PostDescription" ofType:@"css"];  
    NSData *cssData = [NSData dataWithContentsOfFile:filePath];
    NSString *cssString = [[NSString alloc] initWithData:cssData encoding:NSUTF8StringEncoding];
    DTCSSStylesheet *stylesheet = [[DTCSSStylesheet alloc] initWithStyleBlock:cssString];
    
    NSDictionary *descriptionAttributedTextOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSNumber numberWithFloat:1.2], DTDefaultLineHeightMultiplier,
                                                      [NSNumber numberWithBool:NO], DTDefaultLinkDecoration,
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
    
    CGFloat brandButtonsHeight = [GTIOPostBrandButtonsView heightWithWidth:kGTIODescriptionTextWidth buttons:post.brandsButtons];
    if (brandButtonsHeight > 0) {
        // Add brand button padding
        if (descriptionTextSize.height > 0) {
            brandButtonsHeight += kGTIOBrandButtonsTopPadding;
        } else {
            brandButtonsHeight += kGTIOBrandButtonsTopPaddingNoDescription;
        }
        brandButtonsHeight += kGTIOBrandButtonsBottomPadding;
    }
    
    return photoSize.height + descriptionTextSize.height + brandButtonsHeight + kGTIOFrameHeightWithShadowPadding;
}

@end
