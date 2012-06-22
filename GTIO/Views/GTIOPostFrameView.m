//
//  GTIOPostFrameView.m
//  GTIO
//
//  Created by Scott Penrose on 6/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostFrameView.h"

#import "TTTAttributedLabel.h"
#import "UIImageView+WebCache.h"

#import "GTIOHeartButton.h"
#import "GTIOPhoto.h"
#import "GTIOButton.h"

static CGFloat const kGTIOFrameWidth = 270.0f;
static CGFloat const kGTIOFrameHeightPadding = 16.0f;
static CGFloat const kGTIOFrameHeightWithShadowPadding = 22.0f;
static CGFloat const kGTIOHeartButtonPadding = 9.0f;
static CGFloat const kGTIODescriptionTextWidth = 240.0f;
static CGFloat const kGTIODescriptionLabelTopPadding = 8.0f;

@interface GTIOPostFrameView ()

@property (nonatomic, strong) UIImageView *frameImageView;
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) TTTAttributedLabel *descriptionLabel;
@property (nonatomic, strong) GTIOHeartButton *heartButton;
@property (nonatomic, strong) GTIOButton *photoHeartButtonModel;

@end

@implementation GTIOPostFrameView

@synthesize post = _post;
@synthesize frameImageView = _frameImageView, photoImageView = _photoImageView, descriptionLabel = _descriptionLabel, heartButton = _heartButton, photoHeartButtonModel = _photoHeartButtonModel;

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
        }];
        [self addSubview:_heartButton];
        
        _descriptionLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [_descriptionLabel setFont:[UIFont gtio_verlagFontWithWeight:GTIOFontVerlagXLight size:13.0f]];
        [_descriptionLabel setTextColor:[UIColor gtio_darkGray3TextColor]];
        [_descriptionLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_descriptionLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize photoSize = [GTIOPostFrameView scalePhotoSize:self.post.photo.photoSize];

    [self.photoImageView setFrame:(CGRect){ 10, 7, photoSize }];
    [self.heartButton setFrame:(CGRect){ { self.photoImageView.frame.origin.x + kGTIOHeartButtonPadding, self.photoImageView.frame.origin.y + kGTIOHeartButtonPadding }, self.heartButton.frame.size }];
    
    CGSize descriptionTextSize = [GTIOPostFrameView descriptionTextSize:self.post.postDescription];
    if (descriptionTextSize.height > 0) {
        [self.descriptionLabel setFrame:(CGRect){ self.photoImageView.frame.origin.x + 5, self.photoImageView.frame.origin.y + self.photoImageView.frame.size.height + kGTIODescriptionLabelTopPadding, kGTIODescriptionTextWidth, descriptionTextSize.height}];
    } else {
        // Set description label to bottom of photo view to be able to use for height of frame
        [self.descriptionLabel setFrame:(CGRect){ self.photoImageView.frame.origin.x + 5, self.photoImageView.frame.origin.y + self.photoImageView.frame.size.height, kGTIODescriptionTextWidth, descriptionTextSize.height}];
    }
    
    [self.frameImageView setFrame:(CGRect){ self.frameImageView.frame.origin, { kGTIOFrameWidth, self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.size.height + kGTIOFrameHeightPadding } }];
    
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
    
    [self.descriptionLabel setText:_post.postDescription];
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
    return [text sizeWithFont:[UIFont gtio_verlagFontWithWeight:GTIOFontVerlagXLight size:13.0f] constrainedToSize:(CGSize){ kGTIODescriptionTextWidth, CGFLOAT_MAX }];
}
    

+ (CGFloat)heightWithPost:(GTIOPost *)post
{
    CGSize photoSize = [GTIOPostFrameView scalePhotoSize:post.photo.photoSize];
    CGSize descriptionTextSize = [GTIOPostFrameView descriptionTextSize:post.postDescription];
    
    if (descriptionTextSize.height > 0) {
        descriptionTextSize.height += kGTIODescriptionLabelTopPadding; // Extra padding to make sure height is correct of cell
    }
    
    return photoSize.height + descriptionTextSize.height + kGTIOFrameHeightWithShadowPadding;
}

@end
