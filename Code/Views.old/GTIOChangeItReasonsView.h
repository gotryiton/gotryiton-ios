//
//  GTIOChangeItReasonsView.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/31/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOChangeItReasonsView is a subclass of [UIImageView](UIImageView) used by [GTIOOutfitPageView](GTIOOutfitPageView) 
/// as a control that allows users to pick reasons for their "change it" vote

#import <UIKit/UIKit.h>


@interface GTIOChangeItReasonsView : UIImageView {
	UILabel* _headerLabel;
	NSMutableArray* _backgrounds;
	NSMutableArray* _labels;
	NSMutableArray* _buttons;
	UIButton* _doneOrNextButton;
	UIButton* _writeAReviewButton;
}

- (NSArray*)selectedChangeItReasons;
- (void)resetChangeItSelections;

@end
