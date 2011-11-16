//
//  GTIOSpinnerImageView.m
//  GTIO
//
//  Created by Jeremy Ellison on 11/10/11.
//  Copyright (c) 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOSpinnerImageView.h"

@implementation GTIOSpinnerImageView


- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
    if (self) {
        _spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        [self addSubview:_spinner];
        _spinner.center = self.center;
        _spinner.hidesWhenStopped = YES;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _spinner.center = self.center;
}

- (void)requestDidStartLoad:(TTURLRequest*)request {
    [super requestDidStartLoad:request];
    [_spinner startAnimating];
}


- (void)requestDidFinishLoad:(TTURLRequest*)request {
    [_spinner stopAnimating];
    [super requestDidFinishLoad:request];
}

@end
