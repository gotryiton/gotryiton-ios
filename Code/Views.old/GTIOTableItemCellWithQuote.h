//
//  GTIOTableItemCellWithQuote.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/18/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOTableItemCellWithQuote is a subclass of [GTIOTableOutfitImageCell](GTIOTableOutfitImageCell) provides for a quote to be displayed in it with the stylized quotation marks
#import <Foundation/Foundation.h>
#import "GTIOTableOutfitImageCell.h"

@interface GTIOTableItemCellWithQuote : GTIOTableOutfitImageCell {
	UILabel* _leftQuoteLabel;
	UILabel* _rightQuoteLabel;
	UILabel* _quotedLabel;
	UILabel* _line2Label;
	NSString* _quote;
}
/// NSString quote
@property (nonatomic, copy) NSString *quote;
/// Called to layout the quote
- (void)layoutQuote;

@end
