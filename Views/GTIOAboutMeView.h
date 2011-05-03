//
//  GTIOAboutMeView.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>


@interface GTIOAboutMeView : UIView {
	UILabel* _leftQuoteLabel;
	UILabel* _rightQuoteLabel;
	NSMutableArray* _textLabels;
	
	NSString* _text;
}

@property (nonatomic, copy) NSString *text;

@end
