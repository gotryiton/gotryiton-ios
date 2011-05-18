//
//  GTIOTableItemCellWithQuote.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOTableItemCellWithQuote.h"

static float const totalWidth = 198;
static float const leftEdge = 100;
static CGRect const maxFrame = {{100,10},{198,30}};
static float leftQuoteInsetWidth = 4;

@implementation GTIOTableItemCellWithQuote

@synthesize quote = _quote;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
		
		_leftQuoteLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_leftQuoteLabel.backgroundColor = [UIColor clearColor];
		_leftQuoteLabel.font = [UIFont systemFontOfSize:30];
		_leftQuoteLabel.textColor = kGTIOColorBrightPink;
		_leftQuoteLabel.text = @"“";
        
		_rightQuoteLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_rightQuoteLabel.backgroundColor = [UIColor clearColor];
		_rightQuoteLabel.font = [UIFont systemFontOfSize:30];
		_rightQuoteLabel.textColor = kGTIOColorBrightPink;
		_rightQuoteLabel.text = @"”";
		
		_quotedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_quotedLabel.backgroundColor = [UIColor clearColor];
		_quotedLabel.font = kGTIOFontHelveticaRBCOfSize(13.5);
		_quotedLabel.textColor = kGTIOColor9A9A9A;
		
		_line2Label = [[UILabel alloc] initWithFrame:CGRectZero];
		_line2Label.backgroundColor = [UIColor clearColor];
		_line2Label.font = kGTIOFontHelveticaRBCOfSize(13.5);
		_line2Label.textColor = kGTIOColor9A9A9A;
		
		[[self contentView] addSubview:_leftQuoteLabel];
		[[self contentView] addSubview:_rightQuoteLabel];
		[[self contentView] addSubview:_quotedLabel];
		[[self contentView] addSubview:_line2Label];
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_leftQuoteLabel);
	TT_RELEASE_SAFELY(_rightQuoteLabel);
	TT_RELEASE_SAFELY(_quotedLabel);
	TT_RELEASE_SAFELY(_line2Label);
	[_quote release];
	_quote = nil;

	[super dealloc];
}

- (CGSize)sizeOfText:(NSString*)text {
	return [text sizeWithFont:kGTIOFontHelveticaRBCOfSize(13.5) constrainedToSize:maxFrame.size lineBreakMode:UILineBreakModeWordWrap];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSString* text = [_quote stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([text length] > 0) {
        [self layoutQuote];
    }
}

- (void)layoutQuote {
	[_leftQuoteLabel sizeToFit];
	[_rightQuoteLabel sizeToFit];
	NSLog(@"Quote: %@", _quote);
	
	_quotedLabel.text = [_quote stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	CGSize size = [self sizeOfText:_quotedLabel.text];
	
	float widthInset = floor((totalWidth - size.width - 5)/2);
	if (size.height < 20) {
		// 1 line
		float maxWidth = totalWidth-2*widthInset;
		CGSize size = [_quotedLabel sizeThatFits:CGSizeMake(maxWidth, 17)];
		_quotedLabel.frame = CGRectMake(leftEdge+_leftQuoteLabel.frame.size.width-leftQuoteInsetWidth, 20, size.width, 17);
		_line2Label.frame = CGRectZero;
		_leftQuoteLabel.frame = CGRectMake(leftEdge-leftQuoteInsetWidth, 11, _leftQuoteLabel.frame.size.width, _leftQuoteLabel.frame.size.height);
		_rightQuoteLabel.frame = CGRectMake(_quotedLabel.frame.origin.x + _quotedLabel.frame.size.width, 11, _rightQuoteLabel.frame.size.width, _rightQuoteLabel.frame.size.height);
	} else {
		NSString* line1Text = _quotedLabel.text;
		NSMutableArray* line2Parts = [NSMutableArray array];
		while ([self sizeOfText:line1Text].height > 20) {
			NSMutableArray* parts = [[[line1Text componentsSeparatedByString:@" "] mutableCopy] autorelease];
			[line2Parts insertObject:[parts lastObject] atIndex:0];
			[parts removeLastObject];
			line1Text = [parts componentsJoinedByString:@" "];
		}
		_quotedLabel.text = line1Text;
		NSString* line2 = [line2Parts componentsJoinedByString:@" "];
		while([self sizeOfText:line2].height > 20) {
			[line2Parts removeLastObject];
			
			line2 = [line2Parts componentsJoinedByString:@" "];
			if (![line2 isWhitespaceAndNewlines]) {
				line2 = [line2 stringByAppendingFormat:@"..."];
			}
		}
		if ([line2 isWhitespaceAndNewlines]) {
			self.quote = [line1Text stringByAppendingFormat:@"..."];
			[self layoutQuote];
            return;
		}
		_line2Label.text = [line2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		
		CGSize line1Size = [self sizeOfText:_quotedLabel.text];
		_quotedLabel.frame = CGRectMake(leftEdge+_leftQuoteLabel.frame.size.width-leftQuoteInsetWidth, 15, line1Size.width, 17);
		
		CGSize line2Size = [self sizeOfText:_line2Label.text];
		_line2Label.frame = CGRectMake(leftEdge, 30, line2Size.width, 17);
		
		_leftQuoteLabel.frame = CGRectMake(leftEdge-leftQuoteInsetWidth, 7, _leftQuoteLabel.frame.size.width, _leftQuoteLabel.frame.size.height);
		_rightQuoteLabel.frame = CGRectMake(_line2Label.frame.origin.x + _line2Label.frame.size.width -3,
											_line2Label.frame.origin.y - 8,
											_rightQuoteLabel.frame.size.width,
											_rightQuoteLabel.frame.size.height);   
	}
}

@end
