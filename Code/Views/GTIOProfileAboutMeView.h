//
//  GTIOAboutMeView.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/24/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

/** GTIOAboutMeView is a custom view that displays text with stylized quotes above and below
*/

@interface GTIOProfileAboutMeView : UIView {
	UILabel* _leftQuoteLabel;
	UILabel* _rightQuoteLabel;
	NSMutableArray* _textLabels;
	
	NSString* _text;
}

@property (nonatomic, copy) NSString *text;

@end
