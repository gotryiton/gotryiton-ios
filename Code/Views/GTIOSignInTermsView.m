//
//  GTIOSignInTermsView.m
//  GTIO
//
//  Created by Daniel Hammond on 5/17/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOSignInTermsView.h"
#import "TTTAttributedLabel.h"
#import "NSAttributedString+Attributes.h"

@implementation GTIOSignInTermsView

- (CGSize)sizeThatFits {
	return CGSizeMake(280,100);
}

+ (id)termsView {
	NSString* text = @"by continuing you agree to our terms and conditions of use, privacy policy, legal terms, and community standards.";
	NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc] initWithString:text];
	
	UIColor* normal = [UIColor colorWithRed:.243 green:.243 blue:.243 alpha:1];
	UIColor* highlight = [UIColor colorWithRed:1 green:0 blue:.588 alpha:1];
	
	[attributedText setTextColor:normal range:NSMakeRange(0, attributedText.length)];
	[attributedText setTextColor:highlight range:NSMakeRange(31, 20)];
	[attributedText setTextColor:highlight range:NSMakeRange(60, 14)];
	[attributedText setTextColor:highlight range:NSMakeRange(76, 11)];
	[attributedText setTextColor:highlight range:NSMakeRange(93, 19)];
	[attributedText setTextIsUnderlined:YES range:NSMakeRange(31, 20)];		
	[attributedText setTextIsUnderlined:YES range:NSMakeRange(60, 14)];		
	[attributedText setTextIsUnderlined:YES range:NSMakeRange(76, 11)];		
	[attributedText setTextIsUnderlined:YES range:NSMakeRange(93, 19)];
	[attributedText setFont:[UIFont boldSystemFontOfSize:9]];
	[attributedText setTextAlignment:kCTCenterTextAlignment lineBreakMode:kCTLineBreakByWordWrapping];
	
	TTTAttributedLabel* termsLabel = [[TTTAttributedLabel new] autorelease];
	[termsLabel setFrame:CGRectMake(20, 115, 280, 100)];
	[termsLabel setBackgroundColor:[UIColor clearColor]];
	[termsLabel setNumberOfLines:2];
	[termsLabel setText:attributedText];
	return termsLabel;
}

@end
