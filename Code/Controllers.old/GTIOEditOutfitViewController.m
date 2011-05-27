//
//  GTIOEditOutfitViewController.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/31/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOEditOutfitViewController.h"
#import "GTIOHeaderView.h"
#import "GTIOSectionedDataSource.h"
#import "GTIOControlTableViewVarHeightDelegate.h"

@implementation GTIOEditOutfitViewController

@synthesize outfitViewController = _outfitViewController;
@synthesize outfit = _outfit;

- (void)dealloc {
	[_outfit release];
	_outfit = nil;

	[_outfitViewController release];
	_outfitViewController = nil;

	[super dealloc];
}

- (NSArray*)whereYouAreGoingChoices {
	return [[GTIOUser currentUser].eventTypes valueForKeyPath:@"type"];
}

- (NSString*)whereYouAreGoingChoiceWithID:(NSNumber*)choiceID {
	NSArray* events = [GTIOUser currentUser].eventTypes;
	for (NSDictionary* event in events) {
		if ([[event valueForKey:@"id"] isEqual:choiceID]) {
			return [event valueForKey:@"type"];
		}
	} 
	return nil;
}

- (NSNumber*)indexForEventType:(NSString*)type {
	return [[[GTIOUser currentUser].eventTypes objectWithValue:type forKey:@"type"] valueForKeyPath:@"id"];
}

- (id<UITableViewDelegate>)createDelegate {
	return [[[GTIOControlTableViewVarHeightDelegate alloc] initWithController:self] autorelease];
}

- (void)loadView {
	[super loadView];
	self.navigationItem.titleView = [GTIOHeaderView viewWithText:@"EDIT OUTFIT"];
	
	// Controls
	NSArray* components = [NSArray arrayWithObject:[self whereYouAreGoingChoices]];
	_whereYouAreGoingPicker = [[TWTPickerControl alloc] initWithFrame:CGRectMake(0, 0, 177, 30)];
	_whereYouAreGoingPicker.dataSource = [[TWTPickerDataSource alloc] initWithComponents:components];
	_whereYouAreGoingPicker.textLabel.textAlignment = UITextAlignmentRight;
	_whereYouAreGoingPicker.textLabel.textColor = TTSTYLEVAR(pinkColor);
	_whereYouAreGoingPicker.font = [UIFont boldSystemFontOfSize:14];
	_whereYouAreGoingPicker.placeholderText = @"select option";
	_whereYouAreGoingPicker.toolbar.tintColor = TTSTYLEVAR(navigationBarTintColor);
	UIImageView* titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"something-like.png"]] autorelease];
	_whereYouAreGoingPicker.titleView = titleView;
	_whereYouAreGoingPicker.doneButton.title = @"done";
	_whereYouAreGoingPicker.nextButton.title = @"next";
	_whereYouAreGoingPicker.delegate = self;
	
	NSLog(@"Event Types: %@", [GTIOUser currentUser].eventTypes);
	NSString* event = [self whereYouAreGoingChoiceWithID:_outfit.eventId];//[[self whereYouAreGoingChoices] objectAtIndex:[_outfit.eventId intValue]]
	[_whereYouAreGoingPicker setSelection:[NSMutableArray arrayWithObject:event]];
	_whereYouAreGoingPicker.textLabel.text = event;
	
	_tellUsMoreAboutItTextView = [[UITextView alloc] init];
	_tellUsMoreAboutItTextView.delegate = self;
	_tellUsMoreAboutItTextView.textColor = TTSTYLEVAR(greyTextColor);
	_tellUsMoreAboutItTextView.font = [UIFont systemFontOfSize:14];
	_tellUsMoreAboutItTextView.returnKeyType = UIReturnKeyDone;
	_tellUsMoreAboutItTextView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
	_tellUsMoreAboutItTextView.text = _outfit.descriptionString;
	
	UIBarButtonItem* cancelButton = [[[GTIOBarButtonItem alloc] initWithTitle:@"cancel"
																	  
																	 target:self
																	 action:@selector(cancelButtonWasPressed:)] autorelease];
	self.navigationItem.leftBarButtonItem = cancelButton;
	
	UIBarButtonItem* saveButton = [[[GTIOBarButtonItem alloc] initWithTitle:@"save"
																	style:UIBarButtonItemStyleDone
																   target:self
																   action:@selector(saveButtonWasPressed:)] autorelease];
	self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)createModel {
	NSArray* firstSection = [NSArray arrayWithObjects:
							 [TTTableControlItem itemWithCaption:@"where you're going:" control:_whereYouAreGoingPicker],
							 [TTTableControlItem itemWithCaption:@"tell us more about it:" control:(UIControl*)_tellUsMoreAboutItTextView],
							 nil];
	
	self.dataSource = [GTIOSectionedDataSource dataSourceWithArrays:
					   @"",
					   firstSection,
					   nil];
}

- (void)cancelButtonWasPressed:(id)sender {
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)saveButtonWasPressed:(id)sender {
	NSNumber* eventID = [self indexForEventType:_whereYouAreGoingPicker.selectionText];
	NSString* description = _tellUsMoreAboutItTextView.text;
	[self.navigationController dismissModalViewControllerAnimated:YES];
	[_outfitViewController saveOutfit:_outfit withNewEventID:eventID description:description];
}

- (void)picker:(TWTPickerControl*)picker nextButtonWasTouched:(id)sender {
	UIControl* control = [(TTListDataSource*)self.dataSource nextSiblingControlToControl:(UIControl*)picker];
	[control becomeFirstResponder];
	[self.tableView scrollFirstResponderIntoView];
}

- (BOOL)textViewShouldReturn:(UITextView*)textView {
	[textView resignFirstResponder];
	
	return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {
		if ([self respondsToSelector:@selector(textViewShouldReturn:)]) {
			if (![self performSelector:@selector(textViewShouldReturn:) withObject:textView]) {
				return NO;
			}
		}
	}
	
	// Enforce maximum length for fields
	// New length is the current length of the text, plus the length of the replacement text, minus any characters being replaced
	NSInteger newTextLength = [textView.text length] + [text length] - range.length;
	NSInteger maxLength = (textView == _tellUsMoreAboutItTextView) ? 320 : 92;
	
	if (newTextLength <= maxLength) {
		textView.scrollEnabled = NO;
		return YES;
	}
	return NO;
}

- (void)textViewDidChange:(UITextView *)textView {
	// Controls the scrolling of the text view so it shows two lines instead of one.
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(enableScrolling:) object:textView];
	
	int location = (NSNotFound == textView.selectedRange.location) ? 0 : textView.selectedRange.location;
	NSString* text = [textView.text substringToIndex:location + textView.selectedRange.length];
	CGSize size = [text sizeWithFont:textView.font constrainedToSize:CGRectInset(textView.bounds, 5, 0).size];
	if (size.height >= 50) {
		CGPoint newOffset = CGPointMake(textView.contentOffset.x, size.height - 25);
		[textView setContentOffset:newOffset animated:YES];
		textView.scrollEnabled = NO;
	} else {
		CGPoint newOffset = CGPointMake(0,0);
		[textView setContentOffset:newOffset animated:YES];
		textView.scrollEnabled = NO;
	}
	[self performSelector:@selector(enableScrolling:) withObject:textView afterDelay:0.2];
}

- (void)enableScrolling:(UITextView*)textView {
	textView.scrollEnabled = YES;
}


@end
