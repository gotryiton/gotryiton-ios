//
//  GTIOBlurringToolbarView.h
//  GoTryItOn
//
//  Created by Blake Watters on 9/23/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * This view implements a translucent toolbar that overlays
 * the image view during blurring. This contains a pair of
 * buttons and some instruction text.
 */
@interface GTIOBlurringToolbarView : UIView {
	UIButton* _keepButton;
	UIButton* _removeButton;
}

@property (nonatomic, readonly) UIButton* keepButton;
@property (nonatomic, readonly) UIButton* removeButton;

@end
