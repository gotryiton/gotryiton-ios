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

+ (id)gtio_autoCompleteButtonWithCompleter:(GTIOAutoCompleter *)completer
{
    GTIOAutoCompleteButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.completer = completer;

    [button setTitleColor:[UIColor gtio_grayTextColor404040] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:14.0]];
    [button setTitle:completer.name forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(2, 12, 2, 12)];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(1, 3, 1, 3);
    [button setBackgroundImage:[[UIImage imageNamed:@"keyboard-top-control-button-active.png"] resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"keyboard-top-control-button-inactive.png"] resizableImageWithCapInsets:insets]forState:UIControlStateHighlighted];
    
    CGSize displayNameTextSize = [completer.name sizeWithFont:button.titleLabel.font forWidth:400.0f lineBreakMode:UILineBreakModeTailTruncation];


    if (completer.icon) {
        UIImageView *icon = [[UIImageView alloc] initWithFrame:(CGRect){4,4,26,26}];
        [icon setContentMode:UIViewContentModeScaleAspectFill];
        icon.hidden = YES;
        [button addSubview:icon];

        UIImageView *outerShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user-icon-overlay-52.png"]];
        [outerShadow setFrame:icon.frame];
        outerShadow.hidden = YES;
        [button addSubview:outerShadow];

        [icon setImageWithURL:completer.icon placeholderImage:nil success:^(UIImage *image) {
            icon.hidden = NO;
            outerShadow.hidden = NO;
        } failure:^(NSError *error) {
            NSLog(@"Error loading auto complete button image: %@", [error localizedDescription]);
        }];
        
        // fix positioning of text:
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        displayNameTextSize.width += 38;
    } else {
        displayNameTextSize.width += 24;
    }

    [button setFrame:(CGRect){ CGPointZero, displayNameTextSize.width + 10, 34 } ];
    return button;
}

@end
