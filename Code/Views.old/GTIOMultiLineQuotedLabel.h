//
//  GTIOMultiLineQuotedLabel.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/26/11.
//  Copyright 2011 Two Toasters. All rights reserved.
/// GTIOMultiLineQuotedLabel is a subview of the [GTIOOutfitTopControlsView](GTIOOutfitTopControlsView)

#import <Foundation/Foundation.h>


@interface GTIOMultiLineQuotedLabel : UIView {
	NSString* _text;
}

@property (nonatomic, copy) NSString *text;
/// Returns the size of the label given an approximate constraining size
- (CGSize)approximateSizeConstrainedTo:(CGSize)maxSize;

@end
