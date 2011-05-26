//
//  GTIOOutfitTopControlsView.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/25/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOOutfit.h"
#import "GTIOMultiLineQuotedLabel.h"
#import <RestKit/RestKit.h>

@interface GTIOOutfitTopControlsView : UIView <TTTextEditorDelegate, RKObjectLoaderDelegate> {
	GTIOOutfit* _outfit;
	UIImageView* _descriptionView;
	GTIOMultiLineQuotedLabel* _descriptionText;
	GTIOMultiLineQuotedLabel* _descriptionTextSmall;
	UIButton* _reviewsButtonSmall;
	UIButton* _toolsButton;
	UIButton* _shareButton;
	UILabel* _forLabel;
	UILabel* _forTextLabel;
	TTTextEditor* _reviewTextArea;
	UIImageView* _reviewTextAreaBackground;
	UILabel* _placeholderLabel;
	
	UIImageView* _expandArrow;
	
	BOOL _full;
}

@property (nonatomic, retain) GTIOOutfit *outfit;
- (void)showFullDescription:(BOOL)full;

@end
