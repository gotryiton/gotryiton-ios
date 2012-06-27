//
//  GTIOWhoHeartedThisView.m
//  GTIO
//
//  Created by Scott Penrose on 6/27/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOWhoHeartedThisView.h"

#import "TTTAttributedLabel.h"

#import "GTIOButton.h"

static CGFloat const kGTIOTextTopPadding = 4.0f;
static CGFloat const kGTIOTextWidth = 228.0f;

@interface GTIOWhoHeartedThisView ()

@property (nonatomic, strong) UIImageView *heartImageView;
@property (nonatomic, strong) DTAttributedTextView *namesAttributedTextView;
@property (nonatomic, strong) NSDictionary *namesAttributeTextOptions;

@end

@implementation GTIOWhoHeartedThisView

@synthesize whoHeartedThisButtons = _whoHeartedThisButtons;
@synthesize heartImageView = _heartImageView, namesAttributedTextView = _namesAttributedTextView, namesAttributeTextOptions = _namesAttributedTextOptions;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor redColor]];
        
        _heartImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart-bullet.png"]];
        [_heartImageView setFrame:(CGRect){ { -3, 0 }, _heartImageView.image.size }];
        [self addSubview:_heartImageView];
        
        [DTAttributedTextContentView setLayerClass:[CATiledLayer class]];
        _namesAttributedTextView = [[DTAttributedTextView alloc] initWithFrame:(CGRect){ _heartImageView.image.size.width + 1, kGTIOTextTopPadding, { kGTIOTextWidth, 0 } }];
        _namesAttributedTextView.textDelegate = self;
        _namesAttributedTextView.contentView.edgeInsets = (UIEdgeInsets){ -4, 0, 8, 0 };
        [_namesAttributedTextView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_namesAttributedTextView];
    
        _namesAttributedTextOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithFloat:1.0], NSTextSizeMultiplierDocumentOption, 
                                       [NSNumber numberWithFloat:0.8], DTDefaultLineHeightMultiplier,
                                       [UIColor gtio_grayTextColorACACAC], DTDefaultTextColor,
                                       [UIColor gtio_grayTextColorACACAC], DTDefaultLinkColor,
                                       [NSNumber numberWithBool:NO], DTDefaultLinkDecoration,
                                       nil];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - Properties

- (void)setWhoHeartedThisButtons:(NSArray *)whoHeartedThisButtons
{
    _whoHeartedThisButtons = whoHeartedThisButtons;
    
#warning Hardcoded text
    NSString *html = @"<span style=\"font-weight:'ProximaNova-Semibold';font-family:'P-Smbld';font-size:13px\"><a href=\"/profile/1\">147 hearted this</a> <a href=\"/profile/1\">Scott</a>, <a href=\"/profile/2\">Josh</a>, <a href=\"/profile/1\">Scott B.</a>, <a href=\"/profile/2\">Jams</a>, <a href=\"/profile/1\">Duncan</a>, <a href=\"/profile/2\">Matt</a></span>";
//    NSString *html = @"<span style=\"font-weight:'ProximaNova-Semibold';font-family:'P-Smbld';font-size:13px\"><a href=\"/profile/1\">147 hearted this</a></span>";
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:self.namesAttributeTextOptions documentAttributes:NULL];
    _namesAttributedTextView.attributedString = string;
    
    CGSize namesAttributedTextViewSize = [self.namesAttributedTextView.contentView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kGTIOTextWidth];
    [self.namesAttributedTextView setFrame:(CGRect){ self.namesAttributedTextView.frame.origin, namesAttributedTextViewSize }];
    [self setFrame:(CGRect){ self.frame.origin, { self.frame.size.width, self.namesAttributedTextView.frame.origin.y + self.namesAttributedTextView.frame.size.height + kGTIOTextTopPadding } }];
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
	NSURL *URL = button.URL;
	NSLog(@"Load url: %@", URL);
}

#pragma mark - Height

+ (CGFloat)heightWithWhoHeartedThisButtons:(NSArray *)whoHeartedThisButtons
{
    [DTAttributedTextContentView setLayerClass:[CATiledLayer class]];
    DTAttributedTextView *namesAttributedTextView = [[DTAttributedTextView alloc] initWithFrame:(CGRect){ CGPointZero, { kGTIOTextWidth, 0 } }];
    namesAttributedTextView.contentView.edgeInsets = (UIEdgeInsets){ -5, 0, 8, 0 };
    
    NSDictionary *namesAttributedTextOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [NSNumber numberWithFloat:1.0], NSTextSizeMultiplierDocumentOption,
                                                [NSNumber numberWithFloat:0.8], DTDefaultLineHeightMultiplier,
                                                [NSNumber numberWithBool:NO], DTDefaultLinkDecoration,
                                                nil];
    
#warning Hardcoded text
    NSString *html = @"<span style=\"font-weight:'ProximaNova-Semibold';font-family:'P-Smbld';font-size:13px\"><a href=\"/profile/1\">147 hearted this</a> <a href=\"/profile/1\">Scott</a>, <a href=\"/profile/2\">Josh</a>, <a href=\"/profile/1\">Scott B.</a>, <a href=\"/profile/2\">Jams</a>, <a href=\"/profile/1\">Duncan</a>, <a href=\"/profile/2\">Matt</a></span>";
//    NSString *html = @"<span style=\"font-weight:'ProximaNova-Semibold';font-family:'P-Smbld';font-size:13px\"><a href=\"/profile/1\">147 hearted this</a></span>";
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:namesAttributedTextOptions documentAttributes:NULL];
    namesAttributedTextView.attributedString = string;
    
    CGSize namesAttributedTextViewSize = [namesAttributedTextView.contentView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kGTIOTextWidth];
    
    return kGTIOTextTopPadding + namesAttributedTextViewSize.height + kGTIOTextTopPadding;
}

@end
