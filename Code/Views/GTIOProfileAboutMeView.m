//
//  GTIOAboutMeView.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOProfileAboutMeView.h"
#import <UIKit/UIStringDrawing.h>

static float const lineLeftOffset = 10;
static float const quoteVerticalOffset = -2;
static float const quoteLeftOffset = -2;
static float const qFontSize = 42;

@implementation GTIOProfileAboutMeView

@synthesize text = _text;

- (CGSize)sizeThatFits:(CGSize)size {
	UIFont* font = [UIFont boldSystemFontOfSize:13];
	UIFont* qFont = [UIFont systemFontOfSize:qFontSize];
	NSString* lQuoteText = @"“";
	NSString* rQuoteText = @"”";
	CGSize lSize = [lQuoteText sizeWithFont:qFont];
	CGSize rSize = [rQuoteText sizeWithFont:qFont];
//	CGRect lQuoteRect = CGRectMake(0, 0, lSize.width, lSize.height);
	
	
	float rQuoteHorizontalOffset = quoteVerticalOffset*2 - 2;
	
	float line1LeftOffset = lSize.width - 6 + quoteLeftOffset;
	float line1MaxWidth = 320 - line1LeftOffset - rSize.width + rQuoteHorizontalOffset;
	float lineVerticalOffset = 8;
	float rQuoteOffset = 0;
	
	CGSize line1Size = [_text sizeWithFont:font];
	float lineHeight = line1Size.height;
	
	NSMutableArray* wordsNotInLine1 = [NSMutableArray array];
	NSString* line1Text = _text;
	
	NSMutableArray* lines = [[line1Text componentsSeparatedByString:@"\n"] mutableCopy];
	line1Text = [lines objectAtIndex:0];
	[lines removeObjectAtIndex:0];
	
    NSString* obj = [lines componentsJoinedByString:@"\n"];
    if (obj) {
        [wordsNotInLine1 addObject:obj];
    }
	[lines release];
	
	while (line1Size.width > line1MaxWidth) {
		NSMutableArray* parts = [[[line1Text componentsSeparatedByString:@" "] mutableCopy] autorelease];
		NSString* lastPart = [parts lastObject];
		[parts removeLastObject];
		line1Text = [parts componentsJoinedByString:@" "];
		[wordsNotInLine1 insertObject:lastPart atIndex:0];
		line1Size = [line1Text sizeWithFont:font];
	}
	
	float rQuoteLeftPosition = line1LeftOffset + line1Size.width + rQuoteHorizontalOffset;
	
	if ([wordsNotInLine1 count] > 0) {
		
		NSString* currentLine = [wordsNotInLine1 componentsJoinedByString:@" "];
		
		NSMutableArray* lines = [[currentLine componentsSeparatedByString:@"\n"] mutableCopy];
		currentLine = [lines objectAtIndex:0];
		
		[lines removeObjectAtIndex:0];
		NSMutableArray* wordsNotInCurrentLine = [NSMutableArray array];
        NSString* obj = [lines componentsJoinedByString:@"\n"];
        if (obj) {
            [wordsNotInCurrentLine addObject:obj];
        }
		[lines release];
		
		float maxWidth = 320 - rSize.width - lineLeftOffset;
		
		while (![currentLine isWhitespaceAndNewlines]) {
			rQuoteOffset += lineHeight;
			lineVerticalOffset += lineHeight;
			CGSize lineSize = [currentLine sizeWithFont:font];
			while (lineSize.width > maxWidth) {
				NSMutableArray* parts = [[[currentLine componentsSeparatedByString:@" "] mutableCopy] autorelease];
				NSString* lastPart = [parts lastObject];
				[parts removeLastObject];
				currentLine = [parts componentsJoinedByString:@" "];
				[wordsNotInCurrentLine insertObject:lastPart atIndex:0];
				lineSize = [currentLine sizeWithFont:font];
			}
			lineSize = [currentLine sizeWithFont:font]; // Not sure why i have to set this here and at the end of the loop...
			
			rQuoteLeftPosition = lineLeftOffset + lineSize.width + rQuoteHorizontalOffset;
			currentLine = [wordsNotInCurrentLine componentsJoinedByString:@" "];
			[wordsNotInCurrentLine removeAllObjects];
		}
	}
	
	
//	CGRect rQuoteRect = CGRectMake(rQuoteLeftPosition, rQuoteOffset, rSize.width, rSize.height);
	
	
	return CGSizeMake(size.width, lineVerticalOffset + lineHeight + 10);
}

- (void)drawRect:(CGRect)rect {
	if (nil == _text) {
		return;
	}
	
	UIImage* bg = [[UIImage imageNamed:@"dark-bottom.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:1];
	[bg drawInRect:rect];
    
	UIFont* font = [UIFont boldSystemFontOfSize:13];
	UIFont* qFont = [UIFont systemFontOfSize:qFontSize];
	NSString* lQuoteText = @"“";
	NSString* rQuoteText = @"”";
	CGSize lSize = [lQuoteText sizeWithFont:qFont];
	CGSize rSize = [rQuoteText sizeWithFont:qFont];
	CGRect lQuoteRect = CGRectMake(quoteLeftOffset-1, quoteVerticalOffset-1, lSize.width, lSize.height);
	
	[[UIColor whiteColor] set];
	[lQuoteText drawInRect:lQuoteRect withFont:qFont];
	
	float rQuoteHorizontalOffset = quoteVerticalOffset*2 - 2;
	
	float line1LeftOffset = lSize.width - 6 + quoteLeftOffset;
	float line1MaxWidth = 320 - line1LeftOffset - rSize.width + rQuoteHorizontalOffset;
	float lineVerticalOffset = 8;
	float rQuoteOffset = quoteVerticalOffset;
	
	CGSize line1Size = [_text sizeWithFont:font];
	float lineHeight = line1Size.height;
	
	NSMutableArray* wordsNotInLine1 = [NSMutableArray array];
	NSString* line1Text = _text;
	
	NSMutableArray* lines = [[line1Text componentsSeparatedByString:@"\n"] mutableCopy];
	line1Text = [lines objectAtIndex:0];
	[lines removeObjectAtIndex:0];
	
	NSString* obj = [lines componentsJoinedByString:@"\n"];
	if (obj) {
		[wordsNotInLine1 addObject:obj];
	}
	[lines release];
	
	while (line1Size.width > line1MaxWidth) {
		NSMutableArray* parts = [[[line1Text componentsSeparatedByString:@" "] mutableCopy] autorelease];
		NSString* lastPart = [parts lastObject];
		[parts removeLastObject];
		line1Text = [parts componentsJoinedByString:@" "];
		[wordsNotInLine1 insertObject:lastPart atIndex:0];
		line1Size = [line1Text sizeWithFont:font];
	}
	
	[[UIColor darkGrayColor] set];
	
	NSString* lastLineString = line1Text;
	CGRect lastLineRect = CGRectMake(line1LeftOffset, lineVerticalOffset, line1Size.width, line1Size.height);
	
	if ([wordsNotInLine1 count] > 0) {
		// We draw the last line after we draw the quote, so it draws at the top.
		NSString* nextLine = [wordsNotInLine1 componentsJoinedByString:@" "];
		if (![nextLine isWhitespaceAndNewlines]){
			[line1Text drawInRect:lastLineRect withFont:font];
		}
	}
	float rQuoteLeftPosition = line1LeftOffset + line1Size.width + rQuoteHorizontalOffset;
	
	if ([wordsNotInLine1 count] > 0) {
		
		NSString* currentLine = [wordsNotInLine1 componentsJoinedByString:@" "];
		
		NSMutableArray* lines = [[currentLine componentsSeparatedByString:@"\n"] mutableCopy];
		currentLine = [lines objectAtIndex:0];
		
		[lines removeObjectAtIndex:0];
		NSMutableArray* wordsNotInCurrentLine = [NSMutableArray array];
        
		NSString* obj = [lines componentsJoinedByString:@"\n"];
		if (obj) {
			[wordsNotInCurrentLine addObject:obj];
		}
		[lines release];
		
		float maxWidth = 320 - rSize.width - lineLeftOffset;
		
		while (![currentLine isWhitespaceAndNewlines]) {
			rQuoteOffset += lineHeight;
			lineVerticalOffset += lineHeight;
			CGSize lineSize = [currentLine sizeWithFont:font];
			while (lineSize.width > maxWidth) {
				NSMutableArray* parts = [[[currentLine componentsSeparatedByString:@" "] mutableCopy] autorelease];
				NSString* lastPart = [parts lastObject];
				[parts removeLastObject];
				currentLine = [parts componentsJoinedByString:@" "];
				[wordsNotInCurrentLine insertObject:lastPart atIndex:0];
				lineSize = [currentLine sizeWithFont:font];
			}
			lineSize = [currentLine sizeWithFont:font]; // Not sure why i have to set this here and at the end of the loop...
			rQuoteLeftPosition = lineLeftOffset + lineSize.width + rQuoteHorizontalOffset;
			lastLineRect = CGRectMake(lineLeftOffset, lineVerticalOffset, lineSize.width, lineSize.height);
			lastLineString = currentLine;
			if ([wordsNotInCurrentLine count] > 0) {
				// We draw the last line after we draw the quote, so it draws at the top.
				[currentLine drawInRect:lastLineRect withFont:font];
			}
			currentLine = [wordsNotInCurrentLine componentsJoinedByString:@" "];
			[wordsNotInCurrentLine removeAllObjects];
		}
	}
	
	CGRect rQuoteRect = CGRectMake(rQuoteLeftPosition+1, rQuoteOffset-1, rSize.width, rSize.height);
	[[UIColor whiteColor] set];
	[rQuoteText drawInRect:rQuoteRect withFont:qFont];
	
	[[UIColor darkGrayColor] set];
	[lastLineString drawInRect:lastLineRect withFont:font];
}

@end
