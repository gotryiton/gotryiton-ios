//
//  GTIOAutoCompleteView.m
//  auto complete stand alone app for GTIOv4
//
//  Created by Simon Holroyd on 6/12/12.
//  Copyright (c) 2012 GO TRY IT ON. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

#import "GTIOAutoCompleteView.h"

@implementation GTIOAutoCompleteView

@synthesize autoCompleteArray = _autoCompleteArray;
@synthesize autoCompleteButtonOptions = _autoCompleteButtonOptions;
@synthesize scrollView = _scrollView;
@synthesize scrollViewBackground = _scrollViewBackground;
@synthesize textInput = _textInput;
@synthesize textView = _textView;
@synthesize previewTextView = _previewTextView;
@synthesize attrString = _attrString;
@synthesize positionOfLastWordTyped =_positionOfLastWordTyped;
@synthesize positionOfLastTwoWordsTyped =_positionOfLastTwoWordsTyped;
@synthesize inputText = _inputText;

@synthesize ACInputFont = _ACInputFont;
@synthesize ACInputColor = _ACInputColor;
@synthesize ACPlaceholderFont = _ACPlaceholderFont;
@synthesize ACPlaceholderColor = _ACPlaceholderColor;
@synthesize ACHighlightFont = _ACHighlightFont;
@synthesize ACHighlightColor = _ACHighlightColor;

@synthesize isScrollViewShowing = _isScrollViewShowing;

- (id)initWithFrame:(CGRect)frame outerBox:(CGRect)outerFrame 
{
    self = [super initWithFrame:outerFrame];
    if (self) {
        // the autoCompleteArray 
        _autoCompleteArray = [[NSMutableArray alloc] init];
        
        // the array of visible autocomplete buttons in the scroll view
        _autoCompleteButtonOptions = [[NSMutableArray alloc] init];
        
        // keep track of text in the input box
        _inputText = [[NSString alloc] initWithString:@""];

        // keep track of the position of the last word the user typed
        _positionOfLastWordTyped = NSMakeRange(0,1);
        
        // keep track of the position of the last two words the user typed
        _positionOfLastTwoWordsTyped = NSMakeRange(0,1);

        CGRect editingFrame = CGRectMake(CGRectGetMinX(frame) , CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame) -50);
        CGRect inputFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame) + 16, CGRectGetHeight(frame) - 50);
        
        /** Set up a textView to allow a user to edit text
         */
        _textInput = [[UITextView alloc] initWithFrame:inputFrame];
        _textInput.returnKeyType = UIReturnKeyDone;
        _textInput.backgroundColor = [UIColor clearColor];
        _textInput.contentInset =  UIEdgeInsetsMake(-10,-8,0,0);
        _textInput.autocorrectionType = UITextAutocorrectionTypeNo;
        _textInput.scrollEnabled = NO;
        [_textInput setDelegate:self];
        [_textInput setFont: [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagLight size:14.f]];
        _textInput.textColor = [UIColor clearColor];
        [self addSubview:self.textInput];

        
        _ACInputColor = CGColorRetain([UIColor gtio_grayTextColor404040].CGColor);
        _ACPlaceholderColor = CGColorRetain([UIColor gtio_lightGrayTextColor].CGColor);
        _ACHighlightColor = CGColorRetain([UIColor gtio_linkColor].CGColor);

        _ACPlaceholderFont = [UIFont gtio_verlagCoreTextFontWithWeight:GTIOFontVerlagLightItalic size:14.f];
        _ACHighlightFont = [UIFont gtio_verlagCoreTextFontWithWeight:GTIOFontVerlagLight size:14.f];
        _ACInputFont = [UIFont gtio_verlagCoreTextFontWithWeight:GTIOFontVerlagLight size:14.f];
        
        /** Create the text layer to display a preview of what the user is typing 
         */
        _textView = [[CATextLayer alloc] init];
        _textView.backgroundColor = [UIColor clearColor].CGColor;
        _textView.wrapped = YES;
        _textView.frame = editingFrame;
        _textView.contentsScale = [[UIScreen mainScreen] scale]; 
        _textView.alignmentMode = kCAAlignmentLeft;
        _textView.opacity = 1.0;
        [self.layer addSublayer:self.textView];
        
        /** Create the text layer to display a preview of what the user is typing 
         */
        _previewTextView = [[CATextLayer alloc] init];
        _previewTextView.backgroundColor = [UIColor clearColor].CGColor;
        _previewTextView.wrapped = YES;
        _previewTextView.frame = editingFrame;
        _previewTextView.contentsScale = [[UIScreen mainScreen] scale]; 
        _previewTextView.alignmentMode = kCAAlignmentLeft;
        _previewTextView.opacity = 0;
        [self.layer addSublayer:self.previewTextView];
        

        /** Add a scroll view for the autocomplete buttons to be viewable in
         */
        _isScrollViewShowing = NO;
        
        CGRect scrollFrameBox = CGRectMake( 0, 0, CGRectGetWidth(self.bounds), 50);
        CGRect scrollFrameBoxOutOfView = CGRectMake( 0, 50, CGRectGetWidth(self.bounds), 50);
        
        UIView *inputAccessoryView = [[UIView alloc] initWithFrame:scrollFrameBox];
        inputAccessoryView.clipsToBounds = YES;
        self.textInput.inputAccessoryView = inputAccessoryView;
        
        _scrollViewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"keyboard-top-control-bg.png"]];
        [_scrollViewBackground setFrame:scrollFrameBoxOutOfView];
        
        [self.textInput.inputAccessoryView addSubview:self.scrollViewBackground];
        
        _scrollView = [[GTIOAutoCompleteScrollView alloc] initWithFrame:scrollFrameBoxOutOfView];
        _scrollView.autoCompleteDelegate = self;
        [self.textInput.inputAccessoryView addSubview:self.scrollView];
        
        // set up attr string
        _attrString = [[NSMutableAttributedString alloc] initWithString:@""];
    }
    return self;
}

- (void)addCompleters:(NSMutableArray *)completers
{
    for (GTIOAutoCompleter *completer in completers) {
        [self.autoCompleteArray addObject:completer];    
    }
}

- (void)showScrollView 
{
    if (!self.isScrollViewShowing) {
        self.isScrollViewShowing = YES;
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            CGRect scrollFrameBox = CGRectMake( 0, self.textInput.inputAccessoryView.bounds.size.height-48, self.textInput.inputAccessoryView.bounds.size.width, 50);
            [self.scrollView setFrame:scrollFrameBox];
            [self.scrollViewBackground setFrame:scrollFrameBox];

        } completion:nil];
    }
}

- (void)hideScrollView 
{
    if (self.isScrollViewShowing){
        self.isScrollViewShowing = NO;
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            CGRect scrollFrameBox = CGRectMake( 0, self.textInput.inputAccessoryView.bounds.size.height-4, self.textInput.inputAccessoryView.bounds.size.width, 50);
            [self.scrollView setFrame:scrollFrameBox];
            [self.scrollViewBackground setFrame:scrollFrameBox];
            
        } completion:^(BOOL finished) {
            [self.scrollView clearScrollView];
        }];
    }
}

- (void)showButtonsWithAutoCompleters:(NSArray *)foundAutoCompleters
{
    [self.scrollView showButtonsWithAutoCompleters: foundAutoCompleters];
    if ([foundAutoCompleters count] > 0) {
        [self showScrollView];
    }
}

#pragma mark UITextViewDelegate methods
- (BOOL)textView:(UITextView *)field shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)inputString 
{
    [self hidePlaceholderText];

    //if the user hit 'done':
    if([inputString isEqualToString:@"\n"]) {
        //close the keyboard and hide the text input
        [field resignFirstResponder];
        
        [self hideScrollView];
        
        return NO;
    }
    
    if ( (field.text.length + inputString.length) > 255) {
        NSLog(@"end of string");
        return NO;
    }

    self.inputText = [field.text stringByReplacingCharactersInRange:range withString:inputString];
    
    [self updateInputDisplayTextInRange:range string:inputString];

    if (self.inputText.length > 0) {
        [self setPositionOfLastWordsTypedInText:[self stringThroughCursorPositionWithRange:range]];
        
        [self highlightHashTag];

        NSArray *foundAutoCompleters = [self searchLastTypedWordsForAutoCompletes];

        if ([foundAutoCompleters count] > 0) {
            [self showButtonsWithAutoCompleters: foundAutoCompleters];
        } else {
            if (![self showAtTagButtons]) {
                [self hideScrollView];
            }
        }
        
        [self cleanUpAttrString];
    } else {
        [self hideScrollView];
        [self displayPlaceholderText];
    }
    
    return YES;
}

- (NSString *)stringThroughCursorPositionWithRange:(NSRange)range 
{
    int cursorPosition = MIN(range.location + range.length +1, self.inputText.length);

    return [self.inputText substringWithRange:NSMakeRange(0,cursorPosition)];    
}

- (void)setPositionOfLastWordsTypedInText:(NSString *)str 
{
    self.positionOfLastWordTyped = NSMakeRange(0, str.length);
    self.positionOfLastTwoWordsTyped = NSMakeRange(0, str.length);
    
    NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:@"\\ ?([\\w\\.\\@\\#&-]*?\\ ?([\\w\\.\\@\\#&-]+))\\ ?$" options:NSRegularExpressionCaseInsensitive error:nil];

    NSArray *matches = [regex matchesInString:str options:0 range:NSMakeRange(0, [str length])];

    for (NSTextCheckingResult *match in matches) {
        self.positionOfLastTwoWordsTyped =  [match rangeAtIndex:1];
        self.positionOfLastWordTyped = [match rangeAtIndex:2];
    }
}

- (NSString *)lastWordTyped
{
    return [[self lastWordTypedInText:self.inputText] lowercaseString];
}

- (NSString *)lastTwoWordsTyped
{
    return [[self lastTwoWordsTypedInText:self.inputText] lowercaseString];
}

- (NSString *)lastWordTypedInText:(NSString *)str
{
    return [str substringWithRange:self.positionOfLastWordTyped];
}

- (NSString *)lastTwoWordsTypedInText:(NSString *)str
{
    return [str substringWithRange:self.positionOfLastTwoWordsTyped];
}

- (void)updateInputDisplayTextInRange:(NSRange)range string:(NSString *)string
{   
    NSDictionary *inputTextAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                   (id)self.ACInputFont, (id)kCTFontAttributeName,
                                   [NSNumber numberWithFloat:0.0], kCTKernAttributeName,                                
                                   self.ACInputColor, (id)kCTForegroundColorAttributeName,
                                   nil];

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string attributes:inputTextAttr];

    [self.attrString replaceCharactersInRange:range withAttributedString:attrStr];
    /* Set the attributes string in the text layer :) */
    self.textView.string = self.attrString;
}

- (void)highlightInputTextInRange:(NSRange)range completerID:(NSString *)completerID type:(NSString *)type
{
    NSDictionary *highlightTextAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                       (id)self.ACHighlightColor, (id)kCTForegroundColorAttributeName, 
                                       completerID, @"completerId",
                                       type, @"completerType",
                                       nil];
    
    [self.attrString addAttributes:highlightTextAttr range:range];
    /* Set the attributes string in the text layer :) */
    self.textView.string = self.attrString;
}

- (void)unHighlightInputTextInRange:(NSRange)range 
{
    [self updateInputDisplayTextInRange:range string:[[self.attrString string] substringWithRange:range]];
}

- (void)displayPlaceholderText 
{
    NSArray *highlights = [[NSArray alloc] init];
    [self displayPlaceholderText:@"How does this Zara top look? @Becky #wedding" highlightedStrings:highlights];

    if (self.previewTextView.opacity ==0){
        [UIView animateWithDuration:1.75 delay:0.0f options:UIViewAnimationCurveEaseOut animations:^{
            self.previewTextView.opacity = 1;
        } completion:nil];
    }
}

- (void)displayPlaceholderText:(NSString *)text highlightedStrings:(NSArray *)highlights
{
    NSDictionary *placeholderTextAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                         (id)self.ACPlaceholderFont, (id)kCTFontAttributeName,
                                         [NSNumber numberWithFloat:0.0], kCTKernAttributeName,
                                         self.ACPlaceholderColor, (id)kCTForegroundColorAttributeName,
                                         nil];

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text attributes:placeholderTextAttr];

    NSDictionary *highlightTextAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                       (id)self.ACHighlightColor, (id)kCTForegroundColorAttributeName, 
                                       nil];

    for (NSString *highlight in highlights) {
        NSRange range = [[attrStr string] rangeOfString:highlight];
        if (range.location != NSNotFound) {
            [attrStr addAttributes:highlightTextAttr range:range];
        }
    }

    self.previewTextView.string = attrStr;
}

- (void) hidePlaceholderText 
{
    if (self.previewTextView.opacity==1){
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
            self.previewTextView.opacity = 0;
        } completion:nil];    
    }
}

- (void) showPlaceholderText
{
    if (self.inputText.length == 0) {
        [self displayPlaceholderText];
    }
}

- (void) highlightHashTag
{
    NSString *lastword = [self.inputText substringWithRange:self.positionOfLastWordTyped];

    if ([[lastword substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"#"]){
        [self highlightInputTextInRange:self.positionOfLastWordTyped completerID:[[self lastWordTyped] substringWithRange:NSMakeRange(1, [self lastWordTyped].length - 1 )] type:@"#" ];    
    }
}

- (NSMutableArray *)searchLastTypedWordsForAutoCompletes
{
    // Put anything that starts with this substring into the autocompleteButtons array
    // The items in this array is what will show up in the scroll view
    NSMutableArray *foundAutoCompleters = [[NSMutableArray alloc] init];

    for (GTIOAutoCompleter *option in self.autoCompleteArray) {
        if ([self startedTypingCompleterInLastTwoWords:option]) {
            [foundAutoCompleters addObject:option];  
        } else if ([self startedTypingCompleterInLastWord:option] ){
            [foundAutoCompleters addObject:option];
        }
    }
    return foundAutoCompleters;
}

- (BOOL)startedTypingCompleterInLastTwoWords:(GTIOAutoCompleter *)completer
{
    // NSLog(@"lastword %@", [self lastWordTypedInText:self.inputText]);
    if ([[completer.name lowercaseString] rangeOfString:[self lastTwoWordsTyped]].location == 0 && [self lastTwoWordsTyped].length > 1) {
        return true; 
        // NSLog(@"found %@", completer.key);
    }
    else if ([[[self lastTwoWordsTyped] substringWithRange:NSMakeRange(0,1)] isEqualToString:@"@"] && [self lastTwoWordsTyped].length > 1){
        NSRange substringRange = [[completer.name lowercaseString] rangeOfString:[[self lastTwoWordsTyped] substringWithRange:NSMakeRange(1, [self lastTwoWordsTyped].length - 1)]];
        if (substringRange.location == 0 && [completer.type isEqualToString:@"@"]){
            // NSLog(@"found %@", completer.key);
            return true; 
        }
    }
    return false;
}

- (BOOL)startedTypingCompleterInLastWord:(GTIOAutoCompleter *)completer
{
    // NSLog(@"lastword %@", [self lastWordTypedInText:self.inputText]);
    if ([[completer.name lowercaseString] rangeOfString:[self lastWordTyped]].location == 0 && [self lastWordTyped].length>1) {
        return true;
    }
    else if ([[[self lastWordTyped] substringWithRange:NSMakeRange(0,1)] isEqualToString:@"@"] && [self lastWordTyped].length > 1 ){
        NSRange substringRange = [[completer.name lowercaseString] rangeOfString:[[self lastWordTyped] substringWithRange:NSMakeRange(1, [self lastWordTyped].length - 1)]];
        if (substringRange.location == 0 && [completer.type isEqualToString:@"@"]){
            return true;
        }
    }
    return false;
}

#pragma mark - GTIOAutoCompleteViewDelegate

- (void)autoCompleterIDSelected:(NSString*)completerID 
{
    GTIOAutoCompleter *completer = [self completerWithID:completerID];
    
    if ([self startedTypingCompleterInLastWord:completer] | [[self lastWordTyped] isEqualToString:@"@"] ) {
        [self doAutoCompleteWithCompleter:completer inRange:self.positionOfLastWordTyped];
        [self highlightInputTextInRange:self.positionOfLastWordTyped completerID:completer.completerID type:completer.type];
    }
    else if ([self startedTypingCompleterInLastTwoWords:completer]){
        [self doAutoCompleteWithCompleter:completer inRange:self.positionOfLastTwoWordsTyped];
        [self highlightInputTextInRange:self.positionOfLastTwoWordsTyped completerID:completer.completerID type:completer.type];
    }
    [self hideScrollView];
}

#pragma mark -

- (GTIOAutoCompleter *)completerWithID:(NSString *)completerID 
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"completerID like %@", completerID];
    NSArray *results = [self.autoCompleteArray filteredArrayUsingPredicate:predicate];

    if ([results count] > 0) {
        return [results objectAtIndex:0];    
    }
    
    return nil;
}

- (void)doAutoCompleteWithCompleter:(GTIOAutoCompleter *)completer inRange:(NSRange)range
{
    self.inputText = [self.inputText stringByReplacingCharactersInRange:range withString:[completer completerString]];

    [self updateInputDisplayTextInRange:range string:[completer completerString]];

    range.length = range.length + ([completer completerString].length - range.length);

    [self highlightInputTextInRange:range completerID:completer.completerID type:completer.type];

    range.location = range.location + range.length ;
    range.length = 0;

    self.inputText = [self.inputText stringByReplacingCharactersInRange:range withString:@" "];

    [self updateInputDisplayTextInRange:range string:@" "];

    self.textInput.text = self.inputText;
}

- (NSArray *)atTagCompleters
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type like %@", @"@"];
    return [self.autoCompleteArray filteredArrayUsingPredicate:predicate];
}

- (BOOL)showAtTagButtons 
{
    if([[self lastWordTyped] isEqualToString:@"@"]) {
        NSArray *completers = [self atTagCompleters];
        if ([completers count] > 0){
            [self showButtonsWithAutoCompleters:[self atTagCompleters]];

            return true;
        }
    }
    return false;
}

- (void)cleanUpAttrString 
{
    NSDictionary *attributes;
    NSRange effectiveRange = { 0, 0 }; 
    do { 
        NSRange range = NSMakeRange (NSMaxRange(effectiveRange), [self.attrString length] - NSMaxRange(effectiveRange));
        attributes = [self.attrString attributesAtIndex:range.location longestEffectiveRange: &effectiveRange inRange:range ];
        
        if ([attributes objectForKey:@"completerType"]) {
            GTIOAutoCompleter * completer = [self completerWithID:[attributes objectForKey:@"completerId"]];

            //if its a hashtag, make sure the hashtag is at the front of the string
            if ([[attributes objectForKey:@"completerType"] isEqualToString:@"#"]){

                NSRange hash = [[[self.attrString string] substringWithRange:effectiveRange] rangeOfString:@"#"];
                if (hash.location !=0) {
                    [self unHighlightInputTextInRange:effectiveRange];
                }
            }
            // if its some other tag, make sure the string still matches
            else if (![[[self.attrString string] substringWithRange:effectiveRange] isEqualToString:[completer completerString]]){
                [self unHighlightInputTextInRange:effectiveRange];
            }
        }
    } while (NSMaxRange(effectiveRange) < [self.attrString length]); 
}

- (NSString *)processDescriptionString
{
    if ([self.attrString length] == 0) {
        return @"";
    }
    
    NSString *response = @"";
    NSDictionary *attributes;
    NSRange effectiveRange = { 0, 0 }; 
    do { 
        NSRange range = NSMakeRange (NSMaxRange(effectiveRange), [self.attrString length] - NSMaxRange(effectiveRange));
        attributes = [self.attrString attributesAtIndex:range.location longestEffectiveRange: &effectiveRange inRange:range ];

        if ([attributes objectForKey:@"completerType"] ){
            response = [response stringByAppendingFormat:@"{%@{%@{%@}}}", [attributes objectForKey:@"completerType"], [attributes objectForKey:@"completerId"], [[self.attrString string] substringWithRange:effectiveRange]];
        } else {
            response = [response stringByAppendingString:[[self.attrString string] substringWithRange:effectiveRange]];    
        }
    } while (NSMaxRange(effectiveRange) < [self.attrString length]); 

    NSLog (@"submission string: %@ ", response);
    return response;
}

- (void)resetView
{
    self.inputText = @"";
    self.attrString = [[NSMutableAttributedString alloc] initWithString:@""];
    self.textInput.text = @"";
    self.textView.string = self.attrString;
}

@end
