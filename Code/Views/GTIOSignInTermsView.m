//
//  GTIOSignInTermsView.m
//  GTIO
//
//  Created by Daniel Hammond on 5/17/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOSignInTermsView.h"

static NSString* kGTIOTermsURL = @"http://m.gtio.com/terms";
static NSString* kGTIOPrivacyURL = @"http://m.gtio.com/privacy";
static NSString* kGTIOLegalURL = @"http://m.gtio.com/legal";
static NSString* kGTIOStandardsURL = @"http://m.gtio.com/standards";

@interface TTTAttributedLabel (Private)
- (NSTextCheckingResult*)linkAtPoint:(CGPoint)p;
@end

@implementation GTIOSignInTermsView

- (CGSize)sizeThatFits {
	return CGSizeMake(280,100);
}

+ (id)termsView {
	NSString* text = @"by continuing you agree to our terms and conditions of";
    NSString* text2 = @"use, privacy policy, legal terms, and community standards.";
	NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableAttributedString* attributedText2 = [[NSMutableAttributedString alloc] initWithString:text2];
	
	UIColor* normal = [UIColor colorWithRed:.243 green:.243 blue:.243 alpha:1];
	UIColor* highlight = [UIColor colorWithRed:1 green:0 blue:.588 alpha:1];
	
	[attributedText setTextColor:normal range:NSMakeRange(0, attributedText.length)];
	[attributedText setFont:[UIFont boldSystemFontOfSize:10]];
	[attributedText setTextAlignment:kCTCenterTextAlignment lineBreakMode:kCTLineBreakByWordWrapping];
    
    [attributedText2 setTextColor:normal range:NSMakeRange(0, attributedText2.length)];
	[attributedText2 setFont:[UIFont boldSystemFontOfSize:10]];
	[attributedText2 setTextAlignment:kCTCenterTextAlignment lineBreakMode:kCTLineBreakByWordWrapping];
	
    UIView* view = [[[UIView alloc] initWithFrame:CGRectMake(20, 115, 280, 100)] autorelease];
    
    GTIOSignInTermsView* termsLabel = [[self new] autorelease];
	[termsLabel setFrame:CGRectMake(0, 0, 280, 20)];
	[termsLabel setBackgroundColor:[UIColor clearColor]];
	[termsLabel setNumberOfLines:0];
	[termsLabel setText:attributedText];
    
    GTIOSignInTermsView* termsLabel2 = [[self new] autorelease];
	[termsLabel2 setFrame:CGRectMake(0, 14, 280, 20)];
	[termsLabel2 setBackgroundColor:[UIColor clearColor]];
	[termsLabel2 setNumberOfLines:0];
	[termsLabel2 setText:attributedText2];
    
    NSMutableDictionary* dict = [[termsLabel.linkAttributes mutableCopy] autorelease];
    [dict setValue:(id)highlight.CGColor forKey:(NSString*)kCTForegroundColorAttributeName];
    termsLabel.linkAttributes = dict;
    
    NSMutableDictionary* dict2 = [[termsLabel2.linkAttributes mutableCopy] autorelease];
    [dict2 setValue:(id)highlight.CGColor forKey:(NSString*)kCTForegroundColorAttributeName];
    termsLabel2.linkAttributes = dict2;
    
    [termsLabel addLinkToURL:[NSURL URLWithString:kGTIOTermsURL] withRange:NSMakeRange(31, 20)];
    [termsLabel2 addLinkToURL:[NSURL URLWithString:kGTIOPrivacyURL] withRange:NSMakeRange(5, 14)];
    [termsLabel2 addLinkToURL:[NSURL URLWithString:kGTIOLegalURL] withRange:NSMakeRange(21, 11)];
    [termsLabel2 addLinkToURL:[NSURL URLWithString:kGTIOStandardsURL] withRange:NSMakeRange(38, 19)];
    termsLabel.userInteractionEnabled = YES;
    termsLabel2.userInteractionEnabled = YES;
    
    [view addSubview:termsLabel];
    [view addSubview:termsLabel2];
    
	return view;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];	
	NSTextCheckingResult *result = [self linkAtPoint:[touch locationInView:self]];
    
    if (result) {
        NSLog(@"Opening: %@", [result.URL absoluteString]);
        TTOpenURL([result.URL absoluteString]);
    }
}

@end
