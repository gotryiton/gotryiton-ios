//
//  GTIOAutoCompleteButton.m
//  GTIO
//
//  Created by Simon Holroyd on 6/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOAutoCompleteButton.h"

#import "GTIOAutoCompleter.h"

@implementation GTIOAutoCompleteButton

@synthesize completer = _completer;


- (id)initWithFrame:(CGRect) frame withCompleter:(GTIOAutoCompleter *) completer
{
    self = [super initWithFrame:frame];
    if (self) {

        _completer = completer;

        [self setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];

        [self setTitle:completer.name forState:UIControlStateNormal];
        [self setTitleColor:[UIColor gtio_darkGrayTextColor] forState:UIControlStateNormal];
    	[self.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
    	

    	CGSize displayNameTextSize = [completer.name sizeWithFont:[UIFont boldSystemFontOfSize:12.0f] forWidth:200.0f lineBreakMode:UILineBreakModeTailTruncation];

    	//NSLog(@"created button: %@ with size:%@", completer.name, NSStringFromCGSize(displayNameTextSize));
        [self setFrame:(CGRect){ CGRectGetMinX(frame), CGRectGetMinY(frame), displayNameTextSize.width, CGRectGetHeight(frame) } ];

        [self addTarget:self action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];

        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blueColor].CGColor;

        
    }
    return self;
}


@end
