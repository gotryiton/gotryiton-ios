//
//  GTIOMultiLineQuotedLabel.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/26/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOMultiLineQuotedLabel.h"


@implementation GTIOMultiLineQuotedLabel

@synthesize text = _text;

- (void)dealloc {
	[_text release];
	_text = nil;

	[super dealloc];
}

- (CGSize)calculateSizesAndDraw:(BOOL)draw inRect:(CGRect)rect {
    CGSize size;
    
    float lineHeight = 16;
    float xAlignment = 14;
	int maxLines = floor(rect.size.height/lineHeight);
	
	float maxWidth = rect.size.width - xAlignment - 10;
	UIFont* font = kGTIOFontHelveticaRBCOfSize(13);
	int initialTextOffset = (TTOSVersion() < 3.2 ? 2 : 5);
	
    if (draw) {
        [kGTIOColorBrightPink set];
        [@"“" drawAtPoint:CGPointMake(0,-5) withFont:[UIFont systemFontOfSize:37]];
    }
	NSString* textLeftToWrite = _text;
	for (int line = 0; line < maxLines; line++) {
		NSMutableArray* partsLeft = [NSMutableArray array];
		NSString* thisLine = textLeftToWrite;
		
		float maxWidthForLine = maxWidth-5;
        //(line+1 == maxLines ? maxWidth - 15 : maxWidth);
		
		while ([thisLine sizeWithFont:font].width > maxWidthForLine) {
			NSMutableArray* components = [[[thisLine componentsSeparatedByString:@" "] mutableCopy] autorelease];
			if ([components count] == 1) {
				NSMutableString* endPart = [NSMutableString string];
				while ([[NSString stringWithFormat:@"%@-", thisLine] sizeWithFont:font].width > maxWidthForLine) {
                    int index = [thisLine length] - 1;
					NSString* character = [thisLine substringFromIndex:index];
					[endPart insertString:character atIndex:0];
					thisLine = [thisLine substringToIndex:[thisLine length] - 1];
				}
				[partsLeft insertObject:endPart atIndex:0];
				thisLine = [NSString stringWithFormat:@"%@-", thisLine];
			} else {
				[partsLeft insertObject:[components lastObject] atIndex:0];
				[components removeLastObject];
				thisLine = [components componentsJoinedByString:@" "];
			}
			if (line + 1 == maxLines && [partsLeft count] > 0) {
				thisLine = [NSString stringWithFormat:@"%@...", thisLine];
			}
		}
		textLeftToWrite = [partsLeft componentsJoinedByString:@" "];
		
        if (draw) {
            [kGTIOColor6A6A6A set];
            [thisLine drawAtPoint:CGPointMake(xAlignment, initialTextOffset+line*lineHeight) withFont:font];
        }
		if (line + 1 == maxLines || [partsLeft count] == 0) {
   			CGSize s = [thisLine sizeWithFont:font];
            if (draw) {
                [kGTIOColorBrightPink set];
                [@"”" drawAtPoint:CGPointMake(xAlignment-2+s.width,line*lineHeight-5) withFont:[UIFont systemFontOfSize:37]];
            }
            CGSize quoteSize = [@"”" sizeWithFont:[UIFont systemFontOfSize:37]];
            size = CGSizeMake(xAlignment-2+s.width+quoteSize.width,line*lineHeight+lineHeight);
			break;
		}
	}
    return size;
}

- (CGSize)approximateSizeConstrainedTo:(CGSize)maxSize {
	CGRect rect = CGRectMake(0, 0, maxSize.width, maxSize.height);
	return [self calculateSizesAndDraw:NO inRect:rect];
}

- (void)drawRect:(CGRect)rect {
	[self calculateSizesAndDraw:YES inRect:rect];
}

@end
