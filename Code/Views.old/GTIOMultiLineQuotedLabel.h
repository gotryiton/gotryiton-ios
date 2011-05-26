//
//  GTIOMultiLineQuotedLabel.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/26/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GTIOMultiLineQuotedLabel : UIView {
	NSString* _text;
}

@property (nonatomic, copy) NSString *text;

- (CGSize)approximateSizeConstrainedTo:(CGSize)maxSize;

@end
