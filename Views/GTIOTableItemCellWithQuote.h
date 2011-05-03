//
//  GTIOTableItemCellWithQuote.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOTableOutfitImageCell.h"

@interface GTIOTableItemCellWithQuote : GTIOTableOutfitImageCell {
	UILabel* _leftQuoteLabel;
	UILabel* _rightQuoteLabel;
	UILabel* _quotedLabel;
	UILabel* _line2Label;
	NSString* _quote;
}

@property (nonatomic, copy) NSString *quote;

- (void)layoutQuote;

@end
