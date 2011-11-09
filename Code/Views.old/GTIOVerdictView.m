//
//  GTIOVotingResultSet.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/28/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOVerdictView.h"
#import "GTIOOutfitPageView.h"
#import "GTIORoundedBottomCornerLabel.h"

CGRect labelFrameFromButtonFrame(CGRect buttonFrame) {
	return CGRectMake(buttonFrame.origin.x+4, buttonFrame.origin.y+7, buttonFrame.size.width-8, 23);
}

@implementation GTIOVerdictView

@synthesize resultSet = _resultSet;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"verdict-background.png"]];
		self.opaque = NO;
		
		_verdictLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
		_verdictLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:_verdictLabel];
		_reasonLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
		_reasonLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:_reasonLabel];
		
		_wear1CountLabel = [[GTIORoundedBottomCornerLabel alloc] initWithFrame:CGRectZero];
		[self addSubview:_wear1CountLabel];
		
		_wear2CountLabel = [[GTIORoundedBottomCornerLabel alloc] initWithFrame:CGRectZero];
		[self addSubview:_wear2CountLabel];
		
		_wear3CountLabel = [[GTIORoundedBottomCornerLabel alloc] initWithFrame:CGRectZero];
		[self addSubview:_wear3CountLabel];
		
		_wear4CountLabel = [[GTIORoundedBottomCornerLabel alloc] initWithFrame:CGRectZero];
		[self addSubview:_wear4CountLabel];
		
		_changeItCountLabel = [[GTIORoundedBottomCornerLabel alloc] initWithFrame:CGRectZero];
		[self addSubview:_changeItCountLabel];
		
		for (UILabel* label in [NSArray arrayWithObjects:_wear1CountLabel, _wear2CountLabel, _wear3CountLabel, _wear4CountLabel, _changeItCountLabel, nil]) {
			label.backgroundColor = [UIColor clearColor];
			label.textColor = [UIColor lightGrayColor];
			label.textAlignment = UITextAlignmentRight;
			label.font = kGTIOFontBoldHelveticaNeueOfSize(18);
		}
		
		_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[_spinner setHidesWhenStopped:YES];
		[self addSubview:_spinner];
	}
	return self;
}

- (void)dealloc {
	[_resultSet release];
	_resultSet = nil;
	
	TT_RELEASE_SAFELY(_wear1CountLabel);
	TT_RELEASE_SAFELY(_wear2CountLabel);
	TT_RELEASE_SAFELY(_wear3CountLabel);
	TT_RELEASE_SAFELY(_wear4CountLabel);
	TT_RELEASE_SAFELY(_changeItCountLabel);
	TT_RELEASE_SAFELY(_verdictLabel);
	TT_RELEASE_SAFELY(_reasonLabel);
	TT_RELEASE_SAFELY(_spinner);

	[super dealloc];
}

- (void)highlightWinningLabel {
	if (_resultSet.winningOutfit && !_resultSet.isPending) {
		switch ([_resultSet.winningOutfit intValue]) {
			case 0:
				_changeItCountLabel.textColor = [UIColor whiteColor];
				break;
			case 1:
				_wear1CountLabel.textColor = [UIColor whiteColor];
				break;
			case 2:
				_wear2CountLabel.textColor = [UIColor whiteColor];
				break;
			case 3:
				_wear3CountLabel.textColor = [UIColor whiteColor];
				break;
			case 4:
				_wear4CountLabel.textColor = [UIColor whiteColor];
				break;
		}
	}
}

- (void)updateView {
	NSString* reason = nil;
	if ([_resultSet.reasons count] > 0) {
		reason = [[_resultSet.reasons objectAtIndex:0] valueForKey:@"reasonText"];
	}
	int winningOutfitId = [_resultSet.winningOutfit intValue];
	if (reason && !_resultSet.isPending && winningOutfitId == 0) {
		NSString* text = reason;
		CGSize size = [text sizeWithFont:TTSTYLEVAR(reasonTextFont)];
		NSString* html = [NSString stringWithFormat:@"<span class='reasonTextStyle'>%@</span>", reason];
		_reasonLabel.html = html;
		_reasonLabel.frame = CGRectMake(0, 0, size.width + (TTOSVersion() >= 3.2 ? 1 : 2), size.height);
	} else {
		_reasonLabel.text = nil;
	}
	
//	NSString* text = [NSString stringWithFormat:@"VERDICT %@", [_resultSet.verdict uppercaseString]];
//	CGSize size = [text sizeWithFont:TTSTYLEVAR(verdictLabelFont)];
    
	NSString* html = [NSString stringWithFormat:@"<span class='verdictLabelStyle'>VERDICT </span><span class='verdictTextStyle'>%@</span>", [_resultSet.verdict uppercaseString]];
	_verdictLabel.html = html;
    CGSize size = [html sizeWithFont:TTSTYLEVAR(verdictLabelFont)];
	_verdictLabel.frame = CGRectMake(0, 0, size.width+1, size.height);
	
	for (UILabel* label in [NSArray arrayWithObjects:_wear1CountLabel, _wear2CountLabel, _wear3CountLabel, _wear4CountLabel, _changeItCountLabel, nil]) {
		label.textColor = [UIColor lightGrayColor];
	}
	
	[self highlightWinningLabel];
	
	_wear1CountLabel.text = [NSString stringWithFormat:@"%@ ", _resultSet.wear1];
	_wear2CountLabel.text = [NSString stringWithFormat:@"%@ ", _resultSet.wear2];
	_wear3CountLabel.text = [NSString stringWithFormat:@"%@ ", _resultSet.wear3];
	_wear4CountLabel.text = [NSString stringWithFormat:@"%@ ", _resultSet.wear4];
	_changeItCountLabel.text = [NSString stringWithFormat:@"%@ ", _resultSet.wear0];
	
}

- (void)layoutSubviews {
	[super layoutSubviews];
	if (_resultSet.isPending || [_resultSet.winningOutfit intValue] == 0) {
		int top = 35;
		if (nil ==_reasonLabel.text) {
			top = 50;
		}
		_verdictLabel.frame = CGRectMake(self.width - _verdictLabel.width - 5, top, _verdictLabel.width, _verdictLabel.height);
		_reasonLabel.frame = CGRectMake(self.width - _reasonLabel.width - 5, 51, _reasonLabel.width, _verdictLabel.height);
	} else {
		_verdictLabel.frame = CGRectMake(5, 50, _verdictLabel.width, _verdictLabel.height);
	}
	
	_wear1CountLabel.frame = CGRectZero;
	_wear2CountLabel.frame = CGRectZero;
	_wear3CountLabel.frame = CGRectZero;
	_wear4CountLabel.frame = CGRectZero;
	_changeItCountLabel.frame = CGRectZero;
	switch ([_resultSet numberOfOutfits]) {
		case 1:
			_changeItCountLabel.frame = labelFrameFromButtonFrame(changeItFrame);
			_wear1CountLabel.frame = labelFrameFromButtonFrame(wear1of1Frame);
			break;
		case 2:
			_changeItCountLabel.frame = labelFrameFromButtonFrame(wearNoneFrame);
			_wear1CountLabel.frame = labelFrameFromButtonFrame(wear1of2Frame);
			_wear2CountLabel.frame = labelFrameFromButtonFrame(wear2of2Frame);
			break;
		case 3:
			_changeItCountLabel.frame = labelFrameFromButtonFrame(wearNoneFrame);
			_wear1CountLabel.frame = labelFrameFromButtonFrame(wear1of3Frame);
			_wear2CountLabel.frame = labelFrameFromButtonFrame(wear2of3Frame);
			_wear3CountLabel.frame = labelFrameFromButtonFrame(wear3of3Frame);
			break;
		case 4:
			_changeItCountLabel.frame = labelFrameFromButtonFrame(wearNoneFrame);
			_wear1CountLabel.frame = labelFrameFromButtonFrame(wear1of4Frame);
			_wear2CountLabel.frame = labelFrameFromButtonFrame(wear2of4Frame);
			_wear3CountLabel.frame = labelFrameFromButtonFrame(wear3of4Frame);
			_wear4CountLabel.frame = labelFrameFromButtonFrame(wear4of4Frame);
			break;
	}
	[_spinner sizeToFit];
	_spinner.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (void)setResultSet:(GTIOVotingResultSet*)set {
	[set retain];
	[_resultSet release];
	_resultSet = set;
	[self updateView];
	[self setNeedsLayout];
}

- (void)hideAllViews {
	_wear1CountLabel.alpha = 0;
	_wear2CountLabel.alpha = 0;
	_wear3CountLabel.alpha = 0;
	_wear4CountLabel.alpha = 0;
	_changeItCountLabel.alpha = 0;
	_verdictLabel.alpha = 0;
	_reasonLabel.alpha = 0;
	[_spinner startAnimating];
}

- (void)countUpFinished {
	[UIView beginAnimations:nil context:nil];
	[self highlightWinningLabel];
	_changeItCountLabel.alpha = 1;
	_verdictLabel.alpha = 1;
	_reasonLabel.alpha = 1;
	[UIView commitAnimations];
}

- (void)countUpTimerFired:(NSTimer*)timer {
	
	BOOL stillCounting = NO;
	NSInteger currentCount;
	
	currentCount = [_wear1CountLabel.text intValue];
	if (currentCount < [_resultSet.wear1 intValue]) {
		_wear1CountLabel.text = [NSString stringWithFormat:@"%d ", currentCount+1];
		stillCounting = YES;
	}
	currentCount = [_wear2CountLabel.text intValue];
	if (currentCount < [_resultSet.wear2 intValue]) {
		_wear2CountLabel.text = [NSString stringWithFormat:@"%d ", currentCount+1];
		stillCounting = YES;
	}
	currentCount = [_wear3CountLabel.text intValue];
	if (currentCount < [_resultSet.wear3 intValue]) {
		_wear3CountLabel.text = [NSString stringWithFormat:@"%d ", currentCount+1];
		stillCounting = YES;
	}
	currentCount = [_wear4CountLabel.text intValue];
	if (currentCount < [_resultSet.wear4 intValue]) {
		_wear4CountLabel.text = [NSString stringWithFormat:@"%d ", currentCount+1];
		stillCounting = YES;
	}
	currentCount = [_changeItCountLabel.text intValue];
	if (currentCount < [_resultSet.wear0 intValue]) {
		_changeItCountLabel.text = [NSString stringWithFormat:@"%d ", currentCount+1];
		stillCounting = YES;
	}
	if (!stillCounting) {
		[self countUpFinished];
		[timer invalidate];
	}
	
}

- (void)hideSpinnerAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	int maxVotes = MAX(50,_resultSet.winningVoteCount);//Set a minimum so that really low vote counts don't count really slowly.
	NSTimeInterval interval = 2.0 / maxVotes;
	[NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(countUpTimerFired:) userInfo:nil repeats:YES];
}

- (void)animateInData {
	[UIView beginAnimations:nil context:nil];
	[_spinner stopAnimating];
	
	for (UILabel* label in [NSArray arrayWithObjects:_wear1CountLabel, _wear2CountLabel, _wear3CountLabel, _wear4CountLabel, _changeItCountLabel, nil]) {
		label.textColor = [UIColor lightGrayColor];
		label.text = @"0 ";
		label.alpha = 1;
	}
	
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hideSpinnerAnimationDidStop:finished:context:)];
	[UIView commitAnimations];
}


@end
