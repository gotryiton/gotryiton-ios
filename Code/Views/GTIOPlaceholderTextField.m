//
//  GTIOPlaceholderTextField.m
//  GTIO
//
//  Created by Jeremy Ellison on 9/1/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOPlaceholderTextField.h"


@implementation GTIOPlaceholderTextField

@synthesize customPlaceholderLabel = _customPlaceholderLabel;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _customPlaceholderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0,0,320,20)] autorelease];
        _customPlaceholderLabel.textAlignment = UITextAlignmentRight;
        _customPlaceholderLabel.textColor = [UIColor lightGrayColor];
        _customPlaceholderLabel.backgroundColor = [UIColor clearColor];
        _customPlaceholderLabel.font = [UIFont italicSystemFontOfSize:14];
        _customPlaceholderLabel.numberOfLines = 1;
        self.placeholder = @" ";// causes the frame never to be set to a 0 height;
        [self addSubview:_customPlaceholderLabel];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:self];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)textChanged:(NSNotification*)note {
    NSString* newString = self.text;
    if ([newString length] == 0 ) {
        _customPlaceholderLabel.alpha = 1;
    } else {
        _customPlaceholderLabel.alpha = 0;
    }
}

- (void)setCustomPlaceholder:(NSString*)placeholder {
    _customPlaceholderLabel.text = placeholder;
}

- (NSString*)customPlaceholder {
    return _customPlaceholderLabel.text;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _customPlaceholderLabel.frame = self.bounds;
}

- (void)setText:(NSString*)text {
    if ([text length] == 0 ) {
        _customPlaceholderLabel.alpha = 1;
    } else {
        _customPlaceholderLabel.alpha = 0;
    }
    [super setText:text];
}

@end


@implementation GTIOPlaceholderTextView

@synthesize customPlaceholderLabel = _customPlaceholderLabel;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _customPlaceholderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0,0,320,20)] autorelease];
        _customPlaceholderLabel.textColor = [UIColor lightGrayColor];
        _customPlaceholderLabel.font = [UIFont italicSystemFontOfSize:14];
        _customPlaceholderLabel.numberOfLines = 1;
        [self addSubview:_customPlaceholderLabel];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)textChanged:(NSNotification*)note {
    NSString* newString = self.text;
    if ([newString length] == 0 ) {
        _customPlaceholderLabel.alpha = 1;
    } else {
        _customPlaceholderLabel.alpha = 0;
    }
}

- (void)setCustomPlaceholder:(NSString*)placeholder {
    _customPlaceholderLabel.text = placeholder;
}

- (NSString*)customPlaceholder {
    return _customPlaceholderLabel.text;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _customPlaceholderLabel.frame = CGRectMake(5,5,self.bounds.size.width-10, 20);
}

- (void)setText:(NSString*)text {
    if ([text length] == 0 ) {
        _customPlaceholderLabel.alpha = 1;
    } else {
        _customPlaceholderLabel.alpha = 0;
    }
    [super setText:text];
}

@end