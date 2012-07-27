//
//  GTIOProfileCalloutView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProfileCalloutView.h"
#import "TTTAttributedLabel.h"
#import "UIImageView+WebCache.h"
#import "NSString+GTIOAdditions.h"

@interface GTIOProfileCalloutView()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) TTTAttributedLabel *calloutText;

@end

@implementation GTIOProfileCalloutView

@synthesize icon = _icon, calloutText = _calloutText, profileCallout = _profileCallout, user = _user;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _icon = [[UIImageView alloc] initWithFrame:(CGRect){ 0, 0, 13, 13 }];
        [self addSubview:_icon];
        
        _calloutText = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [_calloutText setBackgroundColor:[UIColor clearColor]];
        [_calloutText setTextColor:[UIColor gtio_grayTextColor9C9C9C]];
        [_calloutText setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:11.0]];
        [self addSubview:_calloutText];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.calloutText sizeToFit];
    [self.calloutText setFrame:(CGRect){ self.icon.frame.origin.x + self.icon.bounds.size.width + 3, self.icon.frame.origin.y, self.bounds.size.width - self.icon.bounds.size.width - 3, self.calloutText.bounds.size.height }];
}

- (void)setProfileCallout:(GTIOProfileCallout *)profileCallout user:(GTIOUser *)user
{
    _profileCallout = profileCallout;
    self.user = user;

    [self.icon setImageWithURL:self.profileCallout.icon];
    
    [self.calloutText setText:[self.profileCallout.text uppercaseString] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSArray *boldRanges = [[self.profileCallout.text uppercaseString] rangesOfHTMLBoldedText];
        for (NSValue *value in boldRanges) {
            NSRange boldRange = [value rangeValue];
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor whiteColor].CGColor range:boldRange];
        }
        // remove HTML bold tags
        for (NSValue *value in boldRanges) {
            [mutableAttributedString deleteCharactersInRange:[[mutableAttributedString string] rangeOfString:@"<B>"]];
            [mutableAttributedString deleteCharactersInRange:[[mutableAttributedString string] rangeOfString:@"</B>"]];
        }
        return mutableAttributedString;
    }];
    [self setNeedsLayout];
}

@end
