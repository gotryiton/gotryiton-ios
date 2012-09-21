//
//  GTIONotificationsTableViewCell.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIONotificationsTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "NSString+GTIOAdditions.h"

static CGFloat const kGTIOCellTopBottomPadding = 16.0;
static CGFloat const kGTIOCellLeftRightPadding = 8.0;
static CGFloat const kGTIOIconWidthHeight = 21.0;
static CGFloat const kGTIOIconTextSpacing = 10.0;
static CGFloat const kGTIOTextWidth = 247.0;
static CGFloat const kGTIOTextViewBottomPaddingInset = 6.0;


@interface GTIONotificationsTableViewCell()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) DTAttributedTextView *text;
@property (nonatomic, strong) NSDictionary *textOptions;

@property (nonatomic, strong) UIView *bottomBorder;

@end

@implementation GTIONotificationsTableViewCell

@synthesize icon = _icon, text = _text, notification = _notification, textOptions = _textOptions, bottomBorder = _bottomBorder;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_icon];
        
        [DTAttributedTextContentView setLayerClass:[CATiledLayer class]];
        _text = [[DTAttributedTextView alloc] initWithFrame:CGRectZero];
        _text.textDelegate = self;
        _text.contentView.clipsToBounds = NO;
        _text.clipsToBounds = NO;
        _text.contentView.edgeInsets = (UIEdgeInsets) { -4, 0, 0, 0 };
        _text.userInteractionEnabled = NO;
        [_text setScrollEnabled:NO];
        [_text setScrollsToTop:NO];
        [_text setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_text];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"NotificationTableCellText" ofType:@"css"];  
        NSData *cssData = [NSData dataWithContentsOfFile:filePath];
        NSString *cssString = [[NSString alloc] initWithData:cssData encoding:NSUTF8StringEncoding];
        DTCSSStylesheet *defaultDTCSSStylesheet = [[DTCSSStylesheet alloc] initWithStyleBlock:cssString];
        
        _textOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithFloat:1.0], DTDefaultLineHeightMultiplier,
                                            defaultDTCSSStylesheet, DTDefaultStyleSheet,
                                            nil];
        [self.contentView addSubview:_text];
        
        _bottomBorder = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomBorder.backgroundColor = [UIColor gtio_groupedTableBorderColor];
        [self addSubview:_bottomBorder];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.icon setFrame:(CGRect){ kGTIOCellLeftRightPadding, self.bounds.size.height / 2 - (self.icon.bounds.size.height / 2), kGTIOIconWidthHeight, kGTIOIconWidthHeight }];
    CGSize textSize = [self.text.contentView sizeThatFits:(CGSize){ kGTIOTextWidth, CGFLOAT_MAX }];
    [self.text setFrame:(CGRect){ self.icon.frame.origin.x + self.icon.bounds.size.width + kGTIOIconTextSpacing, kGTIOCellTopBottomPadding, kGTIOTextWidth, textSize.height }];
    [self.bottomBorder setFrame:(CGRect){ 0, self.bounds.size.height - 1, self.bounds.size.width, 1 }];
}

- (void)setNotification:(GTIONotification *)notification
{
    _notification = notification;
    __block typeof(self) blockSelf = self;
    [self.icon setImageWithURL:_notification.icon success:^(UIImage *image) {
        [blockSelf setNeedsLayout];
    } failure:nil];
    
    NSString *notificationText;
    if (notification.tapped.boolValue) {
        notificationText = [NSString stringWithFormat:@"<div id='viewed'>%@</div>", _notification.text];
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.45];
    } else {
        notificationText = [NSString stringWithFormat:@"<div>%@</div>", _notification.text];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    NSData *data = [notificationText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:self.textOptions documentAttributes:NULL];
    self.text.attributedString = string;
    [self setNeedsLayout];
}

+ (CGFloat)heightWithNotification:(GTIONotification *)notification
{
    [DTAttributedTextContentView setLayerClass:[CATiledLayer class]];
    DTAttributedTextView *textAttributedTextView = [[DTAttributedTextView alloc] initWithFrame:(CGRect){ CGPointZero, { kGTIOTextWidth, 0 } }];
    textAttributedTextView.contentView.edgeInsets = (UIEdgeInsets) { -4, 0, 0, 0 };
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"NotificationTableCellText" ofType:@"css"];  
    NSData *cssData = [NSData dataWithContentsOfFile:filePath];
    NSString *cssString = [[NSString alloc] initWithData:cssData encoding:NSUTF8StringEncoding];
    DTCSSStylesheet *stylesheet = [[DTCSSStylesheet alloc] initWithStyleBlock:cssString];
    
    NSDictionary *descriptionAttributedTextOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSNumber numberWithFloat:1.0], DTDefaultLineHeightMultiplier,
                                                      stylesheet, DTDefaultStyleSheet,
                                                      nil];
    
    NSData *data = [notification.text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:descriptionAttributedTextOptions documentAttributes:NULL];
    textAttributedTextView.attributedString = string;
    
    CGSize textSize = [textAttributedTextView.contentView sizeThatFits:(CGSize){ kGTIOTextWidth, CGFLOAT_MAX }];
    
    return textSize.height + kGTIOCellTopBottomPadding * 2 - kGTIOTextViewBottomPaddingInset;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
