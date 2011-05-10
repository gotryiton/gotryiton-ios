//
//  GTIOChangeItReasonsView.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOChangeItReasonsView.h"
#import "GTIOGlobalVariableStore.h"
#import "GTIOChangeItReason.h"

@implementation GTIOChangeItReasonsView

- (id)initWithImage:(UIImage *)image {
	if (self = [super initWithImage:image]) {
		_headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_headerLabel.font = kGTIOFontBoldHelveticaNeueOfSize(15);
		_headerLabel.textColor = kGTIOColorBrightPink;
		_headerLabel.text = @"wait! why should I change this?";
		_headerLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:_headerLabel];
		
		_backgrounds = [[NSMutableArray array] retain];
		_labels = [[NSMutableArray array] retain];
		_buttons = [[NSMutableArray array] retain];
		NSArray* reasons = [GTIOGlobalVariableStore sharedStore].changeItReasons;
		
		int i = 0;
		for (GTIOChangeItReason* reason in reasons) {
			UIView* backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
			if (i % 2 == 0) {
				backgroundView.backgroundColor = [UIColor clearColor];
			} else {
				backgroundView.backgroundColor = RGBACOLOR(0,0,0,0.05);
			}
			UILabel* reasonLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
			reasonLabel.backgroundColor = [UIColor clearColor];
			reasonLabel.textColor = kGTIOColor9A9A9A;
			//reasonLabel.textColor = kGTIOColor5A5A5A;
			reasonLabel.font = kGTIOFontHelveticaNeueOfSize(15);
			reasonLabel.text = reason.text;
			reasonLabel.textAlignment = UITextAlignmentRight;
			[backgroundView addSubview:reasonLabel];
			
			UIButton* checkbox = [UIButton buttonWithType:UIButtonTypeCustom];
			[checkbox setImage:[UIImage imageNamed:@"change-selection-off.png"] forState:UIControlStateNormal];
			[checkbox setImage:[UIImage imageNamed:@"change-selection-on.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
			[checkbox setImage:[UIImage imageNamed:@"change-selection-off.png"] forState:UIControlStateHighlighted];
			[checkbox setImage:[UIImage imageNamed:@"change-selection-on.png"] forState:UIControlStateSelected];
			[checkbox addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
			[backgroundView addSubview:checkbox];
			
			[self addSubview:backgroundView];
			
			[_buttons addObject:checkbox];
			[_labels addObject:reasonLabel];
			[_backgrounds addObject:backgroundView];
			i++;
		}
		
		_doneOrNextButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[_doneOrNextButton setBackgroundImage:[UIImage imageNamed:@"change-done-bg.png"] forState:UIControlStateNormal];
		[_doneOrNextButton setTitle:@"skip" forState:UIControlStateNormal];
		[_doneOrNextButton addTarget:nil action:@selector(doneOrNextButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
		[_doneOrNextButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 54, 0, 0)];
		[_doneOrNextButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		_doneOrNextButton.titleLabel.font = [UIFont systemFontOfSize:15];
		[self addSubview:_doneOrNextButton];
		
		_writeAReviewButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[_writeAReviewButton setBackgroundImage:[UIImage imageNamed:@"change-review-bg.png"] forState:UIControlStateNormal];
		[_writeAReviewButton setTitle:@"write a review" forState:UIControlStateNormal];
		[_writeAReviewButton addTarget:nil action:@selector(writeAReviewButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
		[_writeAReviewButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
		[_writeAReviewButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		_writeAReviewButton.titleLabel.font = [UIFont systemFontOfSize:12];
		[self addSubview:_writeAReviewButton];
	}
	return self;
}

- (void)dealloc {
	[_headerLabel release];
	[_buttons release];
	[_labels release];
	[_backgrounds release];
	[_doneOrNextButton release];
	[_writeAReviewButton release];
	[super dealloc];
}

- (void)resetChangeItSelections {
    for (int i = 0; i < [_buttons count]; i++) {
		UIButton* button = [_buttons objectAtIndex:i];
        UILabel* reasonLabel = [_labels objectAtIndex:i];
        button.selected = NO;
        reasonLabel.textColor = kGTIOColor9A9A9A;
        
        [_doneOrNextButton setTitle:@"skip" forState:UIControlStateNormal];
	}
}

- (NSArray*)changeItReasons {
	return [GTIOGlobalVariableStore sharedStore].changeItReasons;
}

- (NSArray*)selectedChangeItReasons {
	NSMutableArray* reasons = [NSMutableArray array];
	for (int i = 0; i < [_buttons count]; i++) {
		UIButton* button = [_buttons objectAtIndex:i];
		GTIOChangeItReason* reason = [[self changeItReasons] objectAtIndex:i];
		if (button.selected) {
			NSNumber* index = reason.reasonID;
			[reasons addObject:index];
		}
	}
	return reasons;
}

- (void)toggle:(UIButton*)sender {
	int index = [_buttons indexOfObject:sender];
	sender.selected = !sender.selected;
	
	UILabel* reasonLabel = [_labels objectAtIndex:index];
	if (sender.selected) {
		reasonLabel.textColor = kGTIOColor5A5A5A;
	} else {
		reasonLabel.textColor = kGTIOColor9A9A9A;
	}
	
	BOOL any = NO;
	for (UIButton* button in _buttons) {
		if (button.selected) {
			any = YES;
			break;
		}
	}
	[_doneOrNextButton setTitle:(any ? @"done" : @"skip") forState:UIControlStateNormal];
	
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[_headerLabel sizeToFit];
	_headerLabel.frame = CGRectOffset(_headerLabel.bounds, 10+9, 10-3+5);
	float offset = 50.0;
	float lineheight = 36.0;
	for (int i = 0; i < [_backgrounds count]; i++) {
		UIView* backgroundView = [_backgrounds objectAtIndex:i];
		UILabel* reasonLabel = [_labels objectAtIndex:i];
		UIButton* checkbox = [_buttons objectAtIndex:i];
		
		backgroundView.frame = CGRectMake(11, offset, 241, lineheight);
		reasonLabel.frame = CGRectMake(5, 0, 200, lineheight);
		//checkbox.frame = CGRectMake(210, 1, 28, 30);
		[checkbox setContentEdgeInsets:UIEdgeInsetsMake(0, 205, 3, 4)];
		checkbox.frame = CGRectMake(5, 0, 238, lineheight);
		
		offset = offset+lineheight;
	}
	_doneOrNextButton.frame = CGRectMake(140, 240+5, 106, 25);
	_writeAReviewButton.frame = CGRectMake(20, 240+5, 106, 25);
}

@end
