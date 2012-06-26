//
//  GTIOAutoCompleteButton.m
//  GTIO
//
//  Created by Simon Holroyd on 6/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOAutoCompleteButton.h"

#import "GTIOAutoCompleter.h"
#import "UIImageView+WebCache.h"

@implementation GTIOAutoCompleteButton

@synthesize completer = _completer;

- (id)initWithFrame:(CGRect)frame completer:(GTIOAutoCompleter *)completer
{
    self = [super initWithFrame:frame];
    if (self) {
        _completer = completer;

        [self setTitleColor:[UIColor gtio_404040GrayTextColor] forState:UIControlStateNormal];
    	[self.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:14.0]];
        [self setTitle:completer.name forState:UIControlStateNormal];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(2, 12, 2, 12)];
        
        UIEdgeInsets insets = UIEdgeInsetsMake(1, 3, 1, 3);
        [self setBackgroundImage:[[UIImage imageNamed:@"keyboard-top-control-button-active.png"] resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
    	[self setBackgroundImage:[[UIImage imageNamed:@"keyboard-top-control-button-inactive.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
        
        CGSize displayNameTextSize = [completer.name sizeWithFont:self.titleLabel.font forWidth:400.0f lineBreakMode:UILineBreakModeTailTruncation];
        
	    if (completer.icon) {
            UIImageView *icon = [[UIImageView alloc] initWithFrame:(CGRect){4,4,26,26}];
	        [icon setContentMode:UIViewContentModeScaleAspectFill];
	        icon.hidden = YES;
	        [self addSubview:icon];

	        UIImageView *outerShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user-icon-overlay-52.png"]];
	        [outerShadow setFrame: icon.frame];
	        outerShadow.hidden = YES;
	        [self addSubview:outerShadow];

            [icon setImageWithURL:completer.icon placeholderImage:nil success:^(UIImage *image) {
            	icon.hidden = NO;
            	outerShadow.hidden = NO;
            } failure:^(NSError *error) {
                NSLog(@"Error loading auto complete button image: %@", [error localizedDescription]);
            }];
            
	        // fix positioning of text:
	        [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
	        displayNameTextSize.width += 32;
	    } else {
            displayNameTextSize.width += 12;
        }

        [self setFrame:(CGRect){ CGRectGetMinX(frame), CGRectGetMinY(frame), displayNameTextSize.width + 10, CGRectGetHeight(frame) } ];
    }
    return self;
}

@end
