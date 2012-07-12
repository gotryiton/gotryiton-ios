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


@interface GTIONotificationsTableViewCell()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) DTAttributedTextView *text;
@property (nonatomic, strong) NSDictionary *textOptions;

@end

@implementation GTIONotificationsTableViewCell

@synthesize icon = _icon, text = _text, notification = _notification, textOptions = _textOptions;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_icon];
        [DTAttributedTextContentView setLayerClass:[CATiledLayer class]];
        _text = [[DTAttributedTextView alloc] initWithFrame:CGRectZero];
        _text.backgroundView = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, 200, 100 }];
        _text.backgroundView.backgroundColor = [UIColor yellowColor];
        _text.textDelegate = self;
        _text.contentView.edgeInsets = (UIEdgeInsets) { -4, 0, 0, 0 };
        [_text setScrollEnabled:NO];
        [_text setScrollsToTop:NO];
        [_text setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_text];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"NotificationTableCellText" ofType:@"css"];  
        NSData *cssData = [NSData dataWithContentsOfFile:filePath];
        NSString *cssString = [[NSString alloc] initWithData:cssData encoding:NSUTF8StringEncoding];
        DTCSSStylesheet *defaultDTCSSStylesheet = [[DTCSSStylesheet alloc] initWithStyleBlock:cssString];
        
        _textOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithFloat:0.8], DTDefaultLineHeightMultiplier,
                                            defaultDTCSSStylesheet, DTDefaultStyleSheet,
                                            nil];
        [self.contentView addSubview:_text];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.icon setFrame:(CGRect){ kGTIOCellLeftRightPadding, self.bounds.size.height / 2 - (self.icon.bounds.size.height / 2), kGTIOIconWidthHeight, kGTIOIconWidthHeight }];
    CGFloat textWidth = self.bounds.size.width - (self.icon.frame.origin.x + self.icon.bounds.size.width + kGTIOIconTextSpacing + kGTIOCellLeftRightPadding);
    CGSize textSize = [self.text.contentView sizeThatFits:(CGSize){ textWidth, CGFLOAT_MAX }];
    [self.text setFrame:(CGRect){ self.icon.frame.origin.x + self.icon.bounds.size.width + kGTIOIconTextSpacing, kGTIOCellTopBottomPadding, textWidth, textSize.height }];
}

- (void)setNotification:(GTIONotification *)notification
{
    _notification = notification;
    __block typeof(self) blockSelf = self;
    [self.icon setImageWithURL:_notification.icon success:^(UIImage *image) {
        [blockSelf setNeedsLayout];
    } failure:nil];
    NSData *data = [_notification.text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:self.textOptions documentAttributes:NULL];
    self.text.attributedString = string;
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
