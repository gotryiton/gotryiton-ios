//
//  GTIOChangeItReasonsView.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/31/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

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
