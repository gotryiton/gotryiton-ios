//
//  GTIOTellUsAboutItViewController.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/31/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOTellUsAboutItViewController.h"
#import "GTIOPhoto.h"
#import "GTIOSectionedDataSource.h"
#import "GTIOTableImageControlItem.h"
#import "TTTableViewDelegate+GTIOAdditions.h"
#import <TTSectionedDataSource+TWTAdditions.h>
#import "GTIOControlTableViewVarHeightDelegate.h"
#import "GTIOHeaderView.h"
#import "GTIOGetAnOpinionViewController.h";

@implementation GTIOTellUsAboutItViewController

@synthesize opinionRequest = _opinionRequest;

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if (self = [super initWithNavigatorURL:URL query:query]) {
		self.opinionRequest = [query objectForKey:@"opinionRequest"];
		
		// Navigation Item
		self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:TTSTYLEVAR(tellUsAboutItTitleImage)] autorelease];		
		self.navigationItem.backBarButtonItem = [[[GTIOBarButtonItem alloc] initWithTitle:@"back" 
																				  
																				 target:nil 
																				 action:nil] autorelease];
		self.navigationItem.rightBarButtonItem = [[[GTIOBarButtonItem alloc] initWithTitle:@"next" 
																				   
																				  target:self 
																				  action:@selector(nextButtonWasTouched:)] autorelease];
		
		// Controls
        NSArray* components = nil;
        if ([self.opinionRequest whereYouAreGoingChoices]) {
            components = [NSArray arrayWithObject:[self.opinionRequest whereYouAreGoingChoices]];
        } else {
            NSLog(@"WARNING: where are you going choices were not loaded!");
        }
		_whereYouAreGoingPicker = [[TWTPickerControl alloc] initWithFrame:CGRectMake(0, 0, 177, 30)];
		_whereYouAreGoingPicker.dataSource = [[TWTPickerDataSource alloc] initWithComponents:components];
		_whereYouAreGoingPicker.textLabel.textAlignment = UITextAlignmentRight;
		_whereYouAreGoingPicker.textLabel.textColor = TTSTYLEVAR(pinkColor);
		_whereYouAreGoingPicker.font = [UIFont boldSystemFontOfSize:14];
		_whereYouAreGoingPicker.placeholderText = @"select option";
		_whereYouAreGoingPicker.toolbar.tintColor = TTSTYLEVAR(navigationBarTintColor);
		UIImageView* titleView = [GTIOHeaderView viewWithText:@"SOMETHING LIKE"];
		_whereYouAreGoingPicker.titleView = titleView;
		_whereYouAreGoingPicker.doneButton.title = @"done";
		_whereYouAreGoingPicker.nextButton.title = @"next";
		_whereYouAreGoingPicker.delegate = self;

		_tellUsMoreAboutItTextView = [[TTTextEditor alloc] init];
		_tellUsMoreAboutItTextView.delegate = self;
		[_tellUsMoreAboutItTextView setShowsExtraLine:YES];
		[_tellUsMoreAboutItTextView setMaxNumberOfLines:3];
		_tellUsMoreAboutItTextView.textColor = TTSTYLEVAR(greyTextColor);
		_tellUsMoreAboutItTextView.font = [UIFont systemFontOfSize:14];
		_tellUsMoreAboutItTextView.returnKeyType = UIReturnKeyNext;
        
        // Set up fake placholders to work around wrapping issue
        _tellUsAboutItPlaceholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 275, 35)];
        _tellUsAboutItPlaceholderLabel.textColor = [UIColor lightGrayColor];
        _tellUsAboutItPlaceholderLabel.font = [UIFont italicSystemFontOfSize:14];
        _tellUsAboutItPlaceholderLabel.numberOfLines = 2;
        _tellUsAboutItPlaceholderLabel.text = @"e.g. I'm going for a bohemian style that is chic but not too much...";
        [_tellUsMoreAboutItTextView addSubview:_tellUsAboutItPlaceholderLabel];
        [_tellUsAboutItPlaceholderLabel release];

        // Table View
        self.tableViewStyle = UITableViewStyleGrouped;
        self.variableHeightRows = YES;
        self.autoresizesForKeyboard = YES;
        
		// Initialize the content
		if (self.opinionRequest.whereYouAreGoing &&
			[[self.opinionRequest whereYouAreGoingChoices] containsObject:self.opinionRequest.whereYouAreGoing]) {
			int index = [[self.opinionRequest whereYouAreGoingChoices] indexOfObject:self.opinionRequest.whereYouAreGoing];
			_whereYouAreGoingPicker.selection = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:index], nil];
		}
		_tellUsMoreAboutItTextView.text = self.opinionRequest.tellUsMoreAboutIt;
		
        UIBarButtonItem* cancelButton = [[[GTIOBarButtonItem alloc] initWithTitle:@"cancel" 
                                                                          
                                                                         target:self 
                                                                         action:@selector(cancelButtonWasTouched:)] autorelease];
        self.navigationItem.leftBarButtonItem = cancelButton;
	}
	
	return self;
}

- (void)loadView {
    [super loadView];
    UIImage* topShadow = [UIImage imageNamed:@"list-top-shadow.png"];
    UIView* topShadowImageView = [[[UIImageView alloc] initWithImage:topShadow] autorelease];
    [self.view addSubview:topShadowImageView];
}

- (id<UITableViewDelegate>)createDelegate {
	return [[[GTIOControlTableViewVarHeightDelegate alloc] initWithController:self] autorelease];
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_opinionRequest);

	[super dealloc];
}

- (TTTextEditor*)brandsTextViewForPhoto:(GTIOPhoto*)photo {
	TTTextEditor* textView = [[TTTextEditor alloc] init];
	textView.delegate = self;
	textView.textColor = TTSTYLEVAR(greyTextColor);
	textView.font = [UIFont systemFontOfSize:14];
	[textView setShowsExtraLine:YES];
	textView.text = photo.brandsYouAreWearing;    
    
	if ([self.opinionRequest.photos lastObject] == photo) {
		textView.returnKeyType = UIReturnKeyDone;
	} else {
		textView.returnKeyType = UIReturnKeyNext;
	}
	
	return textView;
}

- (void)createModel {
	// TODO: Assert that there is at least 1 photo!!!
	
	if (1 < [self.opinionRequest.photos count]) {
		NSArray* firstSection = [NSArray arrayWithObjects:
								 [TTTableControlItem itemWithCaption:@"where you're going:" control:_whereYouAreGoingPicker],
								 [TTTableControlItem itemWithCaption:@"tell us more about it:" control:(UIControl*)_tellUsMoreAboutItTextView],
								 nil];
		
		NSMutableArray* brandsSection = [NSMutableArray arrayWithCapacity:[self.opinionRequest.photos count]];
		for (GTIOPhoto* photo in self.opinionRequest.photos) {
			NSUInteger photoNumber = [self.opinionRequest.photos indexOfObject:photo] + 1;
			NSString* caption = [NSString stringWithFormat:@"outfit %d", photoNumber];
			TTTextEditor* brandsTextView = [self brandsTextViewForPhoto:photo];
			GTIOTableImageControlItem* item = [GTIOTableImageControlItem itemWithCaption:caption image:photo.image control:(UIControl*)brandsTextView];
			item.shouldInsetImage = YES;
			[brandsSection addObject:item];
		}
		
		self.dataSource = [GTIOSectionedDataSource dataSourceWithArrays:
						   @"",
						   firstSection,
						   @"brands you're wearing:",
						   brandsSection,
						   nil];
	} else {
		GTIOPhoto* photo = [self.opinionRequest.photos objectAtIndex:0];
		TTTextEditor* brandsTextView = [self brandsTextViewForPhoto:photo];
        
        _brandsPlaceholderTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 275, 20)];
        _brandsPlaceholderTextLabel.textColor = [UIColor lightGrayColor];
        _brandsPlaceholderTextLabel.font = [UIFont italicSystemFontOfSize:14];
        _brandsPlaceholderTextLabel.numberOfLines = 1;
        _brandsPlaceholderTextLabel.text = @"Anthropologie, Top Shop, Zara";
        [brandsTextView addSubview:_brandsPlaceholderTextLabel];
        [_brandsPlaceholderTextLabel release];
		
		self.dataSource = [TTListDataSource dataSourceWithObjects:
						   [TTTableControlItem itemWithCaption:@"where you're going:" control:_whereYouAreGoingPicker],
						   [TTTableControlItem itemWithCaption:@"tell us more about it:" control:(UIControl*)_tellUsMoreAboutItTextView],
						   [TTTableControlItem itemWithCaption:@"brands you're wearing:" control:(UIControl*)brandsTextView],
						   nil];
	}	
}

- (void)writeBrandsInfoToPhotos {
	if ([self.dataSource isKindOfClass:[TTListDataSource class]]) {
		// Single photo
		GTIOPhoto* photo = [self.opinionRequest.photos objectAtIndex:0];
		TTTableControlItem* brandsTableItem = [[(TTListDataSource*)self.dataSource items] lastObject];
		photo.brandsYouAreWearing = [(TTTextEditor*)brandsTableItem.control text];
	} else if ([self.dataSource isKindOfClass:[TTSectionedDataSource class]]) {
		// Multiple photos
		NSArray* items = [[(TTSectionedDataSource*)self.dataSource items] objectAtIndex:1];
		for (TTTableControlItem* item in items) {
			TTTextEditor* editor = (TTTextEditor*) item.control;
			NSUInteger index = [items indexOfObject:item];
			GTIOPhoto* photo = [self.opinionRequest.photos objectAtIndex:index];
			photo.brandsYouAreWearing = editor.text;
		}
	}	
}

#pragma mark Actions

- (void)nextButtonWasTouched:(id)sender {
	// TODO: set this to the ID of the event.
	
	self.opinionRequest.whereYouAreGoing = [self.opinionRequest indexForEventType:_whereYouAreGoingPicker.selectionText];
	self.opinionRequest.tellUsMoreAboutIt = _tellUsMoreAboutItTextView.text;
	[self writeBrandsInfoToPhotos];
	
	if ([self.opinionRequest isValid]) {
		// TODO: Push this up into the opinion request session?
		NSDictionary* query = [NSDictionary dictionaryWithObject:self.opinionRequest forKey:@"opinionRequest"];
		[[TTNavigator navigator] openURLAction:
		 [[[TTURLAction actionWithURLPath:@"gtio://getAnOpinion/share"] 
		   applyQuery:query]
		  applyAnimated:YES]];
	} else {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"whoops!  you forgot to..."
															message:[self.opinionRequest validationErrorsSummary]
														   delegate:nil 
												  cancelButtonTitle:@"Close" 
												  otherButtonTitles:nil];
		[alertView show];
	}
}

- (void)cancelButtonWasTouched:(id)sender {
    // if we are poping back to the 1. take a picture view
    // then don't remove all objects.
    UIViewController* vc = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers indexOfObject:self] - 1];
    if ([vc isKindOfClass:[GTIOGetAnOpinionViewController class]]) {
        [self.opinionRequest.photos removeAllObjects];
    }
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)picker:(TWTPickerControl*)picker nextButtonWasTouched:(id)sender {
	UIControl* control = [(TTListDataSource*)self.dataSource nextSiblingControlToControl:(UIControl*)picker];
	[control becomeFirstResponder];
	[self.tableView scrollFirstResponderIntoView];
}

#pragma mark - TTTextEditorDelegate

- (void)textEditorDidBeginEditing:(TTTextEditor*)textEditor {
    UILabel* placeholder = (textEditor == _tellUsMoreAboutItTextView) ? _tellUsAboutItPlaceholderLabel : _brandsPlaceholderTextLabel;
    placeholder.hidden = YES;
}

- (void)textEditorDidEndEditing:(TTTextEditor*)textEditor {
    UILabel* placeholder = (textEditor == _tellUsMoreAboutItTextView) ? _tellUsAboutItPlaceholderLabel : _brandsPlaceholderTextLabel;
    if ([textEditor.text length] == 0) {
        placeholder.hidden = NO;
    } else {
        placeholder.hidden = YES;
    }
}

#pragma mark UITextViewDelegate methods

- (BOOL)textViewShouldReturn:(UITextView*)textView {
	UIControl* nextControl = [(TTListDataSource*)self.dataSource nextSiblingControlToControl:(UIControl*)textView];
	if (nextControl) {
		[nextControl becomeFirstResponder];
		[self.tableView scrollFirstResponderIntoView];
	} else {
		[textView resignFirstResponder];
	}
	
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
	NSInteger maxLength = (textView == (UITextView*)_tellUsMoreAboutItTextView) ? 320 : 92;
	
	if (newTextLength <= maxLength) {
		textView.scrollEnabled = NO;
		return YES;
	}
	return NO;
}

- (BOOL)textEditor:(TTTextEditor*)textEditor shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)replacementText {
	if ([replacementText isEqualToString:@"\n"]) {
		if ([self respondsToSelector:@selector(textViewShouldReturn:)]) {
			if (![self performSelector:@selector(textViewShouldReturn:) withObject:textEditor]) {
				return NO;
			}
		}
	}
	
	// Enforce maximum length for fields
	// New length is the current length of the text, plus the length of the replacement text, minus any characters being replaced
	NSInteger newTextLength = [textEditor.text length] + [replacementText length] - range.length;
	NSInteger maxLength = (textEditor == _tellUsMoreAboutItTextView) ? 320 : 92;
	
	if (newTextLength <= maxLength) {
		//textEditor.scrollEnabled = NO;
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
