//
//  GTIOAddStylistButton.m
//  GTIO
//
//  Created by Duncan Lewis on 11/21/11.
//  Copyright (c) 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOAddStylistButton.h"

@implementation GTIOAddStylistButton

@synthesize selected = _selected;
@synthesize checkboxView = _checkboxView;
@synthesize profile;

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle imageURL:(NSString *)imageURL {
    self = [super init];
    if(self) {
        self.selected = YES;
        
        UIImage* checkBoxImage = [UIImage imageNamed:@"add-checkbox-ON.png"];
        self.checkboxView = [[[UIImageView alloc] initWithImage:checkBoxImage] autorelease];
        
        TTImageView* imageView = [[[TTImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)] autorelease];
        imageView.urlPath = imageURL;
        imageView.layer.borderColor = RGBCOLOR(218,218,218).CGColor;
        imageView.layer.borderWidth = 1;
        
        UILabel* titleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        titleLabel.font = kGTIOFontHelveticaNeueOfSize(15);
        titleLabel.textColor = kGTIOColor797979;
        titleLabel.text = title;
        titleLabel.backgroundColor = [UIColor clearColor];
        [titleLabel sizeToFit];
        titleLabel.frame = CGRectMake(40, 5, titleLabel.width, titleLabel.height);
        
        UILabel* subtitleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        subtitleLabel.font = kGTIOFontHelveticaNeueOfSize(10);
        subtitleLabel.textColor = kGTIOColorAFAFAF;
        subtitleLabel.text = subtitle;
        subtitleLabel.backgroundColor = [UIColor clearColor];
        [subtitleLabel sizeToFit];
        subtitleLabel.frame = CGRectMake(40, 20 + 2, subtitleLabel.width, subtitleLabel.height);
        
        [self addSubview:imageView];
        [self addSubview:titleLabel];
        [self addSubview:subtitleLabel];
        [self addSubview:_checkboxView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];        
    
    _checkboxView.frame = CGRectMake(self.frame.size.width - 5 - 30,5,30,30);
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_checkboxView);
    [super dealloc];
}

@end
