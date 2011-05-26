//
//  GTIOVotingResultSet.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/28/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOVotingResultSet.h"

@interface GTIOVerdictView : UIView {
	UILabel* _wear1CountLabel;
	UILabel* _wear2CountLabel;
	UILabel* _wear3CountLabel;
	UILabel* _wear4CountLabel;
	UILabel* _changeItCountLabel;
	TTStyledTextLabel* _verdictLabel;
	TTStyledTextLabel* _reasonLabel;
	
	GTIOVotingResultSet* _resultSet;
	
	UIActivityIndicatorView* _spinner;
}

@property (nonatomic, retain) GTIOVotingResultSet *resultSet;

- (void)hideAllViews;
- (void)animateInData;

@end
